module floor(
  input wire clk,
  input wire [31:0] s,
  output wire [31:0] d
);

// NOTE: 符号、指数、仮数を切り出す
reg [31:0] s2;
reg [7:0] ex127;
wire [7:0] exponent_s_minus127, exponent_d;
wire [22:0] mantissa_d;

assign exponent_s_minus127 = (s[30:23] > 8'd127 ? s[30:23] - 8'd127 : 8'd0);

// NOTE: 有効桁以下のbitをshiftによって0にする
// NOTE: 負の数については(値が整数になっている場合を除いて)有効桁の最下位bitに1を足す

reg [22:0] integer_part;
wire [22:0] decimal_part;
wire [22:0] integer_part_, integer_part_plusone;
reg flag;
wire flag_, carry;
assign decimal_part = s[22:0] << exponent_s_minus127;
assign flag_ = |(decimal_part) && s[31];
assign integer_part_ = s[22:0] >> (8'd23 - exponent_s_minus127);
assign integer_part_plusone = integer_part + {22'd0, flag};

// NOTE: 1を足したことによって(指数の)繰り上がりが発生するかもしれない
assign carry = s2[31] && (s2[22:0] != 23'd0) && (mantissa_d == 23'd0); 

assign exponent_d = s2[30:23] + {7'd0, carry};
assign mantissa_d = integer_part_plusone << (8'd23 - ex127);

wire d_is_nan, d_is_s, d_is_zero, d_is_minuszero, d_is_minusone;
assign d_is_s = (ex127 >= 8'd24);
assign d_is_zero = (s2[30:23] <= 8'd126) && ~s2[31];
assign d_is_minuszero = (s2[30:23] == 8'd0) && s2[31];
assign d_is_minusone = (s2[30:23] <= 8'd126) && s2[31];

assign d =
    d_is_s ? s :
    d_is_zero ? 32'd0 :
    d_is_minuszero ? {1'b1, 31'b0} :
    d_is_minusone ? {1'b1, 8'd127, 23'b0} :
    {s[31], exponent_d, mantissa_d};

always @(posedge clk) begin
  integer_part <= integer_part_;
  flag <= flag_;
  s2 <= s;
  ex127 <= exponent_s_minus127;
end

endmodule