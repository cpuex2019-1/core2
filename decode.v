`default_nettype none
`include "inst_set.sv"

module decode(
	input wire enable,
	input wire[31:0] pc,
	input wire[31:0] command,

	output reg[5:0] opecode,
	output reg[15:0] offset,
	output reg[31:0] pc_out,
	output reg[31:0] rs,
	output reg[31:0] rt,
	output reg[4:0] rd_no,
	output reg[4:0] rs_no,
	output reg[4:0] rt_no,
	output reg fmode1_reg,
	output reg fmode2_reg,

	// read register
	output wire fmode1,
	output wire fmode2,
	output wire[4:0] reg1,
	output wire[4:0] reg2,
	input wire[31:0] reg_out1,
	input wire[31:0] reg_out2,

	input wire clk,
	input wire rstn
);

	assign reg1 = command[20:16];
	assign reg2 = command[29:26] == 4'b0000 || is_branch_inst(command[31:26]) ? command[25:21] : command[15:11];
	assign fmode1 = command[30] && command[29:26] != 4'b0000;
	assign fmode2 = command[30];

	always @(posedge clk) begin
		if(~rstn) begin
			opecode <= 6'h0;
			offset <= 16'h0;
			pc_out <= 32'h0;
			addr <= 32'h0;
			rs <= 32'h0;
			rt <= 32'h0;
			rd_no <= 5'h0;
			rs_no <= 5'h0;
			rt_no <= 5'h0;
			fmode1_reg <= 1'b0;
			fmode2_reg <= 1'b0;
		end else begin
			if(enable) begin
				opecode <= command[31:26];
				offset <= command[15:0];
				pc_out <= pc;
				rs <= reg_out1;
				rt <= reg_out2;
				rd_no <= command[25:21];
				rs_no <= reg1;
				rt_no <= reg2;
				fmode1_reg <= fmode1;
				fmode2_reg <= fmode2;
			end
		end
	end

endmodule //decode

`default_nettype wire