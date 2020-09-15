`timescale 1ns / 1ps


module MUXC_SECT(input [1:0] BS,
                input PS, Z,
                input [31:0] PC_1, BrA, RAA,
                output [31:0] PC);
                    
wire AND_GATE, OR_GATE, XOR_GATE;

// Combinational circuits that drive select for MUX C
assign XOR_GATE = PS^Z;
assign OR_GATE = (BS[1])|XOR_GATE;
assign AND_GATE = (BS[0])&OR_GATE;

wire [1:0] MC;

assign MC[1] = BS[1]; // BS1 is high bit for MUX C
assign MC[0] = AND_GATE;

MUX_C M0 (.BrA(BrA), .PC_1(PC_1), .RAA(RAA), // Branch Address (input/input) / Program counter + 1 (input/input) / Register A address (input/input)
          .MC(MC), .PC(PC)); // MUX C Sel (input/wire) / Program counter (output/output reg)
                    
endmodule
