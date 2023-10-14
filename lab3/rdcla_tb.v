module testbench;
reg [63:0] a, b;
wire [63:0] s;
wire cout;
reg cin;

rdcla test (s, cout, a, b, cin);

initial
begin
    $dumpfile("test.ved");
    $dumpvars(0, test);
	a = 64'd123; b = 64'd123; cin = 1'b1; #10;
	a = 64'd200; b = 64'd243; cin = 1'b0; #10;
end
initial
	$monitor ("a =   %d;\nb =   %d;\ncarry_in =               %d;\nsum = %d;\ncarry_out =               %d;\n", a, b, cin, s, cout);

endmodule