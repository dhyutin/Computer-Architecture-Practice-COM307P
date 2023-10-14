module tb;
    reg signed [63:0] a,b;
    reg signed [2:0] sel;
    wire [63:0] res;
    integer i,j,k;

    logic_unit lu1(a,b,res,sel);
    initial begin
        $dumpfile("lu1.ved");
        $dumpvars(0, lu1);
        for(j=0;j<4;j=j+1)
        for(k=0;k<4;k=k+1)
        for(i=0;i<8;i=i+1)
        begin
            a <=j;
            b <= k;
            sel <= i;
            #10;
        end
    end

    initial begin
        $monitor(" \n a = %b\n b = %b\n sel = %b\n res = %b\n",a,b,sel,res);
    end
endmodule