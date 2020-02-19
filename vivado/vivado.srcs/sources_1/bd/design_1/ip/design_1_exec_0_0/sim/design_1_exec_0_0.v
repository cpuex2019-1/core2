// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:exec:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_exec_0_0 (
  done,
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

output wire done;
input wire [5 : 0] opecode;
input wire [15 : 0] offset;
input wire [31 : 0] pc;
input wire [31 : 0] rs;
input wire [31 : 0] rt;
input wire [4 : 0] rd_no;
input wire [4 : 0] rs_no;
input wire [4 : 0] rt_no;
input wire fmode1;
input wire fmode2;
output wire pcenable;
output wire [31 : 0] next_pc;
output wire wenable;
output wire wfmode;
output wire [4 : 0] wreg;
output wire [31 : 0] wdata;
output wire uart_wenable;
input wire uart_wdone;
output wire [31 : 0] uart_wd;
output wire uart_renable;
input wire uart_rdone;
input wire [31 : 0] uart_rd;
output wire [18 : 0] mem_addr;
output wire [31 : 0] mem_wdata;
input wire [31 : 0] mem_rdata;
output wire mem_enable;
output wire [3 : 0] mem_wea;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rstn, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN design_1_clk_wiz_0_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rstn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rstn RST" *)
input wire rstn;

  exec inst (
    .done(done),
    .opecode(opecode),
    .offset(offset),
    .pc(pc),
    .rs(rs),
    .rt(rt),
    .rd_no(rd_no),
    .rs_no(rs_no),
    .rt_no(rt_no),
    .fmode1(fmode1),
    .fmode2(fmode2),
    .pcenable(pcenable),
    .next_pc(next_pc),
    .wenable(wenable),
    .wfmode(wfmode),
    .wreg(wreg),
    .wdata(wdata),
    .uart_wenable(uart_wenable),
    .uart_wdone(uart_wdone),
    .uart_wd(uart_wd),
    .uart_renable(uart_renable),
    .uart_rdone(uart_rdone),
    .uart_rd(uart_rd),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_rdata(mem_rdata),
    .mem_enable(mem_enable),
    .mem_wea(mem_wea),
    .clk(clk),
    .rstn(rstn)
  );
endmodule
