module top;
 // Inputs
 reg [63:0] I1;
 reg [3:0] si1;
 reg [3:0] so1;
 reg [3:0] so2;
 reg RD;
 reg WR;
 reg rst;
 reg EN;
 reg clk;
// Outputs
 wire [63:0] O1;
 wire [63:0] O2;

 regfile uut (.I1(I1), .si1(si1), .O1(O1), .so1(so1), .O2(O2), .so2(so2), .RD(RD), .WR(WR), .rst(rst), .EN(EN), .clk(clk));
 
 
 initial begin
 
 $dumpfile("uut.ved");
    $dumpvars(0, uut);
  // Initialize Inputs
  I1  = 64'b0;
  si1  = 4'b0000;
  so1  = 4'b0000;
  so2  = 4'b0000;
  RD  = 1'b0;
  WR  = 1'b0;
  rst  = 1'b1;
  EN  = 1'b1;
  clk  = 1'b0;


   #10; rst = 1'b0; EN  = 1'b1; WR  = 1'b1; RD = 1'b0; I1  = 64'b0000000000001111000000000000000000000000000011110000000000000000; si1  = 4'b0000;

   #10; I1  = 64'b1111000000000000000000000000000000000000000011110000000000000000; si1  = 4'b0001;
   
   #10; WR  = 1'b0; RD  = 1'b1;so1  = 4'b0000; so2  = 4'b0001;

 end 

always
begin
  clk = ~clk;
  #5;
  #500 $finish;
end 

initial begin
$monitor($time , "\nI1 = %b, si1= %b\n O1 = %b, so1 = %b\nO2 = %b, so2 = %b\nRD = %b, WR = %b, rst = %b, EN = %b, clk = %b",I1,si1,O1,so1,O2,so2,RD,WR,rst,EN,clk);
end
endmodule