module ftoi(
  input wire clk,
  input wire [31:0] s,
  output wire [31:0] d
);

reg [31:0] s2;
reg [7:0] exponent_s_minus127;
wire [7:0] exponent_s_minus127_;
wire [22:0] mantissa_s;
wire [23:0] one_mantissa_s;

assign exponent_s_minus127_ = (s[30:23] > 8'd127 ? s[30:23] - 8'd127 : 8'd0);
assign mantissa_s = s[22:0];

// NOTE: mantissa_ex -> 32bit拡張するだけ
// NOTE: mantissa_shift -> 指数の数だけshiftする
// NOTE: mantissa_round -> 丸めを加える
// NOTE: 符号を加える(必要なら補数をとる)
reg [54:0] mantissa_shift;
wire [54:0] mantissa_ex, mantissa_shift_;
wire [31:0] mantissa_round;
assign mantissa_ex = {32'b1, mantissa_s};
assign mantissa_shift_ = (mantissa_ex << (s[30:23] - 8'd126));

// NOTE: 適切に丸める
wire ulp, guard, round, sticky, flag, carry;
assign ulp = mantissa_shift[24:24];
assign guard = mantissa_shift[23:23];
assign round = mantissa_shift[22:22];
assign sticky = |(mantissa_shift[21:0]);
assign flag =
    // (ulp && guard && (~round) && (~sticky)) ||
    (guard && (~round) && (~sticky)) ||
    (guard && (~round) && sticky) ||
    (guard && round);
// assign carry = &(mantissa_shift[54:24]) && flag;

assign mantissa_round = {1'b0, mantissa_shift[54:24]} + {31'b0, flag};

// NOTE:
// 31bit以上shiftすると整数で表現できなくなる
// 指数が-2以下（絶対値が0.1以下のとき)ならば明らかに0になる
// 指数が-1のとき(絶対値が1以下のとき)には四捨五入して-1になる可能性がある

wire d_is_inf, d_is_zero;
assign d_is_inf = (exponent_s_minus127 >= 8'd31);
assign d_is_zero = (s2[30:23] < 8'd126);

assign d =
    d_is_inf ? {1'b1, 31'b0} :
    d_is_zero ? 32'd0 :
    s2[31] ? ~mantissa_round + 32'b1 : mantissa_round;

always @(posedge clk) begin
  mantissa_shift <= mantissa_shift_;
  exponent_s_minus127 <= exponent_s_minus127_;
  s2 <= s;
end

endmodule