module tb;
	reg [63:0] a,b;
    
	wire [127:0] prod;

	
	wall_mult64 mul1(a,b,prod);

	initial begin
		a = 7; b= 3;
		#10;
		a = 17; b= 13;
		#10;
		a = 27; b= 5;
		#10;
		a = 9; b = 9;
		#10;
	end
	
	initial begin
		$monitor("\n a = %d, b= %d, prod = %d",a,b,prod);  //$monitor is used to display the way form when the values change.
	end

	initial begin
		$dumpfile ("mul1.vcd");
		$dumpvars (0, mul1);
	end
endmodule