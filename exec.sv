`default_nettype none
`include "inst_set.sv"

function ltf(input [31:0] a, input [31:0] b);
	begin
		ltf = (a[31] == b[31] && ((a[30:0] < b[30:0])^a[31])) || (a[31] != b[31] && a[31] && (b[30:0] != 31'h0 || a[30:0] != 31'h0));
	end
endfunction

function do_forward(input [5:0] opecode, input fmode, input [4:0] rd_no, input [4:0] rs_no);
	begin
		do_forward = is_write_inst(opecode) && opecode[5] == fmode && (fmode || rd_no != 5'h0) && rd_no == rs_no;
	end
endfunction

module exec_inner(
	input wire enable,
	output reg done,
	output wire stop,

	input wire[5:0] opecode,
	input wire[15:0] offset,
	input wire[31:0] pc,
	input wire[31:0] rs,
	input wire[31:0] rt,
	input wire[4:0] rd_no,
	input wire[4:0] rs_no,
	input wire[4:0] rt_no,
	input wire fmode1,
	input wire fmode2,

	output reg pcenable,
	output reg [31:0] next_pc,
	output reg wenable,
	output reg wfmode,
	output reg [4:0] wreg,
	output wire [31:0] wdata,

	output reg uart_wenable,
	input wire uart_wdone,
	output reg[31:0] uart_wd,
	output reg uart_renable,
	input wire uart_rdone,
	input wire[31:0] uart_rd,

	output wire[18:0] mem_addr,
	output wire[31:0] mem_wdata,
	input wire[31:0] mem_rdata,
	output wire mem_enable,
	output wire[3:0] mem_wea,

	input wire clk,
	input wire rstn
);

	reg[31:0] fs, ft, fs_div;
	wire[31:0] fadd_d, fmul_d, finv_d, sqrt_d, ftoi_d, itof_d, floor_d;
	wire fadd_of, fmul_of, finv_of, fmul_uf, finv_uf;

	fadd u_fadd(clk, fs, ft, fadd_d, fadd_of);
	fmul u_fmul(clk, fs, ft, fmul_d, fmul_of, fmul_uf);
	finv u_finv(clk, ft, finv_d, finv_of, finv_uf);
	fsqrt u_fsqrt(clk, fs, sqrt_d);
	ftoi u_ftoi(fs, ftoi_d);
	itof u_itof(fs, itof_d);
	floor u_floor(fs, floor_d);

	reg[5:0] opecode_1, opecode_2;
	reg[31:0] data_1, data_2;
	reg[4:0] rd_no_1, rd_no_2;
	reg[7:0] wait_1, wait_2;
	wire[31:0] rs_0, rt_0;
	wire[31:0] data_select_1, data_select_2;
	wire stall;
	reg stalled;

	task nop();
		begin
			opecode_1 <= INST_J;
		end
	endtask

	assign wdata = data_2;

	assign data_select_1 = opecode_1[3:0] == 4'b0001	? mem_rdata :
						   opecode_1 == INST_FADD		? fadd_d :
						   opecode_1 == INST_FSUB		? fadd_d :
						   opecode_1 == INST_FMUL		? fmul_d :
						   opecode_1 == INST_SQRT		? sqrt_d :
						   opecode_1 == INST_FLOOR		? floor_d :
						   opecode_1 == INST_FTOI		? ftoi_d :
						   opecode_1 == INST_ITOF		? itof_d : 32'h0;
	
	assign data_select_2 = opecode_2[3:0] == 4'b0001	? mem_rdata :
						   opecode_2 == INST_FADD		? fadd_d :
						   opecode_2 == INST_FSUB		? fadd_d :
						   opecode_2 == INST_FMUL		? fmul_d :
						   opecode_2 == INST_SQRT		? sqrt_d :
						   opecode_2 == INST_FLOOR		? floor_d :
						   opecode_2 == INST_FTOI		? ftoi_d :
						   opecode_2 == INST_ITOF		? itof_d : 32'h0;

	assign rs_0 = do_forward(opecode_1, fmode1, rd_no_1, rs_no) ? 
					(wait_1[0] ? data_select_1 : data_1) :
				  do_forward(opecode_2, fmode1, rd_no_2, rs_no) ? data_2 : rs;
	assign rt_0 = do_forward(opecode_1, fmode2, rd_no_1, rt_no) ?
					(wait_1[0] ? data_select_1 : data_1) :
				  do_forward(opecode_2, fmode2, rd_no_2, rt_no) ? data_2 : rt;

	assign mem_addr = rs_0 + {{16{offset[15]}}, offset};
	assign mem_wdata = rt_0;
	assign mem_enable = enable && ~stall && ~stalled && ~stop;
	assign mem_wea = opecode[3:0] == 4'h0 ? 4'hf : 4'h0;

	assign stall = (is_branch_inst(opecode_1) || opecode_1 == INST_JALR) && pc != next_pc;
	assign stop = ((do_forward(opecode_1, fmode1, rd_no_1, rs_no) || do_forward(opecode_1, fmode2, rd_no_1, rt_no)) && |wait_1[7:1]) ||
					(opecode_1 == INST_FDIV && use_fpu_inst(opecode) && wait_1[2]) ||
					(opecode == INST_OUTB && opecode_1 == INST_OUTB && wait_1[7] && ~uart_wdone) ||
					(opecode[3:0] == 4'b1111 && opecode_1[3:0] == 4'b1111 && wait_1[7] && ~uart_rdone);

	always @(posedge clk) begin
		if(~rstn) begin
			done <= 1'b0;
			pcenable <= 1'b0;
			next_pc <= 32'h0;
			wenable <= 1'b0;
			wfmode <= 1'b0;
			wreg <= 5'h0;
			uart_wenable <= 1'b0;
			uart_wd <= 32'h0;
			uart_renable <= 1'b0;
			fs <= 32'h0;
			ft <= 32'h0;
			opecode_1 <= INST_J;
			data_1 <= 32'h0;
			rd_no_1 <= 5'h0;
			wait_1 <= 8'h0;
			opecode_2 <= INST_J;
			data_2 <= 32'h0;
			rd_no_2 <= 5'h0;
			wait_2 <= 8'h0;
			stalled <= 1'b1;
		end else begin
			uart_renable <= 1'b0;
			uart_wenable <= 1'b0;
			wait_1[6:0] <= {1'b0, wait_1[6:1]};
			wait_2 <= {wait_2[7], 1'b0, wait_2[6:1]};
			done <= 1'b0;
			wenable <= 1'b0;
			if(enable) begin
				pcenable <= 1'b0;
				stalled <= 1'b0;
				opecode_1 <= opecode;
				rd_no_1 <= rd_no;
				wait_1 <= 8'h0;
				opecode_2 <= opecode_1;
				data_2 <= data_1;
				rd_no_2 <= rd_no_1;
				wait_2 <= {wait_1[7], 1'b0, wait_1[6:1]};
				if(stalled) begin
					nop();
				end else if(stall) begin
					stalled <= 1'b1;
					nop();
				end else if(stop) begin
					nop();
				end else begin
					next_pc <= pc + 32'h4;
					pcenable <= is_branch_inst(opecode) || opecode == INST_JALR;
					fs <= rs_0;
					ft <= rt_0;
					fs_div <= fs;
					if(opecode[3:0] == 4'b0000) begin
					end else if(opecode[3:0] == 4'b0001) begin
						wait_1 <= 8'h1;
					end else if(opecode == INST_ADD) begin
						data_1 <= rs_0 + rt_0;
					end else if(opecode == INST_SUB) begin
						data_1 <= rs_0 - rt_0;
					end else if(opecode == INST_MUL) begin
						data_1 <= rs_0 * rt_0;
					end else if(opecode == INST_XOR) begin
						data_1 <= rs_0 ^ rt_0;
					end else if(opecode == INST_ADDI) begin
						data_1 <= rs_0 + {{16{offset[15]}}, offset};
					end else if(opecode == INST_SLLI) begin
						data_1 <= rs_0 << offset[4:0];
					end else if(opecode == INST_ORI) begin
						data_1 <= rs_0 | {16'h0, offset};
					end else if(opecode == INST_FADD) begin
						wait_1 <= 8'h2;
					end else if(opecode == INST_FSUB) begin
						ft <= {~rt[31], rt[30:0]};
						wait_1 <= 8'h2;
					end else if(opecode == INST_FMUL) begin
						wait_1 <= 8'h2;
					end else if(opecode == INST_FDIV) begin
						wait_1 <= 8'h20;
					end else if(opecode == INST_FNEG) begin
						data_1 <= {~rs_0[31], rs_0[30:0]};
					end else if(opecode == INST_FABS) begin
						data_1 <= {1'b0, rs_0[30:0]};
					end else if(opecode == INST_SQRT) begin
						wait_1 <= 8'h8;
					end else if(opecode == INST_FLOOR) begin
						wait_1 <= 8'h1;
					end else if(opecode == INST_FTOI) begin
						wait_1 <= 8'h1;
					end else if(opecode == INST_ITOF) begin
						wait_1 <= 8'h1;
					end else if(opecode == INST_MOVF) begin
						data_1 <= rs_0;
					end else if(opecode == INST_J) begin
						next_pc <= {4'h0, rd_no, rs_no, offset, 2'h0};
					end else if(opecode == INST_JAL) begin
						next_pc <= {4'h0, rd_no, rs_no, offset, 2'h0};
						data_1 <= pc + 32'h4;
						rd_no_1 <= 5'h1f;
					end else if(opecode == INST_JALR) begin
						next_pc <= {rs_0[31:2], 2'b00};
						data_1 <= pc + 32'h4;
					end else if(opecode == INST_SLTF) begin
						data_1 <= {31'h0, ltf(rs_0, rt_0)};
					end else if(opecode == INST_BNE) begin
						next_pc <= rt_0 != rs_0 ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4;
					end else if(opecode == INST_BGE) begin
						next_pc <= rt_0 >= rs_0 ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4;
					end else if(opecode == INST_BLE) begin
						next_pc <= rt_0 <= rs_0 ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4;
					end else if(opecode == INST_BEQF) begin
						next_pc <= rt_0 == rs_0 ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4;
					end else if(opecode == INST_BLTF) begin
						next_pc <= ltf(rt_0, rs_0) ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4;
					end else if(opecode == INST_OUTB) begin
						uart_wenable <= 1'b1;
						uart_wd <= rs_0;
						wait_1[7] <= 1'b1;
					end else if(opecode[3:0] == 4'b1111) begin
						uart_renable <= 1'b1;
						wait_1[7] <= 1'b1;
					end
				end
			end
			if(enable && (~|wait_1[7:1] || (wait_1[7] && (uart_rdone || uart_wdone)))) begin
				done <= 1'b1;
				wenable <= is_write_inst(opecode_1);
				wfmode <= opecode_1[5];
				wreg <= rd_no_1;
			end 
			if(~enable && (~|wait_2[7:1] || (wait_2[7] && (uart_rdone || uart_wdone)))) begin
				done <= 1'b1;
				wenable <= is_write_inst(opecode_2);
				wfmode <= opecode_2[5];
				wreg <= rd_no_2;
			end
			if(wait_1[0]) begin
				if(enable) begin
					data_2 <= data_select_1;
				end else begin
					data_1 <= data_select_1;
				end
			end
			if(wait_2[0]) begin
				data_2 <= data_select_2;
			end
			if(opecode_1 == INST_FDIV && wait_1[2]) begin
				fs <= fs_div;
				ft <= finv_d;
				if(enable) begin
					opecode_2 <= INST_FMUL;
				end else begin
					opecode_1 <= INST_FMUL;
				end
			end
			if(opecode_2 == INST_FDIV && wait_2[2]) begin
				fs <= fs_div;
				ft <= finv_d;
				opecode_2 <= INST_FMUL;
			end
			if(uart_rdone) begin
				if(wait_1[7] && !enable) begin
					data_1 <= uart_rd;
					wait_1[7] <= 1'b0;
				end else begin
					data_2 <= uart_rd;
					wait_2[7] <= 1'b0;
				end
			end
			if(uart_wdone) begin
				if(wait_1[7] && !enable) begin
					wait_1[7] <= 1'b0;
				end else begin
					wait_2[7] <= 1'b0;
				end
			end
		end
	end

endmodule //exec

`default_nettype wire