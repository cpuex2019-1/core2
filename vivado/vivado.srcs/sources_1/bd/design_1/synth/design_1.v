//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Wed Feb 19 21:17:54 2020
//Host        : LAPTOP-ASL5AMB1 running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=10,numReposBlks=10,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=5,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,da_clkrst_cnt=5,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (default_sysclk_300_clk_n,
    default_sysclk_300_clk_p,
    reset,
    rs232_uart_rxd,
    rs232_uart_txd);
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_300 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk_300, CAN_DEBUG false, FREQ_HZ 300000000" *) input default_sysclk_300_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_300 CLK_P" *) input default_sysclk_300_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 rs232_uart RxD" *) input rs232_uart_rxd;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 rs232_uart TxD" *) output rs232_uart_txd;

  wire axi_uartlite_0_UART_RxD;
  wire axi_uartlite_0_UART_TxD;
  wire [31:0]blk_mem_gen_0_douta;
  wire [31:0]blk_mem_gen_0_douta1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_locked;
  wire [31:0]core_wrapper_0_jr_data;
  wire [31:0]core_wrapper_0_reg_out1;
  wire [31:0]core_wrapper_0_reg_out2;
  wire decode_0_fmode1;
  wire decode_0_fmode1_reg;
  wire decode_0_fmode2;
  wire decode_0_fmode2_reg;
  wire [15:0]decode_0_offset;
  wire [5:0]decode_0_opecode;
  wire [31:0]decode_0_pc_out;
  wire [4:0]decode_0_rd_no;
  wire [4:0]decode_0_reg1;
  wire [4:0]decode_0_reg2;
  wire [31:0]decode_0_rs;
  wire [4:0]decode_0_rs_no;
  wire [31:0]decode_0_rt;
  wire [4:0]decode_0_rt_no;
  wire default_sysclk_300_1_CLK_N;
  wire default_sysclk_300_1_CLK_P;
  wire exec_0_done;
  wire [18:0]exec_0_mem_addr;
  wire exec_0_mem_enable;
  wire [31:0]exec_0_mem_wdata;
  wire [3:0]exec_0_mem_wea;
  wire [31:0]exec_0_next_pc;
  wire exec_0_pcenable;
  wire exec_0_uart_renable;
  wire [31:0]exec_0_uart_wd;
  wire exec_0_uart_wenable;
  wire [31:0]exec_0_wdata;
  wire exec_0_wenable;
  wire exec_0_wfmode;
  wire [4:0]exec_0_wreg;
  wire [31:0]fetch_0_command;
  wire [16:0]fetch_0_inst_addr;
  wire [4:0]fetch_0_jr_reg;
  wire [31:0]fetch_0_pc;
  wire reset_1;
  wire [0:0]rst_clk_wiz_0_100M_peripheral_aresetn;
  wire [31:0]uart_buffer_0_rdata;
  wire uart_buffer_0_rdone;
  wire [31:0]uart_buffer_0_uart_ARADDR;
  wire uart_buffer_0_uart_ARREADY;
  wire uart_buffer_0_uart_ARVALID;
  wire [31:0]uart_buffer_0_uart_AWADDR;
  wire uart_buffer_0_uart_AWREADY;
  wire uart_buffer_0_uart_AWVALID;
  wire uart_buffer_0_uart_BREADY;
  wire [1:0]uart_buffer_0_uart_BRESP;
  wire uart_buffer_0_uart_BVALID;
  wire [31:0]uart_buffer_0_uart_RDATA;
  wire uart_buffer_0_uart_RREADY;
  wire [1:0]uart_buffer_0_uart_RRESP;
  wire uart_buffer_0_uart_RVALID;
  wire [31:0]uart_buffer_0_uart_WDATA;
  wire uart_buffer_0_uart_WREADY;
  wire [3:0]uart_buffer_0_uart_WSTRB;
  wire uart_buffer_0_uart_WVALID;
  wire uart_buffer_0_wdone;

  assign axi_uartlite_0_UART_RxD = rs232_uart_rxd;
  assign default_sysclk_300_1_CLK_N = default_sysclk_300_clk_n;
  assign default_sysclk_300_1_CLK_P = default_sysclk_300_clk_p;
  assign reset_1 = reset;
  assign rs232_uart_txd = axi_uartlite_0_UART_TxD;
  design_1_axi_uartlite_0_0 axi_uartlite_0
       (.rx(axi_uartlite_0_UART_RxD),
        .s_axi_aclk(clk_wiz_0_clk_out1),
        .s_axi_araddr(uart_buffer_0_uart_ARADDR[3:0]),
        .s_axi_aresetn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .s_axi_arready(uart_buffer_0_uart_ARREADY),
        .s_axi_arvalid(uart_buffer_0_uart_ARVALID),
        .s_axi_awaddr(uart_buffer_0_uart_AWADDR[3:0]),
        .s_axi_awready(uart_buffer_0_uart_AWREADY),
        .s_axi_awvalid(uart_buffer_0_uart_AWVALID),
        .s_axi_bready(uart_buffer_0_uart_BREADY),
        .s_axi_bresp(uart_buffer_0_uart_BRESP),
        .s_axi_bvalid(uart_buffer_0_uart_BVALID),
        .s_axi_rdata(uart_buffer_0_uart_RDATA),
        .s_axi_rready(uart_buffer_0_uart_RREADY),
        .s_axi_rresp(uart_buffer_0_uart_RRESP),
        .s_axi_rvalid(uart_buffer_0_uart_RVALID),
        .s_axi_wdata(uart_buffer_0_uart_WDATA),
        .s_axi_wready(uart_buffer_0_uart_WREADY),
        .s_axi_wstrb(uart_buffer_0_uart_WSTRB),
        .s_axi_wvalid(uart_buffer_0_uart_WVALID),
        .tx(axi_uartlite_0_UART_TxD));
  design_1_blk_mem_gen_0_1 blk_mem_gen_0
       (.addra(exec_0_mem_addr),
        .clka(clk_wiz_0_clk_out1),
        .dina(exec_0_mem_wdata),
        .douta(blk_mem_gen_0_douta1),
        .ena(exec_0_mem_enable),
        .wea(exec_0_mem_wea));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(default_sysclk_300_1_CLK_N),
        .clk_in1_p(default_sysclk_300_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .locked(clk_wiz_0_locked),
        .reset(reset_1));
  design_1_core_wrapper_0_0 core_wrapper_0
       (.clk(clk_wiz_0_clk_out1),
        .jr_data(core_wrapper_0_jr_data),
        .jr_reg(fetch_0_jr_reg),
        .reg_out1(core_wrapper_0_reg_out1),
        .reg_out2(core_wrapper_0_reg_out2),
        .rfmode1(decode_0_fmode1),
        .rfmode2(decode_0_fmode2),
        .rreg1(decode_0_reg1),
        .rreg2(decode_0_reg2),
        .rstn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .wdata(exec_0_wdata),
        .wenable(exec_0_wenable),
        .wfmode(exec_0_wfmode),
        .wreg(exec_0_wreg));
  design_1_decode_0_0 decode_0
       (.clk(clk_wiz_0_clk_out1),
        .command(fetch_0_command),
        .enable(exec_0_done),
        .fmode1(decode_0_fmode1),
        .fmode1_reg(decode_0_fmode1_reg),
        .fmode2(decode_0_fmode2),
        .fmode2_reg(decode_0_fmode2_reg),
        .offset(decode_0_offset),
        .opecode(decode_0_opecode),
        .pc(fetch_0_pc),
        .pc_out(decode_0_pc_out),
        .rd_no(decode_0_rd_no),
        .reg1(decode_0_reg1),
        .reg2(decode_0_reg2),
        .reg_out1(core_wrapper_0_reg_out1),
        .reg_out2(core_wrapper_0_reg_out2),
        .rs(decode_0_rs),
        .rs_no(decode_0_rs_no),
        .rstn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .rt(decode_0_rt),
        .rt_no(decode_0_rt_no));
  design_1_exec_0_0 exec_0
       (.clk(clk_wiz_0_clk_out1),
        .done(exec_0_done),
        .fmode1(decode_0_fmode1_reg),
        .fmode2(decode_0_fmode2_reg),
        .mem_addr(exec_0_mem_addr),
        .mem_enable(exec_0_mem_enable),
        .mem_rdata(blk_mem_gen_0_douta1),
        .mem_wdata(exec_0_mem_wdata),
        .mem_wea(exec_0_mem_wea),
        .next_pc(exec_0_next_pc),
        .offset(decode_0_offset),
        .opecode(decode_0_opecode),
        .pc(decode_0_pc_out),
        .pcenable(exec_0_pcenable),
        .rd_no(decode_0_rd_no),
        .rs(decode_0_rs),
        .rs_no(decode_0_rs_no),
        .rstn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .rt(decode_0_rt),
        .rt_no(decode_0_rt_no),
        .uart_rd(uart_buffer_0_rdata),
        .uart_rdone(uart_buffer_0_rdone),
        .uart_renable(exec_0_uart_renable),
        .uart_wd(exec_0_uart_wd),
        .uart_wdone(uart_buffer_0_wdone),
        .uart_wenable(exec_0_uart_wenable),
        .wdata(exec_0_wdata),
        .wenable(exec_0_wenable),
        .wfmode(exec_0_wfmode),
        .wreg(exec_0_wreg));
  design_1_fetch_0_0 fetch_0
       (.clk(clk_wiz_0_clk_out1),
        .command(fetch_0_command),
        .enable(exec_0_done),
        .inst_addr(fetch_0_inst_addr),
        .inst_data(blk_mem_gen_0_douta),
        .jr_data(core_wrapper_0_jr_data),
        .jr_reg(fetch_0_jr_reg),
        .next_pc(exec_0_next_pc),
        .pc(fetch_0_pc),
        .pcenable(exec_0_pcenable),
        .rstn(rst_clk_wiz_0_100M_peripheral_aresetn));
  design_1_blk_mem_gen_0_0 inst_memory
       (.addra(fetch_0_inst_addr),
        .clka(clk_wiz_0_clk_out2),
        .douta(blk_mem_gen_0_douta));
  design_1_rst_clk_wiz_0_100M_0 rst_clk_wiz_0_100M
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_0_clk_out1));
  design_1_uart_buffer_0_0 uart_buffer_0
       (.clk(clk_wiz_0_clk_out1),
        .rdata(uart_buffer_0_rdata),
        .rdone(uart_buffer_0_rdone),
        .renable(exec_0_uart_renable),
        .rstn(rst_clk_wiz_0_100M_peripheral_aresetn),
        .uart_araddr(uart_buffer_0_uart_ARADDR),
        .uart_arready(uart_buffer_0_uart_ARREADY),
        .uart_arvalid(uart_buffer_0_uart_ARVALID),
        .uart_awaddr(uart_buffer_0_uart_AWADDR),
        .uart_awready(uart_buffer_0_uart_AWREADY),
        .uart_awvalid(uart_buffer_0_uart_AWVALID),
        .uart_bready(uart_buffer_0_uart_BREADY),
        .uart_bresp(uart_buffer_0_uart_BRESP),
        .uart_bvalid(uart_buffer_0_uart_BVALID),
        .uart_rdata(uart_buffer_0_uart_RDATA),
        .uart_rready(uart_buffer_0_uart_RREADY),
        .uart_rresp(uart_buffer_0_uart_RRESP),
        .uart_rvalid(uart_buffer_0_uart_RVALID),
        .uart_wdata(uart_buffer_0_uart_WDATA),
        .uart_wready(uart_buffer_0_uart_WREADY),
        .uart_wstrb(uart_buffer_0_uart_WSTRB),
        .uart_wvalid(uart_buffer_0_uart_WVALID),
        .wdata(exec_0_uart_wd),
        .wdone(uart_buffer_0_wdone),
        .wenable(exec_0_uart_wenable));
endmodule
