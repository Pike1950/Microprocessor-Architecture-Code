`timescale 1ns / 1ps


module IF_SECT( input [31:0] PC,
                output [31:0] PC_1, IR
                );
                
assign PC_1 = PC + 1;

Instruction_Mem IM0(.PC(PC_1), .IR(IR)); // Program counter (output/input) / Program memory (output reg/output)

endmodule
