//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Fri Feb 21 21:32:05 2020
//Host        : LAPTOP-ASL5AMB1 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (default_sysclk_300_clk_n,
    default_sysclk_300_clk_p,
    reset,
    rs232_uart_rxd,
    rs232_uart_txd);
  input default_sysclk_300_clk_n;
  input default_sysclk_300_clk_p;
  input reset;
  input rs232_uart_rxd;
  output rs232_uart_txd;

  wire default_sysclk_300_clk_n;
  wire default_sysclk_300_clk_p;
  wire reset;
  wire rs232_uart_rxd;
  wire rs232_uart_txd;

  design_1 design_1_i
       (.default_sysclk_300_clk_n(default_sysclk_300_clk_n),
        .default_sysclk_300_clk_p(default_sysclk_300_clk_p),
        .reset(reset),
        .rs232_uart_rxd(rs232_uart_rxd),
        .rs232_uart_txd(rs232_uart_txd));
endmodule
