// NOTE: Itof
module itof(
  input wire clk,
  input wire [31:0] s,
  output wire [31:0] d
);

wire [7:0] exponent_d_minus127, exponent_d, shift;
wire [22:0] mantissa_d;

// 絶対値をとってから指数を数える
wire [31:0] abs_s;
assign abs_s = s[31] ? ~s + 32'd1 : s;

assign exponent_d_minus127 =
    abs_s[31] ? 8'd31 :
    abs_s[30] ? 8'd30 :
    abs_s[29] ? 8'd29 :
    abs_s[28] ? 8'd28 :
    abs_s[27] ? 8'd27 :
    abs_s[26] ? 8'd26 :
    abs_s[25] ? 8'd25 :
    abs_s[24] ? 8'd24 :
    abs_s[23] ? 8'd23 :
    abs_s[22] ? 8'd22 :
    abs_s[21] ? 8'd21 :
    abs_s[20] ? 8'd20 :
    abs_s[19] ? 8'd19 :
    abs_s[18] ? 8'd18 :
    abs_s[17] ? 8'd17 :
    abs_s[16] ? 8'd16 :
    abs_s[15] ? 8'd15 :
    abs_s[14] ? 8'd14 :
    abs_s[13] ? 8'd13 :
    abs_s[12] ? 8'd12 :
    abs_s[11] ? 8'd11 :
    abs_s[10] ? 8'd10 :
    abs_s[9] ? 8'd9 :
    abs_s[8] ? 8'd8 :
    abs_s[7] ? 8'd7 :
    abs_s[6] ? 8'd6 :
    abs_s[5] ? 8'd5 :
    abs_s[4] ? 8'd4 :
    abs_s[3] ? 8'd3 :
    abs_s[2] ? 8'd2 :
    abs_s[1] ? 8'd1 : 8'd0;

assign shift = 8'd32 - exponent_d_minus127;

wire [31:0] tmp0;
reg [31:0] tmp, s1, exp1;
assign tmp0 = abs_s << shift;

// NOTE: 適切に丸める
wire ulp, guard, round, sticky, flag, carry;
assign ulp = tmp[9:9];
assign guard = tmp[8:8];
assign round = tmp[7:7];
assign sticky = |(tmp[6:0]);
assign flag = 
    (ulp && guard && (~round) && (~sticky)) ||
    (guard && (~round) && sticky) ||
    (guard && round);
assign carry = &(tmp[31:9]) && flag;

wire d_is_zero;
assign d_is_zero = (s1 == 32'b0);

assign exponent_d =
    d_is_zero ? 32'b0 : exp1 + 8'd127 + carry;
assign mantissa_d =
    d_is_zero ? 32'b0 : tmp[31:9] + {22'b0, flag};

assign d = {s1[31], exponent_d, mantissa_d};

always @(posedge clk) begin
    tmp <= tmp0;
    s1 <= s;
    exp1 <= exponent_d_minus127;
end

endmodule