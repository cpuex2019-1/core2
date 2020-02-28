`default_nettype none

module fetch(
	input wire enable,
	input wire pcenable,
	input wire[31:0] next_pc,
	output wire[31:0] pc,
	output wire[31:0] command,
	output wire[4:0] jr_reg,
	input wire[31:0] jr_data,
	output wire[15:0] inst_addr,
	input wire[31:0] inst_data,
	input wire clk,
	input wire rstn
);

	wire [16:0] inst_addr_;
	assign inst_addr = inst_addr_[15:0];

	fetch_inner u1(
		enable,
		pcenable,
		next_pc,
		pc,
		command,
		jr_reg,
		jr_data,
		inst_addr_,
		inst_data,
		clk,
		rstn
	);
endmodule //fetch

`default_nettype wire