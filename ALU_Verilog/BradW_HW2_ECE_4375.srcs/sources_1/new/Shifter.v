`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 01/31/2020 01:28:39 PM
// Design Name: 
// Module Name: Shifter
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


module Shifter(
    input [1:0] H_SEL,
    input [15:0] B,
    output [15:0] H
 );
 
 localparam shiftL = 2'b01;
 localparam shiftR = 2'b10;
 
assign H = (!H_SEL) ? B :
            (H_SEL == shiftL) ? B << 1 :
            (H_SEL == shiftR) ? B >> 1 : 2'bx;
            
endmodule