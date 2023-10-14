// N Sree Dhyuti
// CED19I027
// CA LAB 4 : 64-Bit Wallace Tree Multiplier

//Set the measurement and precision of time
`timescale 1ns / 1ps

//1-Bit Full Adder Module
module HalfAdder (a, b, sum, cout);
	input a, b;
	output sum, cout;
	xor x1 (sum, a, b);
	and a1 (cout, a, b);
endmodule

// 1-Bit Full Adder Mofule
module FullAdder(a, b, cin, sum, cout);
	input a, b, cin;
	output sum, cout;
	wire w1, w2, w3;

	xor x1 (sum, a, b, cin);

	and a1 (w1, a, b);
	xor x2 (w2, a, b);
	and a2 (w3, w2, cin);
	or o1 (cout, w3, w1);

endmodule

// 4-bit Full Adder 
module FullAdder4Bit(a, b, cin, sum, carry);
	input [3:0] a, b;
	input cin;
	output [3:0] sum;
	output carry;
	wire [2:0] c;
	
	FullAdder f1_1 (a[0], b[0], cin, sum[0], c[0]);
	FullAdder f1_2 (a[1], b[1], c[0], sum[1], c[1]);
	FullAdder f1_3 (a[2], b[2], c[1], sum[2], c[2]);
	FullAdder f1_4 (a[3], b[3], c[2], sum[3], carry);
	
endmodule

// 8-bit Full Adder
module FullAdder8Bit(a, b, cin, sum, carry);
	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output carry;
	wire c;
	
	FullAdder4Bit f4_1 (a[3:0], b[3:0], cin, sum[3:0], c);
	FullAdder4Bit f4_2 (a[7:4], b[7:4], c, sum[7:4], carry);
	
endmodule

// 16-Bit Full Adder
module FullAdder16Bit(a, b, cin, sum, carry);
	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output carry;
	wire c;
	
	FullAdder8Bit f8_1 (a[7:0], b[7:0], cin, sum[7:0], c);
	FullAdder8Bit f8_2 (a[15:8], b[15:8], c, sum[15:8], carry);
	
endmodule

// 32-Bit Full Adder
module FullAdder32Bit(a, b, cin, sum, carry);
	input [31:0] a, b;
	input cin;
	output [31:0] sum;
	output carry;
	wire c;
	
	FullAdder16Bit f16_1 (a[15:0], b[15:0], cin, sum[15:0], c);
	FullAdder16Bit f16_2 (a[31:16], b[31:16], c, sum[31:16], carry);
	
endmodule

// 64-Bit Full Adder
module FullAdder64Bit(a, b, cin, sum, carry);
	input [63:0] a, b;
	input cin;
	output [63:0] sum;
	output carry;
	wire c;
	
	FullAdder32Bit f32_1 (a[31:0], b[31:0], cin, sum[31:0], c);
	FullAdder32Bit f32_2 (a[63:32], b[63:32], c, sum[63:32], carry);
	
endmodule

// 128-Bit Full Adder
module FullAdder128Bit(a, b, cin, sum, carry);
	input [127:0] a, b;
	input cin;
	output [127:0] sum;
	output carry;
	wire c;
	
	FullAdder64Bit f64_1 (a[63:0], b[63:0], cin, sum[63:0], c);
	FullAdder64Bit f64_2 (a[127:64], b[127:64], c, sum[127:64], carry);
	
endmodule

//8-Bit Wallace Tree Multiplier
module wall_mult8 (a,b,product);
	input [8:1] a, b;
	output wire [16:1] product;
	
	wire [8:1] p1, p2, p3, p4, p5, p6, p7, p8;

	wire [16:1] sum_1, sum_2, sum_3, sum_4, sum_5, sum_6;
	wire [16:1] carry_1, carry_2, carry_3, carry_4, carry_5, carry_6;
	wire [16:1] final_a, final_b;
	
	wire cin, carry;

	assign p1 = a & {8{b[1]}};
	assign p2 = a & {8{b[2]}};
	assign p3 = a & {8{b[3]}};
	assign p4 = a & {8{b[4]}};
	assign p5 = a & {8{b[5]}};
	assign p6 = a & {8{b[6]}};
	assign p7 = a & {8{b[7]}};
	assign p8 = a & {8{b[8]}};


	//iteration 1
	assign sum_1[1] = p1[1];
	HalfAdder ha_1 (p1[2], p2[1], sum_1[2], carry_1[1]);
	FullAdder fa_1 (p1[3], p2[2], p3[1], sum_1[3], carry_1[2]);
	FullAdder fa_2 (p1[4], p2[3], p3[2], sum_1[4], carry_1[3]);
	FullAdder fa_3 (p1[5], p2[4], p3[3], sum_1[5], carry_1[4]);
	FullAdder fa_4 (p1[6], p2[5], p3[4], sum_1[6], carry_1[5]);
	FullAdder fa_5 (p1[7], p2[6], p3[5], sum_1[7], carry_1[6]);
	FullAdder fa_6 (p1[8], p2[7], p3[6], sum_1[8], carry_1[7]);
	HalfAdder ha_2 (p2[8], p3[7], sum_1[9], carry_1[8]);
	assign sum_1[10] = p3[8];

	assign sum_2[1] = p4[1];
	HalfAdder ha_3 (p4[2], p5[1], sum_2[2], carry_2[1]);
	FullAdder fa_7 (p4[3], p5[2], p6[1], sum_2[3], carry_2[2]);
	FullAdder fa_8 (p4[4], p5[3], p6[2], sum_2[4], carry_2[3]);
	FullAdder fa_9 (p4[5], p5[4], p6[3], sum_2[5], carry_2[4]);
	FullAdder fa_10 (p4[6], p5[5], p6[4], sum_2[6], carry_2[5]);
	FullAdder fa_11 (p4[7], p5[6], p6[5], sum_2[7], carry_2[6]);
	FullAdder fa_12 (p4[8], p5[7], p6[6], sum_2[8], carry_2[7]);
	HalfAdder ha_4 (p5[8], p6[7], sum_2[9], carry_2[8]);
	assign sum_2[10] = p6[8];


	//iteration 2
	assign sum_3[1] = sum_1[1];
	assign sum_3[2] = sum_1[2];
	HalfAdder ha_5 (sum_1[3], carry_1[1], sum_3[3], carry_3[1]);
	FullAdder fa_13 (sum_1[4], carry_1[2], sum_2[1], sum_3[4], carry_3[2]);
	FullAdder fa_14 (sum_1[5], carry_1[3], sum_2[2], sum_3[5], carry_3[3]);
	FullAdder fa_15 (sum_1[6], carry_1[4], sum_2[3], sum_3[6], carry_3[4]);
	FullAdder fa_16 (sum_1[7], carry_1[5], sum_2[4], sum_3[7], carry_3[5]);
	FullAdder fa_17 (sum_1[8], carry_1[6], sum_2[5], sum_3[8], carry_3[6]);
	FullAdder fa_18 (sum_1[9], carry_1[7], sum_2[6], sum_3[9], carry_3[7]);
	FullAdder fa_19 (sum_1[10], carry_1[8], sum_2[7], sum_3[10], carry_3[8]);
	assign sum_3[11] = sum_2[8];
	assign sum_3[12] = sum_2[9];
	assign sum_3[13] = sum_2[10];

	assign sum_4[1] = carry_2[1];
	HalfAdder ha_6 (carry_2[2], p7[1], sum_4[2], carry_4[1]);
	FullAdder fa_20 (carry_2[3], p7[2], p8[1], sum_4[3], carry_4[2]);
	FullAdder fa_21 (carry_2[4], p7[3], p8[2], sum_4[4], carry_4[3]);
	FullAdder fa_22 (carry_2[5], p7[4], p8[3], sum_4[5], carry_4[4]);
	FullAdder fa_23 (carry_2[6], p7[5], p8[4], sum_4[6], carry_4[5]);
	FullAdder fa_24 (carry_2[7], p7[6], p8[5], sum_4[7], carry_4[6]);
	FullAdder fa_25 (carry_2[8], p7[7], p8[6], sum_4[8], carry_4[7]);
	HalfAdder ha_7 (p7[8], p8[7], sum_4[9], carry_4[8]);
	assign sum_4[10] = p8[8];


	//iteration 3
	assign sum_5[1] = sum_3[1];
	assign sum_5[2] = sum_3[2];
	assign sum_5[3] = sum_3[3];
	HalfAdder ha_8 (sum_3[4], carry_3[1], sum_5[4], carry_5[1]);
	HalfAdder ha_9 (sum_3[5], carry_3[2], sum_5[5], carry_5[2]);
	FullAdder fa_26 (sum_3[6], carry_3[3], sum_4[1], sum_5[6], carry_5[3]);
	FullAdder fa_27 (sum_3[7], carry_3[4], sum_4[2], sum_5[7], carry_5[4]);
	FullAdder fa_28 (sum_3[8], carry_3[5], sum_4[3], sum_5[8], carry_5[5]);
	FullAdder fa_29 (sum_3[9], carry_3[6], sum_4[4], sum_5[9], carry_5[6]);
	FullAdder fa_30 (sum_3[10], carry_3[7], sum_4[5], sum_5[10], carry_5[7]);
	FullAdder fa_31 (sum_3[11], carry_3[8], sum_4[6], sum_5[11], carry_5[8]);
	HalfAdder ha_10 (sum_3[12], sum_4[7], sum_5[12], carry_5[9]);
	HalfAdder ha_11 (sum_3[13], sum_4[8], sum_5[13], carry_5[10]);
	assign sum_5[14] = sum_4[9];
	assign sum_5[15] = sum_4[10];


	//iteration 4
	assign sum_6[1] = sum_5[1];
	assign sum_6[2] = sum_5[2];
	assign sum_6[3] = sum_5[3];
	assign sum_6[4] = sum_5[4];
	HalfAdder ha_12 (sum_5[5], carry_5[1], sum_6[5], carry_6[1]);
	HalfAdder ha_13 (sum_5[6], carry_5[2], sum_6[6], carry_6[2]);
	HalfAdder ha_14 (sum_5[7], carry_5[3], sum_6[7], carry_6[3]);
	FullAdder fa_32 (sum_5[8], carry_5[4], carry_4[1], sum_6[8], carry_6[4]);
	FullAdder fa_33 (sum_5[9], carry_5[5], carry_4[2], sum_6[9], carry_6[5]);
	FullAdder fa_34 (sum_5[10], carry_5[6], carry_4[3], sum_6[10], carry_6[6]);
	FullAdder fa_35 (sum_5[11], carry_5[7], carry_4[4], sum_6[11], carry_6[7]);
	FullAdder fa_36 (sum_5[12], carry_5[8], carry_4[5], sum_6[12], carry_6[8]);
	FullAdder fa_37 (sum_5[13], carry_5[9], carry_4[6], sum_6[13], carry_6[9]);
	FullAdder fa_38 (sum_5[14], carry_5[10], carry_4[7], sum_6[14], carry_6[10]);
	HalfAdder ha_15 (sum_5[15], carry_4[8], sum_6[15], carry_6[11]);

	//final_a
	assign final_a[15:1] = sum_6[15:1];
	assign final_a[16] = 1'b0;

	//final_b
	assign final_b[1] = 1'b0;
	assign final_b[2] = 1'b0;
	assign final_b[3] = 1'b0;
	assign final_b[4] = 1'b0;
	assign final_b[5] = 1'b0;
	assign final_b[16:6] = carry_6[11:1];

	assign cin = 1'b0;

	//last iteration
	wire [11:1]car;
	assign product[1] = sum_6[1];
	assign product[2] = sum_6[2];
	assign product[3] = sum_6[3];
	assign product[4] = sum_6[4];
	assign product[5] = sum_6[5];


	HalfAdder f39 (sum_6[6], carry_6[1], product[6], car[1]);
	FullAdder f40 (sum_6[7], carry_6[2], car[1], product[7], car[2]);
	FullAdder f41 (sum_6[8], carry_6[3], car[2], product[8], car[3]);
	FullAdder f42 (sum_6[9], carry_6[4], car[3], product[9], car[4]);
	FullAdder f43 (sum_6[10], carry_6[5], car[4], product[10], car[5]);
	FullAdder f44 (sum_6[11], carry_6[6], car[5], product[11], car[6]);
	FullAdder f45 (sum_6[12], carry_6[7], car[6], product[12], car[7]);
	FullAdder f46 (sum_6[13], carry_6[8], car[7], product[13], car[8]);
	FullAdder f47 (sum_6[14], carry_6[9], car[8], product[14], car[9]);
	FullAdder f48 (sum_6[15], carry_6[10], car[9], product[15], car[10]);

	HalfAdder h13 (carry_6[11], car[9], product[16], car[11]);

endmodule

module wall_mult64(a, b, op);
    input[63:0] a, b;
    output[127:0] op;
    
	wire [127:0] pp[63:0];
	
	//2
	assign pp[0][127:16] = 0;
	wall_mult8 w1 (a[7:0], b[7:0], pp[0][15:0]);
	
	//3
	assign pp[1][7:0] = 0;
	assign pp[1][127:24] = 0;
	wall_mult8 w2 (a[7:0], b[15:8], pp[1][23:8]);
	assign pp[2][7:0] = 0;
	assign pp[2][127:24] = 0;
	wall_mult8 w3 (a[15:8], b[7:0], pp[2][23:8]);
	
	//4
	assign pp[3][15:0] = 0;
	assign pp[3][127:32] = 0;
	wall_mult8 w4 (a[7:0], b[23:16], pp[3][31:16]);
	assign pp[4][15:0] = 0;
	assign pp[4][127:32] = 0;
	wall_mult8 w5 (a[23:16], b[7:0], pp[4][31:16]);
	assign pp[5][15:0] = 0;
	assign pp[5][127:32] = 0;
	wall_mult8 w6 (a[15:8], b[15:8], pp[5][31:16]);
	
	//5
	assign pp[6][23:0] = 0;
	assign pp[6][127:40] = 0;
	wall_mult8 w7 (a[7:0], b[31:24], pp[6][39:24]);
	assign pp[7][23:0] = 0;
	assign pp[7][127:40] = 0;
	wall_mult8 w8 (a[31:24], b[7:0], pp[7][39:24]);
	assign pp[8][23:0] = 0;
	assign pp[8][127:40] = 0;
	wall_mult8 w9 (a[23:16], b[15:8], pp[8][39:24]);
	assign pp[9][23:0] = 0;
	assign pp[9][127:40] = 0;
	wall_mult8 w10 (a[15:8], b[23:16], pp[9][39:24]);
	
	//6
	assign pp[10][31:0] = 0;
	assign pp[10][127:48] = 0;
	wall_mult8 w11 (a[7:0], b[39:32], pp[10][47:32]);
	assign pp[11][31:0] = 0;
	assign pp[11][127:48] = 0;
	wall_mult8 w12 (a[39:32], b[7:0], pp[11][47:32]);
	assign pp[12][31:0] = 0;
	assign pp[12][127:48] = 0;
	wall_mult8 w13 (a[15:8], b[31:24], pp[12][47:32]);
	assign pp[13][31:0] = 0;
	assign pp[13][127:48] = 0;
	wall_mult8 w14 (a[31:24], b[15:8], pp[13][47:32]);
	assign pp[14][31:0] = 0;
	assign pp[14][127:48] = 0;
	wall_mult8 w15 (a[23:16], b[23:16], pp[14][47:32]);
	
	//7
	assign pp[15][39:0] = 0;
	assign pp[15][127:56] = 0;
	wall_mult8 w16 (a[7:0], b[47:40], pp[15][55:40]);
	assign pp[16][39:0] = 0;
	assign pp[16][127:56] = 0;
	wall_mult8 w17 (a[47:40], b[7:0], pp[16][55:40]);
	assign pp[17][39:0] = 0;
	assign pp[17][127:56] = 0;
	wall_mult8 w18 (a[15:8], b[39:32], pp[17][55:40]);
	assign pp[18][39:0] = 0;
	assign pp[18][127:56] = 0;
	wall_mult8 w19 (a[39:32], b[15:8], pp[18][55:40]);
	assign pp[19][39:0] = 0;
	assign pp[19][127:56] = 0;
	wall_mult8 w20 (a[23:16], b[31:24], pp[19][55:40]);
	assign pp[20][39:0] = 0;
	assign pp[20][127:56] = 0;
	wall_mult8 w21 (a[31:24], b[23:16], pp[20][55:40]);
	
	//8
	assign pp[21][47:0] = 0;
	assign pp[21][127:64] = 0;
	wall_mult8 w22 (a[7:0], b[55:48], pp[21][63:48]);
	assign pp[22][47:0] = 0;
	assign pp[22][127:64] = 0;
	wall_mult8 w23 (a[55:48], b[7:0], pp[22][63:48]);
	assign pp[23][47:0] = 0;
	assign pp[23][127:64] = 0;
	wall_mult8 w24 (a[15:8], b[47:40], pp[23][63:48]);
	assign pp[24][47:0] = 0;
	assign pp[24][127:64] = 0;
	wall_mult8 w25 (a[47:40], b[15:8], pp[24][63:48]);
	assign pp[25][47:0] = 0;
	assign pp[25][127:64] = 0;
	wall_mult8 w26 (a[23:16], b[39:32], pp[25][63:48]);
	assign pp[26][47:0] = 0;
	assign pp[26][127:64] = 0;
	wall_mult8 w27 (a[39:32], b[23:16], pp[26][63:48]);
	assign pp[27][47:0] = 0;
	assign pp[27][127:64] = 0;
	wall_mult8 w28 (a[31:24], b[31:24], pp[27][63:48]);
	
	//9
	assign pp[28][55:0] = 0;
	assign pp[28][127:72] = 0;
	wall_mult8 w29 (a[7:0], b[63:56], pp[28][71:56]);
	assign pp[29][55:0] = 0;
	assign pp[29][127:72] = 0;
	wall_mult8 w30 (a[63:56], b[7:0], pp[29][71:56]);
	assign pp[30][55:0] = 0;
	assign pp[30][127:72] = 0;
	wall_mult8 w31 (a[15:8], b[55:48], pp[30][71:56]);
	assign pp[31][55:0] = 0;
	assign pp[31][127:72] = 0;
	wall_mult8 w32 (a[55:48], b[15:8], pp[31][71:56]);
	assign pp[32][55:0] = 0;
	assign pp[32][127:72] = 0;
	wall_mult8 w33 (a[23:16], b[47:40], pp[32][71:56]);
	assign pp[33][55:0] = 0;
	assign pp[33][127:72] = 0;
	wall_mult8 w34 (a[47:40], b[23:16], pp[33][71:56]);
	assign pp[34][55:0] = 0;
	assign pp[34][127:72] = 0;
	wall_mult8 w35 (a[31:24], b[39:32], pp[34][71:56]);
	assign pp[35][55:0] = 0;
	assign pp[35][127:72] = 0;
	wall_mult8 w36 (a[39:32], b[31:24], pp[35][71:56]);
	
	//10
	assign pp[36][63:0] = 0;
	assign pp[36][127:80] = 0;
	wall_mult8 w37 (a[15:8], b[63:56], pp[36][79:64]);
	assign pp[37][63:0] = 0;
	assign pp[37][127:80] = 0;
	wall_mult8 w38 (a[63:56], b[15:8], pp[37][79:64]);
	assign pp[38][63:0] = 0;
	assign pp[38][127:80] = 0;
	wall_mult8 w39 (a[23:16], b[55:48], pp[38][79:64]);
	assign pp[39][63:0] = 0;
	assign pp[39][127:80] = 0;
	wall_mult8 w40 (a[55:48], b[23:16], pp[39][79:64]);
	assign pp[40][63:0] = 0;
	assign pp[40][127:80] = 0;
	wall_mult8 w41 (a[31:24], b[47:40], pp[40][79:64]);
	assign pp[41][63:0] = 0;
	assign pp[41][127:80] = 0;
	wall_mult8 w42 (a[47:40], b[31:24], pp[41][79:64]);
	assign pp[42][63:0] = 0;
	assign pp[42][127:80] = 0;
	wall_mult8 w43 (a[39:32], b[39:32], pp[42][79:64]);
	
	//11
	assign pp[43][71:0] = 0;
	assign pp[43][127:88] = 0;
	wall_mult8 w44 (a[23:16], b[63:56], pp[43][87:72]);
	assign pp[44][71:0] = 0;
	assign pp[44][127:88] = 0;
	wall_mult8 w45 (a[63:56], b[23:16], pp[44][87:72]);
	assign pp[45][71:0] = 0;
	assign pp[45][127:88] = 0;
	wall_mult8 w46 (a[31:24], b[55:48], pp[45][87:72]);
	assign pp[46][71:0] = 0;
	assign pp[46][127:88] = 0;
	wall_mult8 w47 (a[55:48], b[31:24], pp[46][87:72]);
	assign pp[47][71:0] = 0;
	assign pp[47][127:88] = 0;
	wall_mult8 w48 (a[39:32], b[47:40], pp[47][87:72]);
	assign pp[48][71:0] = 0;
	assign pp[48][127:88] = 0;
	wall_mult8 w49 (a[47:40], b[39:32], pp[48][87:72]);
	
	//12
	assign pp[49][79:0] = 0;
	assign pp[49][127:96] = 0;
	wall_mult8 w50 (a[31:24], b[63:56], pp[49][95:80]);
	assign pp[50][79:0] = 0;
	assign pp[50][127:96] = 0;
	wall_mult8 w51 (a[63:56], b[31:24], pp[50][95:80]);
	assign pp[51][79:0] = 0;
	assign pp[51][127:96] = 0;
	wall_mult8 w52 (a[39:32], b[55:48], pp[51][95:80]);
	assign pp[52][79:0] = 0;
	assign pp[52][127:96] = 0;
	wall_mult8 w53 (a[55:48], b[39:32], pp[52][95:80]);
	assign pp[53][79:0] = 0;
	assign pp[53][127:96] = 0;
	wall_mult8 w54 (a[47:40], b[47:40], pp[53][95:80]);
	
	//13
	assign pp[54][87:0] = 0;
	assign pp[54][127:104] = 0;
	wall_mult8 w55 (a[39:32], b[63:56], pp[54][103:88]);
	assign pp[55][87:0] = 0;
	assign pp[55][127:104] = 0;
	wall_mult8 w56 (a[63:56], b[39:32], pp[55][103:88]);
	assign pp[56][87:0] = 0;
	assign pp[56][127:104] = 0;
	wall_mult8 w57 (a[47:40], b[55:48], pp[56][103:88]);
	assign pp[57][87:0] = 0;
	assign pp[57][127:104] = 0;
	wall_mult8 w58 (a[55:48], b[47:40], pp[57][103:88]);
	
	//14
	assign pp[58][95:0] = 0;
	assign pp[58][127:112] = 0;
	wall_mult8 w59 (a[47:40], b[63:56], pp[58][111:96]);
	assign pp[59][95:0] = 0;
	assign pp[59][127:112] = 0;
	wall_mult8 w60 (a[63:56], b[47:40], pp[59][111:96]);
	assign pp[60][95:0] = 0;
	assign pp[60][127:112] = 0;
	wall_mult8 w61 (a[55:48], b[55:48], pp[60][111:96]);
	
	//15
	assign pp[61][103:0] = 0;
	assign pp[61][127:120] = 0;
	wall_mult8 w62 (a[55:48], b[63:56], pp[61][119:104]);
	assign pp[62][103:0] = 0;
	assign pp[62][127:120] = 0;
	wall_mult8 w63 (a[63:56], b[55:48], pp[62][119:104]);
	
	//16
	assign pp[63][111:0] = 0;
	wall_mult8 w64 (a[63:56], b[63:56], pp[63][127:112]);
	
	
	
	wire [127:0] ps[63:0];
	wire cout;
	
	FullAdder128Bit f1 (pp[0], pp[1], 1'b0, ps[0], cout);
	
	FullAdder128Bit f2 (ps[0], pp[2], 1'b0,ps[1], cout);
	FullAdder128Bit f3 (ps[1], pp[3], 1'b0,ps[2], cout);
	FullAdder128Bit f4 (ps[2], pp[4], 1'b0,ps[3], cout);
	FullAdder128Bit f5 (ps[3], pp[5], 1'b0,ps[4], cout);
	FullAdder128Bit f6 (ps[4], pp[6], 1'b0,ps[5], cout);
	FullAdder128Bit f7 (ps[5], pp[7], 1'b0,ps[6], cout);
	FullAdder128Bit f8 (ps[6], pp[8], 1'b0,ps[7], cout);
	FullAdder128Bit f9 (ps[7], pp[9], 1'b0,ps[8], cout);
	FullAdder128Bit f10 (ps[8], pp[10], 1'b0,ps[9], cout);	
	
	FullAdder128Bit f13 (ps[9], pp[11], 1'b0,ps[10], cout);
	FullAdder128Bit f14 (ps[10], pp[12], 1'b0,ps[11], cout);
	FullAdder128Bit f15 (ps[11], pp[13], 1'b0,ps[12], cout);
	FullAdder128Bit f16 (ps[12], pp[14], 1'b0,ps[13], cout);
	FullAdder128Bit f17 (ps[13], pp[15], 1'b0,ps[14], cout);
	FullAdder128Bit f18 (ps[14], pp[16], 1'b0,ps[15], cout);
	FullAdder128Bit f19 (ps[15], pp[17], 1'b0,ps[16], cout);
	FullAdder128Bit f20 (ps[16], pp[18], 1'b0,ps[17], cout);
	FullAdder128Bit f21 (ps[17], pp[19], 1'b0,ps[18], cout);
	FullAdder128Bit f22 (ps[18], pp[20], 1'b0,ps[19], cout);
	
	FullAdder128Bit f113 (ps[19], pp[21], 1'b0,ps[20], cout);
	FullAdder128Bit f114 (ps[20], pp[22], 1'b0,ps[21], cout);
	FullAdder128Bit f115 (ps[21], pp[23], 1'b0,ps[22], cout);
	FullAdder128Bit f116 (ps[22], pp[24], 1'b0,ps[23], cout);
	FullAdder128Bit f117 (ps[23], pp[25], 1'b0,ps[24], cout);
	FullAdder128Bit f118 (ps[24], pp[26], 1'b0,ps[25], cout);
	FullAdder128Bit f119 (ps[25], pp[27], 1'b0,ps[26], cout);
	FullAdder128Bit f210 (ps[26], pp[28], 1'b0,ps[27], cout);
	FullAdder128Bit f211 (ps[27], pp[29], 1'b0,ps[28], cout);
	FullAdder128Bit f212 (ps[28], pp[30], 1'b0,ps[29], cout);
	
	FullAdder128Bit f33 (ps[29], pp[31], 1'b0,ps[30], cout);
	FullAdder128Bit f34 (ps[30], pp[32], 1'b0,ps[31], cout);
	FullAdder128Bit f35 (ps[31], pp[33], 1'b0,ps[32], cout);
	FullAdder128Bit f36 (ps[32], pp[34], 1'b0,ps[33], cout);
	FullAdder128Bit f37 (ps[33], pp[35], 1'b0,ps[34], cout);
	FullAdder128Bit f38 (ps[34], pp[36], 1'b0,ps[35], cout);
	FullAdder128Bit f39 (ps[35], pp[37], 1'b0,ps[36], cout);
	FullAdder128Bit f30 (ps[36], pp[38], 1'b0,ps[37], cout);
	FullAdder128Bit f31 (ps[37], pp[39], 1'b0,ps[38], cout);
	FullAdder128Bit f32 (ps[38], pp[40], 1'b0,ps[39], cout);
	
	FullAdder128Bit f43 (ps[39], pp[41], 1'b0,ps[40], cout);
	FullAdder128Bit f44 (ps[40], pp[42], 1'b0,ps[41], cout);
	FullAdder128Bit f45 (ps[41], pp[43], 1'b0,ps[42], cout);
	FullAdder128Bit f46 (ps[42], pp[44], 1'b0,ps[43], cout);
	FullAdder128Bit f47 (ps[43], pp[45], 1'b0,ps[44], cout);
	FullAdder128Bit f48 (ps[44], pp[46], 1'b0,ps[45], cout);
	FullAdder128Bit f49 (ps[45], pp[47], 1'b0,ps[46], cout);
	FullAdder128Bit f40 (ps[46], pp[48], 1'b0,ps[47], cout);
	FullAdder128Bit f41 (ps[47], pp[49], 1'b0,ps[48], cout);
	FullAdder128Bit f42 (ps[48], pp[50], 1'b0,ps[49], cout);
	
	FullAdder128Bit f53 (ps[49], pp[51], 1'b0,ps[50], cout);
	FullAdder128Bit f54 (ps[50], pp[52], 1'b0,ps[51], cout);
	FullAdder128Bit f55 (ps[51], pp[53], 1'b0,ps[52], cout);
	FullAdder128Bit f56 (ps[52], pp[54], 1'b0,ps[53], cout);
	FullAdder128Bit f57 (ps[53], pp[55], 1'b0,ps[54], cout);
	FullAdder128Bit f58 (ps[54], pp[56], 1'b0,ps[55], cout);
	FullAdder128Bit f59 (ps[55], pp[57], 1'b0,ps[56], cout);
	FullAdder128Bit f50 (ps[56], pp[58], 1'b0,ps[57], cout);
	FullAdder128Bit f51 (ps[57], pp[59], 1'b0,ps[58], cout);
	FullAdder128Bit f52 (ps[58], pp[60], 1'b0,ps[59], cout);
	 
	FullAdder128Bit f63 (ps[59], pp[61], 1'b0,ps[60], cout);
	FullAdder128Bit f64 (ps[60], pp[62], 1'b0,ps[61], cout);
	FullAdder128Bit f65 (ps[61], pp[63], 1'b0,op, cout);

endmodule