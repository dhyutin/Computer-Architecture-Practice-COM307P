
module cache (
    wafull, writeval, 
    rafull, readval, 
    WriteHit, ReadHit, 
    clk, mode
);

input clk, mode; // If mode == 1 - write, else read

reg [63:0] mmem [131071:0]; // reg [63:0] mmem [131071:0] (2^17)

reg [1023:0] icache [1023:0]; //1024 blocks 16* 64 block size
reg [3:1] bt [1023:0];

input [17:1] wafull;
input [64:1] writeval;

input [17:1] rafull;
output reg [64:1] readval;


wire [10:1] wbi;  //block
wire [10:1] rbi;

wire [4:1] wwi;    //index
wire [4:1] rwi;

wire [3:1] WriteTag;
wire [3:1] ReadTag;

reg [1023:0] ValidityBit;
reg [1023:0] DirtyBit;

output reg ReadHit;
output reg WriteHit;

// Assign Tag and Indices
assign WriteTag = wafull[17:15];  //tag bits
assign ReadTag = rafull[17:15];

assign wbi = wafull[14:5]; //block index bits
assign rbi = rafull[14:5];

assign wwi = wafull[4:1];  //word index bits
assign rwi = rafull[4:1];


// Initially Validity and Dirty is 0 for all
integer i;
initial begin
    i = 0;
    while (i < 1024) begin
        ValidityBit[i] = 1'b0;
        DirtyBit[i] = 1'b0;
        icache[i] = 1024'b0;
        bt[i] = 3'b000;
        i = i + 1;
    end
end

reg [17:1] Tempwa;
integer Tempra;

// Write
// Compare Tag
reg WriteTagCheck;


// Read
// Compare Tag
reg ReadTagCheck;

