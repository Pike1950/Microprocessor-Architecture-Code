`timescale 1ns / 1ps

module EX_SECT(input [31:0] A, B, PC_2,
               input [4:0] SH, FS,
               input clk, rst, MW,
               output [31:0] F, Data_out, BrA, RAA,
               output VxorN, Z, C, N, V);
               
Adder A0(.B(B), .PC_2(PC_2), // B Data (input/input) / Program Counter - 2 (input/input)
         .BrA(BrA)); // Branch Address (output reg/output)
         
ALU A1(.A(A), .B(B), .SH(SH), .FS(FS), // A Data (input/input) / B Data (input/input) / Shifter (input/input) / Function Select (input/input)
       .Z(Z), .F(F), .V(V), .C(C), .N(N)); // Zero (output reg/output) / Function Data (output reg/output) / Overflow (output reg/output) / Carry (output reg/output) / Negative (output reg/output)
       
Data_mem D0(.Address(A), .Data_in(B), // Data address (input/input) / Data input (input/input)
            .clk(clk), .rst(rst), .MW(MW), // Clock (input/input) / Reset (input/input) / Mem write (input/input)
            .Data_out(Data_out)); // Data output (output reg/output)
            
assign VxorN = V^N; // Status bit - Clocked on negedge - Goes to MUX D
assign RAA = A;              
               
endmodule