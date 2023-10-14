
// Main memory size is 1MB 2^23
// Cache size is 1024 blocks. block size is 1024 bits. (16*64)
// 4 word index bits, 10 block index bits and 3 tag bits.
// Address line length is 17 bits
// each cache block is 1024 + 3(tag) + 1(Validity) + 1(dirty) = 1029

module tb;

reg [17:1] wafull;
reg [64:1] writeval;
reg [17:1] rafull;
wire [64:1] readval;
wire WriteHit, ReadHit;
reg mode;
reg clk;

cache c (wafull, writeval, 
    rafull, readval, 
    WriteHit, ReadHit, 
    clk, mode);

initial begin
    $monitor($time, ": mode: %b, WriteAdd = %b, WriteVal = %b ReadAdd = %b ReadVal = %b," ,
    mode,
    wafull,
    writeval,
    rafull, 
    readval,
    );
end

initial begin
    $dumpfile("c.ved");
    $dumpvars(0, c);
    clk = 1'b0;
    mode = 1'b1; // Write
    wafull = 17'd0;
    writeval = 64'd23;
    rafull = 17'd0;

    #100 mode = 1'b0; rafull = 17'd0;
    #100 mode = 1'b1; wafull = 17'd1; writeval = 64'd42;
    #100 mode = 1'b0; rafull = 17'd1;
    #100 mode = 1'b1; wafull = 17'd8; writeval = 64'd62;
    #100 mode = 1'b0; rafull = 17'd8;

    #500 $finish;
end

always #50 clk = !clk; 

endmodule


