`default_nettype none
`include "inst_set.sv"

module exec(
	input wire enable,
	output reg done,

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
	output reg [31:0] wdata,

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

	reg[31:0] fs, ft;
	wire[31:0] fadd_d, fmul_d, finv_d, sqrt_d, ftoi_d, itof_d, floor_d;
	wire fadd_of, fmul_of, finv_of, fmul_uf, finv_uf;

	fadd u_fadd(clk, fs, ft, fadd_d, fadd_of);
	fmul u_fmul(clk, fs, ft, fmul_d, fmul_of, fmul_uf);
	finv u_finv(clk, ft, finv_d, finv_of, finv_uf);
	fsqrt u_fsqrt(clk, fs, sqrt_d);
	ftoi u_ftoi(fs, ftoi_d);
	itof u_itof(fs, itof_d);
	floor u_floor(fs, floor_d);

	always @(posedge clk) begin
		if(~rstn) begin
		end else begin
		end
	end

endmodule //exec

`default_nettype wire