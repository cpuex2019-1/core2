`default_nettype none
`include "inst_set.sv"

module fetch_inner(
	input wire enable,
	input wire pcenable,
	input wire[31:0] next_pc,
	output reg[31:0] pc,
	output reg[31:0] command,
	output wire[4:0] jr_reg,
	input wire[31:0] jr_data,
	output wire[16:0] inst_addr,
	input wire[31:0] inst_data,
	input wire clk,
	input wire rstn
);

	reg[31:0] pc_history;
	reg[9:0] branch_pc;
	reg is_branch0, is_branch1;
	wire[31:0] pc_;
	wire[5:0] opecode;
	wire[15:0] offset;
	reg set;

	reg[1023:0] branch_prediction;
	reg[1023:0] prediction_miss;

	assign opecode = command[31:26];
	assign offset = command[15:0];
	assign jr_reg = command[20:16];

	assign pc_ = pcenable && pc_history != next_pc ? next_pc :
				 opecode == INST_J || opecode == INST_JAL ? {4'b0000, command[25:0], 2'b00} :									//J, JAL
				 is_branch_inst(opecode) ? (branch_prediction[pc[11:2]] ? pc + {{14{offset[15]}}, offset, 2'h0} : pc + 32'h4) :	// B**
				 opecode == INST_JALR ? {jr_data[31:2], 2'b00} : pc + 32'h4;													// JALR

	assign inst_addr = pc_[18:2];

	always @(posedge clk) begin
		if(~rstn) begin
			pc <= 32'hfffffffc;
			pc_history <= 32'hffffffff;
			set <= 1'b0;
			branch_prediction <= {1024{1'b0}};
			prediction_miss <= {1024{1'b1}};
			is_branch0 <= 1'b0;
			is_branch1 <= 1'b0;
			branch_pc <= 10'h0;
		end else begin
			set <= 1'b0;
			if(enable) begin
				pc <= pc_;
				pc_history <= pc;
				set <= 1'b1;
				branch_pc <= pc_history[11:2];
				is_branch0 <= is_branch_inst(opecode);
				is_branch1 <= is_branch0;
				if(is_branch1) begin
					if(pcenable && pc_history != next_pc) begin
						if(prediction_miss[branch_pc]) branch_prediction[branch_pc] <= ~branch_prediction[branch_pc];
						prediction_miss[branch_pc] <= 1'b1;
					end else begin
						prediction_miss[branch_pc] <= 1'b0;
					end
				end
			end
		end
	end

	always @(negedge clk) begin
		if(~rstn) begin
			command <= {INST_J, 26'h0};
		end else begin
			if(set) command <= inst_data;
		end
	end
endmodule //fetch

`default_nettype wire