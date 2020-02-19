`default_nettype none

module exec(
	output wire done,

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

	output wire pcenable,
	output wire [31:0] next_pc,
	output wire wenable,
	output wire wfmode,
	output wire [4:0] wreg,
	output wire [31:0] wdata,

	output wire uart_wenable,
	input wire uart_wdone,
	output wire[31:0] uart_wd,
	output wire uart_renable,
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

	wire stop, done_;
	assign done = done_ && ~stop;

	exec_inner u1(
		done_,
		done_,
		stop,

		opecode,
		offset,
		pc,
		rs,
		rt,
		rd_no,
		rs_no,
		rt_no,
		fmode1,
		fmode2,

		pcenable,
		next_pc,
		wenable,
		wfmode,
		wreg,
		wdata,

		uart_wenable,
		uart_wdone,
		uart_wd,
		uart_renable,
		uart_rdone,
		uart_rd,

		mem_addr,
		mem_wdata,
		mem_rdata,
		mem_enable,
		mem_wea,

		clk,
		rstn
	);


endmodule //exec

`default_nettype wire