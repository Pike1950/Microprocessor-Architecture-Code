`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 01/31/2020 01:28:39 PM
// Design Name: 
// Module Name: ALU
// Project Name: HW2 Tiny Processor
// Target Devices: 
// Tool Versions: 
// Description: Simulation of a Function Unit of a simple processor which includes the logic for an Arithmetic/Logic
//              Unit and a Shifter module with a multiplexer to togger either ALU or shifter outputs. ALU contains 8
//              arithmetic operations and 4 logical operations controlled by select bits G, CIN, and MODE_SEL. Arithmetic
//              operations include add, subtract, increment, decrement, transfer, and all of these with a borrow. Logic
//              operations include AND, OR, XOR, and NOT. Shifter has three operations with passthrough, shift left, and
//              shift right and the shifts are 1 bit an operation.The test bench runs a 16 shift operations - 4 ops pass,
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

module ALU(
    input [1:0] G_SEL,
    input MODE_SEL,
    input [15:0] A,
    input [15:0] B,
    input CIN,
    output V, C, N, Z,
    output [15:0] G 
    );
    
    wire Bbar, ADD_V, SUB_V, C_temp;
    wire [3:0] ALU_SEL;
    assign ALU_SEL = {MODE_SEL, G_SEL, CIN}; // Concatenating the ALU select bits
    assign ADD_V = ((!ALU_SEL[2]) & ~A[15] ^ B[15]) & (A[15] ^ G[15]); // Overflow rules for addition
    assign SUB_V = ((ALU_SEL[2] & (A[15] ^ B[15]) & ~(B[15] ^ G[15]))); // Overflow rules for subtraction
    
    localparam TRAN_A_1 = 4'b0000;
    localparam INC_A = 4'b0001;
    localparam ADD = 4'b0010;
    localparam ADD_CARRY = 4'b0011;
    localparam ADD_1S = 4'b0100;
    localparam SUB = 4'b0101;
    localparam DEC_A = 4'b0110;
    localparam TRAN_A_2 = 4'b0111;
    localparam AND = 3'b100;
    localparam OR = 3'b101;
    localparam XOR = 3'b110;
    localparam NOT = 3'b111;
    
    assign {C_temp,G} = (!ALU_SEL) ? A :
        (ALU_SEL == INC_A) ? A + CIN : 
        (ALU_SEL == ADD) ? A + B :
        (ALU_SEL == ADD_CARRY) ? A + B + CIN : 
        (ALU_SEL == ADD_1S) ? A + ~B :
        (ALU_SEL == SUB) ? A - B: 
        (ALU_SEL == DEC_A) ? A - 1 :
        (ALU_SEL == TRAN_A_2) ? A : 
        (ALU_SEL[3:1] == AND) ? A & B :
        (ALU_SEL[3:1] == OR) ? A | B : 
        (ALU_SEL[3:1] == XOR) ? A ^ B :
        (ALU_SEL[3:1] == NOT) ? ~A : 4'bx;
        
        assign C = C_temp ^ CIN;
        assign N = G[15];
        assign V = ADD_V ? 1 :
                    SUB_V ? 1 : 0;
        assign Z = ~| G;
        
endmodule
