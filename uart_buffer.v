`default_nettype none

module uart_buffer(
	input wire renable,
	output reg rdone,
	output reg[31:0] rdata,
	input wire wenable,
	output reg wdone,
	input wire[31:0] wdata,
	output reg[31:0] uart_araddr,
	input wire uart_arready,
	output reg uart_arvalid,
	output reg[31:0] uart_awaddr,
	input wire uart_awready,
	output reg uart_awvalid,
	output reg uart_bready,
	input wire[1:0] uart_bresp,
	input wire uart_bvalid,
	input wire[31:0] uart_rdata,
	output reg uart_rready,
	input wire[1:0] uart_rresp,
	input wire uart_rvalid,
	output reg[31:0] uart_wdata,
	input wire uart_wready,
	output reg[3:0] uart_wstrb,
	output reg uart_wvalid,
	input wire clk,
	input wire rstn
);

	reg[16383:0] rbuffer;
	reg[10:0] rhead, rtail;
	reg renable_, rlap;
	reg[4095:0] wbuffer;
	reg[8:0] whead, wtail;
	reg wenable_, wlap;

	always @(posedge clk) begin
		rdone <= 1'b0;
		wdone <= 1'b0;
		renable_ <= 1'b0;
		wenable_ <= 1'b0;
		if(~rstn) begin
			rdata <= 32'h0;
			rbuffer <= 16384'h0;
			rhead <= 11'h7fc;
			rtail <= 11'h7ff;
			rlap <= 1'b0;
			wbuffer <= {8'haa, 4088'h0};
			whead <= 9'h1ff;
			wtail <= 9'h1fe;
			wlap <= 1'b0;
			uart_araddr <= 32'h0;
			uart_awaddr <= 32'h4;
			uart_arvalid <= 1'b0;
			uart_awvalid <= 1'b0;
			uart_bready <= 1'b0;
			uart_rready <= 1'b0;
			uart_wvalid <= 1'b0;
			uart_wstrb <= 4'b0001;
			uart_wdata <= 32'h0;
		end else begin
			if(renable || renable_) begin
				if({rlap, rhead} > {1'b0, rtail}) begin
					rdone <= 1'b1;
					rdata <= rbuffer[{rhead, 3'h0} +: 14'h20];
					rhead <= rhead - 11'h4;
				end else begin
					renable_ <= 1'b1;
				end
			end
			if((~rlap || rhead != rtail) && ~uart_rready && ~uart_bready) begin
				uart_arvalid <= 1'b1;
				uart_rready <= 1'b1;
			end
			if(uart_arready && uart_arvalid) begin
				uart_arvalid <= 1'b0;
			end
			if(uart_rready && uart_rvalid) begin
				if(uart_rresp[1]) begin
					uart_arvalid <= ~uart_bready;
					uart_rready <= ~uart_bready;
				end else begin
					uart_rready <= 1'b0;
					rbuffer[{rtail, 3'h0} +: 14'h8] <= uart_rdata[7:0];
					rtail <= rtail - 11'h1;
					if(rtail == 11'h0) rlap <= 1'b1;
				end
			end

			if(wenable || wenable_) begin
				if(~wlap || whead != wtail) begin
					wdone <= 1'b1;
					wbuffer[{wtail, 3'h0} +: 12'h8] <= wdata[7:0];
					wtail <= wtail - 9'h1;
					if(wtail == 9'h0) wlap <= 1'b1;
				end else begin
					wenable_ <= 1'b1;
				end
			end
			if((wlap || whead != wtail) && ~uart_bready) begin
				uart_awvalid <= 1'b1;
				uart_bready <= 1'b1;
				uart_wvalid <= 1'b1;
				uart_wdata[7:0] <= wbuffer[{whead, 3'h0} +: 12'h8];
				whead <= whead - 9'h1;
				if(whead == 9'h0) begin
					wlap <= 1'b0;
				end
			end
			if(uart_awready && uart_awvalid) begin
				uart_awvalid <= 1'b0;
			end
			if(uart_wready && uart_wvalid) begin
				uart_wvalid <= 1'b0;
			end
			if(uart_bready && uart_bvalid) begin
				if(uart_bresp[1]) begin
					uart_awvalid <= 1'b1;
					uart_bready <= 1'b1;
					uart_wvalid <= 1'b1;
				end else begin
					uart_bready <= 1'b0;
				end
			end
		end
	end

endmodule //uart_buffer

`default_nettype wire