// Write Hit or Miss
always @(clk) begin
    WriteTagCheck = !(WriteTag[1] ^ bt[wbi][1]) & !(WriteTag[2] ^ bt[wbi][2]) & !(WriteTag[3] ^ bt[wbi][3]);
    ReadTagCheck = !(ReadTag[1] ^ bt[rbi][1]) & !(ReadTag[2] ^ bt[rbi][2]) & !(WriteTag[3] ^ bt[rbi][3]);
    WriteHit = (WriteTagCheck & ValidityBit[wbi]);
    ReadHit = (ReadTagCheck & ValidityBit[rbi]);
    
    if (WriteHit == 1'b1 && mode == 1'b1) begin // Hit  (Cache is empty, you can write in it)
        // $display("Write Hit");
        
        if (wwi == 4'b0000)
            icache[wbi][0*64 + 63: 0*64] = writeval;
        else if (wwi == 4'b0001)
            icache[wbi][1*64 + 63: 1*64] = writeval;
        else if (wwi == 4'b0010)
            icache[wbi][2*64 + 63: 2*64] = writeval;
        else if (wwi == 4'b0011)
            icache[wbi][3*64 + 63: 3*64] = writeval;
        else if (wwi == 4'b0100)
            icache[wbi][4*64 + 63: 4*64] = writeval;
        else if (wwi == 4'b0101)
            icache[wbi][5*64 + 63: 5*64] = writeval;
        else if (wwi == 4'b0110)
            icache[wbi][6*64 + 63: 6*64] = writeval;
        else if (wwi == 4'b0111)
            icache[wbi][7*64 + 63: 7*64] = writeval;
        else if (wwi == 4'b1000)
            icache[wbi][8*64 + 63: 8*64] = writeval;
        else if (wwi == 4'b1001)
            icache[wbi][9*64 + 63: 9*64] = writeval;
        else if (wwi == 4'b1010)
            icache[wbi][10*64 + 63: 10*64] = writeval;
        else if (wwi == 4'b1011)
            icache[wbi][11*64 + 63: 11*64] = writeval;
        else if (wwi == 4'b1100)
            icache[wbi][12*64 + 63: 12*64] = writeval;
        else if (wwi == 4'b1101)
            icache[wbi][13*64 + 63: 13*64] = writeval;
        else if (wwi == 4'b1110)
            icache[wbi][14*64 + 63: 14*64] = writeval;
        else if (wwi == 4'b1111)
            icache[wbi][15*64 + 63: 15*64] = writeval;
        // Set Dirty Bit and Validity Bit
        DirtyBit[wbi] = 1'b1;
        ValidityBit[wbi] = 1'b1;
    end
    else if (WriteHit == 1'b0 && mode == 1'b1) begin // Miss    (Data is present, put it in mm, then write in cache)
        // $display("Write Miss");

        Tempwa[14:5] = wbi;
        Tempwa[4:1] = 4'b0000;

        // Write Back to the main memory
        if (DirtyBit[wbi] == 1'b1) begin
            // $display("Write Miss Write Back");
            
            Tempwa[17:15] = bt[wbi];


            mmem[Tempwa + 0][63:0] = icache[wbi][64*0 + 63 : 64*0];
            mmem[Tempwa + 1][63:0] = icache[wbi][64*1 + 63 : 64*1];
            mmem[Tempwa + 2][63:0] = icache[wbi][64*2 + 63 : 64*2];
            mmem[Tempwa + 3][63:0] = icache[wbi][64*3 + 63 : 64*3];
            mmem[Tempwa + 4][63:0] = icache[wbi][64*4 + 63 : 64*4];
            mmem[Tempwa + 5][63:0] = icache[wbi][64*5 + 63 : 64*5];
            mmem[Tempwa + 6][63:0] = icache[wbi][64*6 + 63 : 64*6];
            mmem[Tempwa + 7][63:0] = icache[wbi][64*7 + 63 : 64*7];
            mmem[Tempwa + 8][63:0] = icache[wbi][64*8 + 63 : 64*8];
            mmem[Tempwa + 9][63:0] = icache[wbi][64*9 + 63 : 64*9];
            mmem[Tempwa + 10][63:0] = icache[wbi][64*10 + 63 : 64*10];
            mmem[Tempwa + 11][63:0] = icache[wbi][64*11 + 63 : 64*11];
            mmem[Tempwa + 12][63:0] = icache[wbi][64*12 + 63 : 64*12];
            mmem[Tempwa + 13][63:0] = icache[wbi][64*13 + 63 : 64*13];
            mmem[Tempwa + 14][63:0] = icache[wbi][64*14 + 63 : 64*14];
            mmem[Tempwa + 15][63:0] = icache[wbi][64*15 + 63 : 64*15];

            // Clear Dirty Bit
            DirtyBit[wbi] = 1'b0;
        end
        
        Tempwa[17:15] = WriteTag;

    
        icache[wbi][64*0 + 63 : 64*0] = mmem[Tempwa + 0][63:0];
        icache[wbi][64*1 + 63 : 64*1] = mmem[Tempwa + 1][63:0];
        icache[wbi][64*2 + 63 : 64*2] = mmem[Tempwa + 2][63:0];
        icache[wbi][64*3 + 63 : 64*3] = mmem[Tempwa + 3][63:0];
        icache[wbi][64*4 + 63 : 64*4] = mmem[Tempwa + 4][63:0];
        icache[wbi][64*5 + 63 : 64*5] = mmem[Tempwa + 5][63:0];
        icache[wbi][64*6 + 63 : 64*6] = mmem[Tempwa + 6][63:0];
        icache[wbi][64*7 + 63 : 64*7] = mmem[Tempwa + 7][63:0];
        icache[wbi][64*8 + 63 : 64*8] = mmem[Tempwa + 8][63:0];
        icache[wbi][64*9 + 63 : 64*9] = mmem[Tempwa + 9][63:0];
        icache[wbi][64*10 + 63 : 64*10] = mmem[Tempwa + 10][63:0];
        icache[wbi][64*11 + 63 : 64*11] = mmem[Tempwa + 11][63:0];
        icache[wbi][64*12 + 63 : 64*12] = mmem[Tempwa + 12][63:0];
        icache[wbi][64*13 + 63 : 64*13] = mmem[Tempwa + 13][63:0];
        icache[wbi][64*14 + 63 : 64*14] = mmem[Tempwa + 14][63:0];
        icache[wbi][64*15 + 63 : 64*15] = mmem[Tempwa + 15][63:0];

        if (wwi == 4'b0000)
            icache[wbi][0*64 + 63: 0*64] = writeval;
        else if (wwi == 4'b0001)
            icache[wbi][1*64 + 63: 1*64] = writeval;
        else if (wwi == 4'b0010)
            icache[wbi][2*64 + 63: 2*64] = writeval;
        else if (wwi == 4'b0011)
            icache[wbi][3*64 + 63: 3*64] = writeval;
        else if (wwi == 4'b0100)
            icache[wbi][4*64 + 63: 4*64] = writeval;
        else if (wwi == 4'b0101)
            icache[wbi][5*64 + 63: 5*64] = writeval;
        else if (wwi == 4'b0110)
            icache[wbi][6*64 + 63: 6*64] = writeval;
        else if (wwi == 4'b0111)
            icache[wbi][7*64 + 63: 7*64] = writeval;
        else if (wwi == 4'b1000)
            icache[wbi][8*64 + 63: 8*64] = writeval;
        else if (wwi == 4'b1001)
            icache[wbi][9*64 + 63: 9*64] = writeval;
        else if (wwi == 4'b1010)
            icache[wbi][10*64 + 63: 10*64] = writeval;
        else if (wwi == 4'b1011)
            icache[wbi][11*64 + 63: 11*64] = writeval;
        else if (wwi == 4'b1100)
            icache[wbi][12*64 + 63: 12*64] = writeval;
        else if (wwi == 4'b1101)
            icache[wbi][13*64 + 63: 13*64] = writeval;
        else if (wwi == 4'b1110)
            icache[wbi][14*64 + 63: 14*64] = writeval;
        else if (wwi == 4'b1111)
            icache[wbi][15*64 + 63: 15*64] = writeval;


        // Set Dirty Bit and Validity Bit
        DirtyBit[wbi] = 1'b1;
        ValidityBit[wbi] = 1'b1;
        bt[wbi] = WriteTag;
    end



    // Read
    if (ReadHit == 1'b1 && mode == 1'b0) begin // Hit    //page is in cache
        // $display("Read Hit");
        // Read
        if (rwi == 4'b0000)
            readval = icache[rbi][0*64 + 63: 0*64];
        else if (rwi == 4'b0001)
            readval = icache[rbi][1*64 + 63: 1*64];
        else if (rwi == 4'b0010)
            readval = icache[rbi][2*64 + 63: 2*64];
        else if (rwi == 4'b0011)
            readval = icache[rbi][3*64 + 63: 3*64];
        else if (rwi == 4'b0100)
            readval = icache[rbi][4*64 + 63: 4*64];
        else if (rwi == 4'b0101)
            readval = icache[rbi][5*64 + 63: 5*64];
        else if (rwi == 4'b0110)
            readval = icache[rbi][6*64 + 63: 6*64];
        else if (rwi == 4'b0111)
            readval = icache[rbi][7*64 + 63: 7*64];
        else if (rwi == 4'b1000)
            readval = icache[rbi][8*64 + 15: 8*64];
        else if (rwi == 4'b1001)
            readval = icache[rbi][9*64 + 63: 9*64];
        else if (rwi == 4'b1010)
            readval = icache[rbi][10*64 + 63: 10*64];
        else if (rwi == 4'b1011)
            readval = icache[rbi][11*64 + 63: 11*64];
        else if (rwi == 4'b1100)
            readval = icache[rbi][12*64 + 63: 12*64];
        else if (rwi == 4'b1101)
            readval = icache[rbi][13*64 + 63: 13*64];
        else if (rwi == 4'b1110)
            readval = icache[rbi][14*64 + 63: 14*64];
        else if (rwi == 4'b1111)
            readval = icache[rbi][15*64 + 63: 15*64];
    end
    else if (ReadHit == 1'b0 && mode == 1'b0) begin // Miss   //page not in cache, get it from mm
        // $display("Read Miss");
        Tempra = 0;
        Tempra[13:4] = rbi;
        Tempra[3:0] = 4'b000;

        // Write Back
        if (DirtyBit[rbi] == 1'b1) begin
            // $display("Read Miss Write Back");
            Tempra[16:14] = bt[rbi];
    

            mmem[Tempra + 0][63:0] = icache[rbi][64*0 + 63 : 64*0];
            mmem[Tempra + 1][63:0] = icache[rbi][64*1 + 63 : 64*1];
            mmem[Tempra + 2][63:0] = icache[rbi][64*2 + 63 : 64*2];
            mmem[Tempra + 3][63:0] = icache[rbi][64*3 + 63 : 64*3];
            mmem[Tempra + 4][63:0] = icache[rbi][64*4 + 63 : 64*4];
            mmem[Tempra + 5][63:0] = icache[rbi][64*5 + 63 : 64*5];
            mmem[Tempra + 6][63:0] = icache[rbi][64*6 + 63 : 64*6];
            mmem[Tempra + 7][63:0] = icache[rbi][64*7 + 63 : 64*7];
            mmem[Tempra + 8][63:0] = icache[rbi][64*8 + 63 : 64*8];
            mmem[Tempra + 9][63:0] = icache[rbi][64*9 + 63 : 64*9];
            mmem[Tempra + 10][63:0] = icache[rbi][64*10 + 63 : 64*10];
            mmem[Tempra + 11][63:0] = icache[rbi][64*11 + 63 : 64*11];
            mmem[Tempra + 12][63:0] = icache[rbi][64*12 + 63 : 64*12];
            mmem[Tempra + 13][63:0] = icache[rbi][64*13 + 63 : 64*13];
            mmem[Tempra + 14][63:0] = icache[rbi][64*14 + 63 : 64*14];
            mmem[Tempra + 15][63:0] = icache[rbi][64*15 + 63 : 64*15];
        end
        Tempra[16:14] = ReadTag;
        
        icache[rbi][64*0 + 63 : 64*0] = mmem[Tempra + 0][63:0];
        icache[rbi][64*1 + 63 : 64*1] = mmem[Tempra + 1][63:0];
        icache[rbi][64*2 + 63 : 64*2] = mmem[Tempra + 2][63:0];
        icache[rbi][64*3 + 63 : 64*3] = mmem[Tempra + 3][63:0];
        icache[rbi][64*4 + 63 : 64*4] = mmem[Tempra + 4][63:0];
        icache[rbi][64*5 + 63 : 64*5] = mmem[Tempra + 5][63:0];
        icache[rbi][64*6 + 63 : 64*6] = mmem[Tempra + 6][63:0];
        icache[rbi][64*7 + 63 : 64*7] = mmem[Tempra + 7][63:0];
        icache[rbi][64*8 + 63 : 64*8] = mmem[Tempra + 8][63:0];
        icache[rbi][64*9 + 63 : 64*9] = mmem[Tempra + 9][63:0];
        icache[rbi][64*10 + 63 : 64*10] = mmem[Tempra + 10][63:0];
        icache[rbi][64*11 + 63 : 64*11] = mmem[Tempra + 11][63:0];
        icache[rbi][64*12 + 63 : 64*12] = mmem[Tempra + 12][63:0];
        icache[rbi][64*13 + 63 : 64*13] = mmem[Tempra + 13][63:0];
        icache[rbi][64*14 + 63 : 64*14] = mmem[Tempra + 14][63:0];
        icache[rbi][64*15 + 63 : 64*15] = mmem[Tempra + 15][63:0];

        bt[rbi] = ReadTag;
        ValidityBit[rbi] = 1'b1;
        DirtyBit[rbi] = 1'b0;


        // Then Read
        if (rwi == 4'b0000)
            readval = icache[rbi][0*64 + 63: 0*64];
        else if (rwi == 4'b0001)
            readval = icache[rbi][1*64 + 63: 1*64];
        else if (rwi == 4'b0010)
            readval = icache[rbi][2*64 + 63: 2*64];
        else if (rwi == 4'b0011)
            readval = icache[rbi][3*64 + 63: 3*64];
        else if (rwi == 4'b0100)
            readval = icache[rbi][4*64 + 63: 4*64];
        else if (rwi == 4'b0101)
            readval = icache[rbi][5*64 + 63: 5*64];
        else if (rwi == 4'b0110)
            readval = icache[rbi][6*64 + 63: 6*64];
        else if (rwi == 4'b0111)
            readval = icache[rbi][7*64 + 63: 7*64];
        else if (rwi == 4'b1000)
            readval = icache[rbi][8*64 + 15: 8*64];
        else if (rwi == 4'b1001)
            readval = icache[rbi][9*64 + 63: 9*64];
        else if (rwi == 4'b1010)
            readval = icache[rbi][10*64 + 63: 10*64];
        else if (rwi == 4'b1011)
            readval = icache[rbi][11*64 + 63: 11*64];
        else if (rwi == 4'b1100)
            readval = icache[rbi][12*64 + 63: 12*64];
        else if (rwi == 4'b1101)
            readval = icache[rbi][13*64 + 63: 13*64];
        else if (rwi == 4'b1110)
            readval = icache[rbi][14*64 + 63: 14*64];
        else if (rwi == 4'b1111)
            readval = icache[rbi][15*64 + 63: 15*64];
    end
end
endmodule