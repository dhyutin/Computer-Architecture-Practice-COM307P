// N Sree Dhyuti
// CED19I027
// VLSI LAB 7 : ALU (Arithmetic Logic Unit)

//Set the measurement and percesion of time
`timescale 1ns/1ps

module logic_unit(a,b,res,sel);
    input [63:0] a,b;
    input [2:0] sel;
    output reg [63:0] res;         

    always @(*)
    begin                             
        case(sel)
           // Bitwise AND
           3'b000 : res = a & b;
           
           //Bitwise XOR
           3'b001 : res = a ^ b;
           
           //Bitwise NAND
           3'b010 : res = ~(a & b);
           
           // OR
           3'b011 : res = a | b;
           
           // NOT
           3'b100 : res = ~a;
           
           //NOR
           3'b101 : res = ~(a | b);
           
           //2's Complement
           3'b110 : res = ~a + 1;
           
           //XNOR
           3'b111 : res = ~(a ^ b);  //xnor
           
           //Invalid select line
           default : res<=64'b0; 
        endcase
    end
endmodule