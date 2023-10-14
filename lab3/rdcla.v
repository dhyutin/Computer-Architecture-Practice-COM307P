// N Sree Dhyuti
// CED19I027
// CA LAB 3 : 64-Bit Recursive doubling based carry lookahead adder

//Set the measurement and precision of time
`timescale 1ns / 1ps

module kpg_init (o1, o0, a, b);
    input a, b;
    output reg o1, o0;
	always @(*)
	case ({a, b})
		2'b00: begin
			o0 = 1'b0; o1 = 1'b0;
		end
		2'b11: begin
			o0 = 1'b1; o1 = 1'b1;
		end
		default: begin 
			o0 = 1'b0; o1 = 1'b1;
		end
	endcase

endmodule

module kpg (cur_1, cur_0, prev_1, prev_0, out_1, out_0);
	input cur_1, cur_0, prev_1, prev_0;
	output reg out_1, out_0;
	
	always @(*)
	begin
		if({cur_1, cur_0} == 2'b00)
			{out_1, out_0} = 2'b00;
		
		if({cur_1, cur_0} == 2'b11)
			{out_1, out_0} = 2'b11;

		if({cur_1, cur_0} == 2'b10)
			{out_1, out_0} = {prev_1, prev_0};
	end
endmodule

module rdcla (sum, cout, a, b, cin);

	input [63:0] a, b;
	input cin;
	output reg [63:0] sum;
	output reg cout;

	wire [64:0] carry0, carry1;
	wire [64:0] carry0_1, carry1_1, carry0_2, carry1_2, carry0_4, carry1_4, carry0_8, carry1_8, carry0_16, carry1_16, carry1_32, carry0_32;

	assign carry0[0] = cin;
	assign carry1[0] = cin;

	always @(*)
	begin
		sum = a^b;
		sum = sum[63:0] ^ carry0_32[63:0];
		cout = carry0_32[64];	
	end
	
	kpg_init i [64:1] (carry1[64:1], carry0[64:1], a[63:0], b[63:0]);

	assign carry1_1[0] = cin;
	assign carry0_1[0] = cin;
	assign carry1_2[1:0] = carry1_1[1:0];
	assign carry0_2[1:0] = carry0_1[1:0];
	assign carry1_4[3:0] = carry1_2[3:0];
	assign carry0_4[3:0] = carry0_2[3:0];
	assign carry1_8[7:0] = carry1_4[7:0];
	assign carry0_8[7:0] = carry0_4[7:0];
	assign carry1_16[15:0] = carry1_8[15:0];
	assign carry0_16[15:0] = carry0_8[15:0];
	assign carry1_32[31:0] = carry1_16[31:0];
	assign carry0_32[31:0] = carry0_16[31:0];

	kpg i1 [64:1] (carry1[64:1], carry0[64:1], carry1[63:0], carry0[63:0], carry1_1[64:1], carry0_1[64:1]);
	kpg i2 [64:2] (carry1_1[64:2], carry0_1[64:2], carry1_1[62:0], carry0_1[62:0], carry1_2[64:2], carry0_2[64:2]);
	kpg i4 [64:4] (carry1_2[64:4], carry0_2[64:4], carry1_2[60:0], carry0_2[60:0], carry1_4[64:4], carry0_4[64:4]);
	kpg i8 [64:8] (carry1_4[64:8], carry0_4[64:8], carry1_4[56:0], carry0_4[56:0], carry1_8[64:8], carry0_8[64:8]);
	kpg i16 [64:16] (carry1_8[64:16], carry0_8[64:16], carry1_8[48:0], carry0_8[48:0], carry1_16[64:16], carry0_16[64:16]);
	kpg i32 [64:32] (carry1_16[64:32], carry0_16[64:32], carry1_16[32:0], carry0_16[32:0], carry1_32[64:32], carry0_32[64:32]);

endmodule
