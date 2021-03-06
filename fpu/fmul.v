// クロック分割したFMul(おそらく後でfmul.vにうつす)

module fmul_stage1(
  input wire [31:0] s,
  input wire [31:0] t,
  output wire [47:0] mantissa
);

// 先頭bitを補完する
wire [23:0] one_mantissa_s, one_mantissa_t;
assign one_mantissa_s = {1'b1, s[22:0]};
assign one_mantissa_t = {1'b1, t[22:0]};

// 24bitのone_mantissaどうしでMulを行う
assign mantissa = {24'b0, one_mantissa_s} * {24'b0, one_mantissa_t};

endmodule

module fmul_stage2(
  input wire [31:0] s,
  input wire [31:0] t,
  input wire [47:0] one_mantissa_d_48bit,
  output wire [31:0] d
);

// 符号1bit、指数8bit、仮数23bitを読み出す
wire [0:0] sign_s, sign_t, sign_d;
wire [7:0] exponent_s, exponent_t, exponent_d;
wire [22:0] mantissa_s, mantissa_t, mantissa_d;
wire overflow, underflow;

assign sign_s = s[31:31];
assign sign_t = t[31:31];
assign exponent_s = s[30:23];
assign exponent_t = t[30:23];
assign mantissa_s = s[22:0];
assign mantissa_t = t[22:0];

// carryがあるか調べる(非正規化数になったら適切にシフトする)
wire carry;
assign carry = one_mantissa_d_48bit[47:47];

// NOTE: 指数より左シフトが大きければシフトしない
wire [7:0] shift;
wire shift_left;
wire [4:0] shift_right;

assign shift = 
    (one_mantissa_d_48bit[47:47] == 1'b1) ? 0 :
    (one_mantissa_d_48bit[46:46] == 1'b1) ? 0 :
    (one_mantissa_d_48bit[45:45] == 1'b1) ? 1 :
    (one_mantissa_d_48bit[44:44] == 1'b1) ? 2 :
    (one_mantissa_d_48bit[43:43] == 1'b1) ? 3 :
    (one_mantissa_d_48bit[42:42] == 1'b1) ? 4 :
    (one_mantissa_d_48bit[41:41] == 1'b1) ? 5 :
    (one_mantissa_d_48bit[40:40] == 1'b1) ? 6 :
    (one_mantissa_d_48bit[39:39] == 1'b1) ? 7 :
    (one_mantissa_d_48bit[38:38] == 1'b1) ? 8 :
    (one_mantissa_d_48bit[37:37] == 1'b1) ? 9 :
    (one_mantissa_d_48bit[36:36] == 1'b1) ? 10 :
    (one_mantissa_d_48bit[35:35] == 1'b1) ? 11 :
    (one_mantissa_d_48bit[34:34] == 1'b1) ? 12 :
    (one_mantissa_d_48bit[33:33] == 1'b1) ? 13 :
    (one_mantissa_d_48bit[32:32] == 1'b1) ? 14 :
    (one_mantissa_d_48bit[31:31] == 1'b1) ? 15 :
    (one_mantissa_d_48bit[30:30] == 1'b1) ? 16 :
    (one_mantissa_d_48bit[29:29] == 1'b1) ? 17 :
    (one_mantissa_d_48bit[28:28] == 1'b1) ? 18 :
    (one_mantissa_d_48bit[27:27] == 1'b1) ? 19 :
    (one_mantissa_d_48bit[26:26] == 1'b1) ? 20 :
    (one_mantissa_d_48bit[25:25] == 1'b1) ? 21 :
    (one_mantissa_d_48bit[24:24] == 1'b1) ? 22 : 23;

assign shift_right = 5'd0;
assign shift_left =
    {1'b0, exponent_s} + {1'b0, exponent_t} < {1'b0, shift} + 9'd127 ? 8'd0 : shift;

// 正規化する
wire [47:0] tmp;
wire [47:0] one_mantissa_d_scaled;
assign tmp = one_mantissa_d_48bit >> shift_right;
assign one_mantissa_d_scaled = tmp << shift_left;

// 繰り上がりの有無で場合分けする
wire [23:0] one_mantissa_d_24bit;
assign one_mantissa_d_24bit =
    carry == 1'b1 ?
    one_mantissa_d_scaled[47:24]:
    one_mantissa_d_scaled[46:23];
        
// 丸める
wire [23:0] one_mantissa_d;
wire ulp, guard, round, sticky, flag;
assign ulp = (carry == 1'b1) ?
    one_mantissa_d_scaled[24:24] :
    one_mantissa_d_scaled[23:23];
assign guard = (carry == 1'b1) ?
    one_mantissa_d_scaled[23:23] :
    one_mantissa_d_scaled[22:22];
assign round = (carry == 1'b1) ?
    one_mantissa_d_scaled[22:22] :
    one_mantissa_d_scaled[21:21];
assign sticky = (carry == 1'b1) ?
    |(one_mantissa_d_scaled[21:0]) :
    |(one_mantissa_d_scaled[20:0]); 
assign flag = 
    (ulp && guard && (~round) && (~sticky)) ||
    (guard && (~round) && sticky) ||
    (guard && round);

assign one_mantissa_d = one_mantissa_d_24bit + {23'b0, flag};

assign overflow = 
    ({1'b0, exponent_s} + {1'b0, exponent_t} + {8'd0, carry} >= 9'b011111111 + 9'b001111111);
assign underflow = 
    // ({1'b0, exponent_s} + {1'b0, exponent_t} < 9'b001111111 - 9'b000011000);
    {1'b0, exponent_s} + {1'b0, exponent_t} < 9'b001111111;

assign sign_d = (sign_s == sign_t) ? 0 : 1;

assign exponent_d =
    overflow ?
        8'b11111111
    : underflow ?
        8'b00000000
    : exponent_s + exponent_t + {7'b0, carry} - 8'b01111111 - shift_left;

assign mantissa_d =
    overflow ?
        23'b0
    : underflow ?
        23'b0
    : one_mantissa_d[22:0];

wire s_is_nan;
assign s_is_nan =
    exponent_s == 8'd255 && mantissa_s != 8'd0;
wire t_is_nan;
assign t_is_nan =
    exponent_t == 8'd255 && mantissa_t != 8'd0;
wire s_is_inf;
assign s_is_inf =
    exponent_s == 8'd255 && mantissa_s == 8'd0;
wire t_is_inf;
assign t_is_inf =
    exponent_t == 8'd255 && mantissa_t == 8'd0;
wire s_is_zero;
assign s_is_zero =
    exponent_s == 8'd0 && mantissa_s == 8'd0;
wire t_is_zero;
assign t_is_zero =
    exponent_t == 8'd0 && mantissa_t == 8'd0;

assign d = 
    s_is_nan ?
        {sign_s, exponent_s, 1'b1, mantissa_s[21:0]}
    : t_is_nan ?
        {sign_t, exponent_t, 1'b1, mantissa_t[21:0]}
    : s_is_inf || t_is_inf ?
        {sign_d, 8'd255, 23'b0}
    : s_is_zero ?
        {sign_d, exponent_s, mantissa_s}
    : t_is_zero ?
        {sign_d, exponent_t, mantissa_t}
    : overflow ?
        {sign_d, 8'd255, 23'b0}
    : underflow ?
        {sign_d, 8'd0, 23'b0} 
    : {sign_d, exponent_d, mantissa_d};

endmodule

/*
module fmul_stage1(
  input wire [31:0] s,
  input wire [31:0] t,
  output wire [47:0] mantissa
);

module fmul_stage2(
  input wire [31:0] s,
  input wire [31:0] t,
  input wire [47:0] mantissa,
  output wire [31:0] d
);
*/

module fmul(
  input wire clk,
  input wire [31:0] s,
  input wire [31:0] t,
  output wire [31:0] d
);

reg [31:0] s2_reg, t2_reg;
wire [47:0] mantissa1_reg;
reg [47:0] mantissa2_reg;

fmul_stage1 u1(s, t, mantissa1_reg);
fmul_stage2 u2(s2_reg,t2_reg,mantissa2_reg,d);

always @(posedge clk) begin
  s2_reg <= s;
  t2_reg <= t;
  mantissa2_reg <= mantissa1_reg;
end

endmodule