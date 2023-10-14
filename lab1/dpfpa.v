// CA LAB 1 : Double Precision Floating Point Number Adder Design
// N Sree Dhyuti : CED19I027

// Full Adder Module
module FA_structural(a, b, cin, sum, cout); 
    
    input a, b, cin;
    output sum, cout; 
 	
    wire w1, w2, w3;
    xor g1 (sum, a, b, cin);
    xor g2 (w3, a, b);
    and a1 (w1, a, b);
    and a2 (w2, cin, w3);
    or o1 (cout, w2, w1);
	
endmodule

// 11-Bit ripple carry Adder
module ripple_adder(a, b, cin, sum, cout);
    
	input [10:0] a, b;
	input cin;
	
	output [10:0] sum;
	output cout;
	
	wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
		
	FA_structural a1 (a[0], b[0], cin, sum[0], w1);
	FA_structural a2 (a[1], b[1], w1, sum[1], w2);
	FA_structural a3 (a[2], b[2], w2, sum[2], w3);
	FA_structural a4 (a[3], b[3], w3, sum[3], w4);
	FA_structural a5 (a[4], b[4], w4, sum[4], w5);
	FA_structural a6 (a[5], b[5], w5, sum[5], w6);
	FA_structural a7 (a[6], b[6], w6, sum[6], w7);
	FA_structural a8 (a[7], b[7], w7, sum[7], w8);
	FA_structural a9 (a[8], b[8], w8, sum[8], w9);
	FA_structural a10 (a[9], b[9], w9, sum[9], w10);
	FA_structural a11 (a[10], b[10], w10, sum[10], cout);
	
endmodule

// 52-Bir Ripple Carry Adder
module rca(a, b, cin, sum, cout);
 	input [52:0] a ,b;
	input cin;
	
	output [52:0] sum;
	output cout;
	wire [52:0] w;
	
	genvar i;
	FA_structural f1(a[0], b[0], cin, sum[0], w[1]);
	generate
		for(i = 1; i < 52; i = i + 1)
		begin
			FA_structural uut(a[i], b[i], w[i], sum[i], w[i+1]);
		end 
	endgenerate
	
	FA_structural f52(a[52], b[52], w[52], sum[52], cout);
	
endmodule

// Module to detect right most zeroes
module zero_detector(I, O);

    input [51:0] I;
    output [5:0] O;

    assign O=(I[51])?0: (I[50])?1: (I[49])?2: (I[48])?3:
		    (I[47])?4: (I[46])?5: (I[45])?6: (I[44])?7:
		    (I[43])?8: (I[42])?9: (I[41])?10: (I[40])?11:
		    (I[39])?12: (I[38])?13: (I[37])?14: (I[36])?15:
		    (I[35])?16: (I[34])?17: (I[33])?18: (I[32])?19:
		    (I[31])?20: (I[30])?21: (I[29])?22: (I[28])?23:
		    (I[27])?24: (I[26])?25: (I[25])?26: (I[24])?27:
		    (I[23])?28: (I[22])?29: (I[21])?30: (I[20])?31:
		    (I[19])?32: (I[18])?33: (I[17])?34: (I[16])?35:
		    (I[15])?36: (I[14])?37: (I[13])?38: (I[12])?39:
		    (I[11])?40: (I[10])?41: (I[9])?42: (I[8])?43:
		    (I[7])?44: (I[6])?45: (I[5])?46: (I[4])?47:
		    (I[3])?48: (I[2])?49: (I[1])?50: (I[0])?51:52;

endmodule

// Module to Normalize the given value
module normalize(m3c, mn3, e11, x, m33, e33);
    
    input m3c, x;
    input[52:0] mn3;
    input[10:0] e11;
    
    output wire[51:0] m33;
    output wire[10:0] e33;
    
	wire [5:0] lead_zero_len;
	
	zero_detector z (mn3[52:1], lead_zero_len);
	
	wire [51:0] sub_mn3_r;
	
	assign sub_mn3_r = mn3[52:1] << (lead_zero_len + 1);
		
	assign m33 = (m3c == 1'b1)? (x == 1'b0 ? mn3[52:1] : sub_mn3_r) : mn3[51:0];
	assign e33 = (m3c == 1'b1)? (x == 1'b0 ? e11 + 1: (e11 - lead_zero_len)) : e11;


endmodule

// Double Precision Floating point adder module
module dpfp_adder(s1, e1, m1, s2, e2, m2, s, m, e);

    // s denotes sign of the number
	input s1,s2;
	
	// e denotes value of exponent for base 2
	input [10:0] e1, e2;
	
	// m denotes the mantissa of the number
	input [51:0] m1, m2;
	
	// outputs
	output wire [51:0] m;
	output wire [10:0] e;
	output wire s;
	
	wire [10:0] n;
	wire cout, cout2;
	wire x;
	
	wire [51:0] m11, m22, m33;

	wire [10:0] e11, e22, e33;
	
	wire [52:0] mn1, mn2, mn3, temp;
	wire [52:0] a1, a2, o;
	
	wire m3_c;
	
	assign m11 = (e2 > e1 || (e2 == e1 && m2 > m1))? m2 : m1;
	assign m22 = (e2 > e1 || (e2 == e1 && m2 > m1))? m1 : m2;
	assign e11 = (e2 > e1 || (e2 == e1 && m2 > m1))? e2 : e1;
	assign e22 = (e2 > e1 || (e2 == e1 && m2 > m1))? e1 : e2;
	
	//Set E3=E1 and S3=S1(bigger number)
	//Calculate D = E1 - E2.
	ripple_adder r1 (e11, ~e22, 1'b1, n, cout);
	
	//Left Shift M2 ( along with 1.) by D.
	assign mn2 = {1'b1,m22} >> n;
	
	assign mn1 = {1'b1, m11};
	
	//XOR to know if the numbers have same sign or not.
	assign x = s1 ^ s2;
	
	//to get m2 for addition and ~m2 for subtraction. 
	assign a1 = {53{x}} & (~mn2);   //if x==1 ( subtract)
	
	//and an2 (a2,a12,m_n2);
	assign a2 = {53{~x}} & mn2;   //if x==0  (add)
	
	//or o1 (o,a1,a2);
	assign o = a1 | a2;
	
	rca r_op1 (mn1, o, x, mn3, m3c);
	
	//NORMALIZE
	normalize nn(m3c, mn3, e11, x, m, e);

	assign s = (e2 > e1 || (e2 == e1 && m2 > m1))? s2 : s1; 

endmodule
