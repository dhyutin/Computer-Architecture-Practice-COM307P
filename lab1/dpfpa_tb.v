module dpfpa_tb;
	reg s1,s2;
	reg [10:0] e1,e2;
	reg [51:0] m1,m2;
    
	wire [51:0] m;
	wire [10:0] e;
	wire s;
	
	dpfp_adder addit(s1,e1,m1,s2,e2,m2,s,m,e);

	initial begin

		s1 = 1'b0; e1 = 1024; m1 = 52'b0; s2 = 1'b0; e2 = 1023; m2 = {2'b11, 50'b0}; #10;
		

		s1 = 1'b0; e1 = 1026; m1 = 52'b0; s2 = 1'b1; e2 = 1024; m2 = {2'b01, 50'b0}; #10;
		

		s1 = 1'b0; e1 = 1024; m1 = {5'b00101, 47'b0}; s2 = 1'b1; e2 = 1022; m2 = {3'b001, 49'b0}; #10;
		

		s1 = 1'b0; e1 = 1026; m1 = {2'b01, 50'b0}; s2 = 1'b1; e2 = 1024; m2 = {5'b00111, 47'b0}; #10;
		

		s1 = 1'b1; e1 = 1024; m1 = {2'b01, 50'b0}; s2 = 1'b0; e2 = 1026; m2 = {5'b00111, 47'b0}; #10;
		

		s1 = 1'b0; e1 = 1024; m1 = 52'b0; s2 = 1'b0; e2 = 1024; m2 = 52'b0;  #10;
		
	end
	
	initial begin
		$monitor("\n s1 = %b, e1 = %b, m1 = %b \n s2 = %b, e2 = %b, m2 = %b \n s3 = %b, e3 = %b, m3 = %b", s1, e1, m1, s2, e2, m2, s, e, m);  //$monitor is used to display the way form when the values change.
	end

	

	initial begin
		$dumpfile ("addit.vcd");
		$dumpvars (0, addit);
	end
	
endmodule
