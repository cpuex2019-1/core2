`default_nettype none

module decode(
	input wire enable,
	input wire[31:0] pc,
	input wire[31:0] command,

	output wire[5:0] opecode,
	output wire[15:0] offset,
	output wire[31:0] pc_out,
	output wire[31:0] rs,
	output wire[31:0] rt,
	output wire[4:0] rd_no,
	output wire[4:0] rs_no,
	output wire[4:0] rt_no,
	output wire fmode1_reg,
	output wire fmode2_reg,

	output wire fmode1,
	output wire fmode2,
	output wire[4:0] reg1,
	output wire[4:0] reg2,
	input wire[31:0] reg_out1,
	input wire[31:0] reg_out2,

	input wire clk,
	input wire rstn
);

	decode_inner u1(
		enable,
		pc,
		command,
		opecode,
		offset,
		pc_out,
		rs,
		rt,
		rd_no,
		rs_no,
		rt_no,
		fmode1_reg,
		fmode2_reg,
		fmode1,
		fmode2,
		reg1,
		reg2,
		reg_out1,
		reg_out2,
		clk,
		rstn
	);

endmodule //decode

`default_nettype wire