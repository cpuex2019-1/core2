`default_nettype none
`include "inst_set.sv"

module fetch(
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
	wire[31:0] pc_;
	wire[5:0] opecode;

	assign opecode = command[31:26];
	assign jr_reg = command[20:16];

	// TODO : 分岐予測 BNE, BGE, BLE, BEQF, BLTF
	assign pc_ = pcenable && pc_history != next_pc ? next_pc :
				 opecode == INST_J || opecode == INST_JAL ? {4'b0000, command[25:0], 2'b00} :	//J, JAL
				 is_branch_inst(opecode) ? pc + 32'h4 :											// B**
				 opecode == INST_JALR ? {jr_data[31:2], 2'b00} : pc + 32'h4;					// JALR

	assign inst_addr = pc_[18:2];

	always @(posedge clk) begin
		if(~rstn) begin
			pc <= 32'hfffffffc;
			pc_history <= 32'hffffffff;
		end else begin
			done <= 1'b0;
			if(enable) begin
				pc <= pc_;
				pc_history <= pc;
			end
		end
	end

	always @(negedge clk) begin
		if(~rstn) begin
			command <= {INST_J, 26'h0};
		end else begin
			if(done) begin
				command <= inst_data;
			end
		end
	end
endmodule //fetch

`default_nettype wire