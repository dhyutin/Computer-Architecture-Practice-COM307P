// N Sree Dhyuti
// CED19I027
// CA LAB 2 : Double Precision Floating Point Multiplier 

//Set the measurement and precision of time
`timescale 1ns / 1ps

module regfile( I1, si1, O1, so1, O2, so2, RD, WR, rst, EN, clk);
  input  [63:0]  I1;
  input  [3:0]  si1, so1, so2; 
  input  RD, WR, EN, rst, clk;
  
  output reg[63:0]  O1, O2; 
  reg [64:0]  regfile [0:32]; 
  integer i; 
  always @ (*) 
    begin 
      if (EN == 1) 
        begin 
          if (rst == 1) //If at reset 
            begin 
              for (i = 0; i < 32; i = i + 1) 
                begin
                  regfile[i] = 64'b0; 
                end  
                O1 = 64'bx;
                O2 = 64'bx;
            end
          if (rst == 0) //If not at reset
            begin 
              case ({RD,WR}) 
                2'b00:  
                  begin
                  
                  end 
                2'b01:  
                  begin //If Write only 
                    regfile[si1] <= I1; 
                  end 
                2'b10:  
                  begin //If Read only 
                    O1 <= regfile[so1]; 
                    O2 <= regfile[so2]; 
                  end 
                2'b11:  
                  begin //If both active 
                    O1 <= regfile[so1]; 
                    O2 <= regfile[so2]; 
                    regfile[si1] <= I1; 
                  end 
                default: 
                begin //If undefined 
        
                end 
              endcase 
            end 
        end
  end 
endmodule