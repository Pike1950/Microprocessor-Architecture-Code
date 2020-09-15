`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 01/31/2020 01:28:39 PM
// Design Name: 
// Module Name: Function_Unit_TB
// Project Name: HW2 Tiny Processor
// Target Devices: 
// Tool Versions: 
// Description: Simulation of a Function Unit of a simple processor which includes the logic for an Arithmetic/Logic
//              Unit and a Shifter module with a multiplexer to togger either ALU or shifter outputs. ALU contains 8
//              arithmetic operations and 4 logical operations controlled by select bits G, CIN, and MODE_SEL. Arithmetic
//              operations include add, subtract, increment, decrement, transfer, and all of these with a borrow. Logic
//              operations include AND, OR, XOR, and NOT. Shifter has three operations with passthrough, shift left, and
//              shift right and the shifts are 1 bit an operation. The test bench runs a 16 shift operations - 4 ops pass,
//              4 ops shift left, and 8 ops shift right, 8 arithmetic operations, and 4 logic operations. The 12 ALU operations test
//              cases to set overflow, negative, zero, and carry flags based on large 16 bit register values to trigger these
//              flags properly.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Made with help from Gerald Barnett, Cody Cartier-Solomon, and Rice Rodriguez.
// 
//////////////////////////////////////////////////////////////////////////////////


module Function_Unit_TB;
    
    reg [15:0] A, B;
    reg CIN, MODE_SEL;
    reg [1:0] G_SEL, MF_SEL, H_SEL;
    wire V, C, N, Z;
    wire [15:0] F;
    integer i;
    
    Function_Unit uut(
    .A(A),
    .B(B),
    .CIN(CIN),
    .MODE_SEL(MODE_SEL),
    .H_SEL(H_SEL),
    .G_SEL(G_SEL),
    .MF_SEL(MF_SEL),
    .V(V),
    .C(C),
    .N(N),
    .Z(Z),
    .F(F)
    );
    
    initial begin
    A = 0;
    B = 16'b1111000000001111;
    CIN = 0;
    MF_SEL = 0;
    MODE_SEL = 0;
    H_SEL = 0;
    G_SEL = 0;
    
    for (i=0;i<4;i=i+1) // Pass B register to F 4 times
        begin
            H_SEL = 0;
            #50;
            B = F;
        end
        
    for (i=0;i<4;i=i+1) // Shift left 4 times
        begin
            H_SEL = 1;
            #50;
            B = F;
        end
        
    for (i=0;i<8;i=i+1) // Shift right 8 times
        begin
            H_SEL = 2;
            #50;
            B = F;
        end
    
    MF_SEL = 1;
    
    for (i=0;i<16;i=i+1) // 4 part test to check operation of flags during arithmetic operations
        begin
            {MODE_SEL,G_SEL,CIN} = i;
            A = 30000;
            B = 30000;
            #50;
            A = 30000;
            B = -30000;
            #50;
            A = -30000;
            B = 30000;
            #50;
            A = -30000;
            B = -30000;
            #50;
        end
    end
    
    
    
endmodule
