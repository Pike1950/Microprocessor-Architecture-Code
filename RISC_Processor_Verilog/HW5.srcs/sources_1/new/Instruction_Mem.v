`timescale 1ns / 1ps

module Instruction_Mem( input [31:0] PC,
                        output reg [31:0] IR
                        );
                        
`include "OPCODES.INC";
`include "REGISTERS.INC";
    
reg [6:0] opcode = 0; // values come from Fig.10-13 RISC CPU Instruction Formats
reg [4:0] DA = 0;
reg [4:0] AA = 0;
reg [4:0] BA = 0;
reg [9:0] garbageVal = 0;
reg [14:0] IM = 0;
reg [14:0] TAR_OFF = 0;

reg [31:0] M [0:1024];
integer i;

initial begin

    for(i = 0; i < 1024; i = i + 1) begin
    	M[i] = 0;	// NOP
    end
    
    
    //         7-bit | 5-bit|5-bit| 5-bit + 10-bit |
    //        OPCODE | DEST | SA  | TARGET JUMP    | 15-bit
    //        OPCODE | DEST | SA  | IMMEDIATE      | 15-bit
    //        OPCODE | DEST | SA  | SB  | JUNK     | 5-bit, 10-bit
    M[1]    = {ADI,    R4,     R1,     15'd27};     // R4 (R[DR]) <- R1 (R[SA]) + 27 (se IM)
    M[3]    = {ADI,    R6,     R1,     15'd27};     // R6 (R[DR]) <- R1 (R[SA]) + 27 (se IM)
    M[5]    = {ADD,    R1,     R4,  R6,   10'd0};   // R1 (R[DR]) <- R4 (R[SA]) + R6 (R[SB])
    M[7]    = {SBI,    R4,     R1,     15'd100};    // R4 (R[DR]) <- R1 (R[SA]) - 100 (se IM)
    M[9]    = {SUB,    R6,     R1,  R4,   10'd0};   // R6 (R[DR]) <- R1 (R[SA]) - R4 (R[SB])
    M[11]   = {SLT,    R3,     R6,  R1,   10'd0};   // If R6 (R[SA]) < R1 (R[SB]), then R3 = 1
    M[13]   = {ADI,    R7,     R1,     15'd32767};  // R7 (R[DR]) <- R1 (R[SA]) + 32767 (se IM)
    M[15]   = {AND,    R10,    R4,  R1,   10'd0};   // R10 (R[DR]) <- R4 (R[SA]) AND R1 (R[SB])
    M[17]   = { OR,    R11,    R4,  R1,   10'd0};   // R11 (R[DR]) <- R4 (R[SA]) OR R1 (R[SB])
    M[19]   = {XOR,    R12,    R4,  R1,   10'd0};   // R12 (R[DR]) <- R4 (R[SA]) XOR R1 (R[SB])
    M[21]   = {ANI,    R10,    R4,     15'd27};     // R10 (R[DR]) <- R4 (R[SA]) AND 27 (se IM)
    M[23]   = {ORI,    R11,    R4,     15'd27};     // R11 (R[DR]) <- R4 (R[SA]) OR 27 (se IM)
    M[25]   = {XRI,    R12,    R4,     15'd27};     // R12 (R[DR]) <- R4 (R[SA]) XOR 27 (se IM)
    M[27]   = {NOT,    R3,     R4,     15'd0};      // R3 (R[DR]) <- INVERT(R4 (R[SA]))
    M[29]   = {MOV,    R4,     R3,     15'd0};      // R4 (R[DR]) <- R3 (R[SA])
    M[31]   = {LSL,    R13,    R4,     15'd0};      // R13 (R[DR]) <- lsl R4 (R[SA]) by SH
    M[33]   = {LSR,    R4,    R13,     15'd0};      // R4 (R[DR]) <- lsr R13 (R[SA]) by SH
    M[35]   = {ST,     R0,     R1,  R4,   10'd0};   // R1 (M[R[SA]]) <- R4 (R[SB]); R[DR] and 10 bits is junk
    M[37]   = {LD,     R5,     R1,     15'd0};      // R5 (R[DR]) <- R1 (M[R[SA]])
    M[39]   = {ADI,    R15,    R0,     15'd10};     // R15 (R[DR]) <- R0 (R[SA]) + 10 (se IM)
    M[41]   = {JMP,    R1,     R15,    15'd9};      // PC <- PC + 1 + 9
    M[43]   = {ADI,    R4,     R1,     15'd27};     // SKIP
    M[45]   = {ADI,    R6,     R1,     15'd27};     // SKIP
    M[47]   = {ADD,    R1,     R4,  R6,   10'd0};   // SKIP
    M[49]   = {SBI,    R4,     R1,     15'd100};    // SKIP
    M[51]   = {BNZ,    R0,     R1,     15'd9};      // If R1 (R[SA]) != 0, PC <- PC + 1 + 9
    M[53]   = {ADI,    R4,     R1,     15'd27};     // SKIP
    M[55]   = {ADI,    R6,     R1,     15'd27};     // SKIP
    M[57]   = {ADD,    R1,     R4,  R6,   10'd0};   // SKIP
    M[59]   = {SBI,    R4,     R1,     15'd100};    // SKIP
    M[61]   = {JML,    R1,     R0,     15'd9};      // Set R1 (R[DR]) to PC + 1, PC <- PC + 1 + 9
    M[63]   = {ADI,    R4,     R1,     15'd27};     // SKIP
    M[65]   = {ADI,    R6,     R1,     15'd27};     // SKIP
    M[67]   = {ADD,    R1,     R4,  R6,   10'd0};   // SKIP
    M[69]   = {ADI,    R16,    R0,     15'd81};     // R16 (R[DR]) <- R0 (R[SA]) + 81 (se IM)
    M[71]   = {JMR,    R1,     R16,    15'd0};      // PC <- R16 (R[SA]) 
    M[73]   = {ADI,    R4,     R1,     15'd27};     // SKIP
    M[75]   = {ADI,    R6,     R1,     15'd27};     // SKIP
    M[77]   = {ADD,    R1,     R4,  R6,   10'd0};   // SKIP
    M[79]   = {SBI,    R4,     R1,     15'd100};    // SKIP
    M[81]   = {BZ,     R1,     R0,     ToZero};     // If R0 (R[SA]) = 0, PC <- PC + 1 - 82
    
end

always@(*) begin
    IR = M[PC];
end
    
endmodule
