`timescale 1ns / 1ps

module DOF_SECT(input [31:0] IR, PC_1, A_DATA, B_DATA,
                output [31:0] Bus_A, Bus_B,
                output RW, PS, MW,
                output [4:0] DA, FS, AAnet, BAnet,
                output reg [4:0] SH,
                output [1:0] MD, BS
                );
                
wire MA, MB, CS;
wire [31:0] CONST_DATA;
reg [14:0] IM = 0;

always@(*) begin
    IM = IR[14:0];
    SH = IR[4:0];
end

Constant_unit CU0(.IM(IM), .CS(CS), // Instruction memory (input/reg) / Constant select (input/wire)
                  .CONST_DATA(CONST_DATA)); // Constant data (input/wire)
                  
MUX_A MA0(.MA(MA), .PC_1(PC_1), // MUX A (input/wire) / Program counter + 1 (input/input)
          .A_DATA(A_DATA), .Bus_A(Bus_A)); // A data (input/input) / Bus A (output/output)
          
MUX_B MB0(.MB(MB), .CONST_DATA(CONST_DATA), // MUX B (input/wire) / Constant data (input/wire)
          .B_DATA(B_DATA), .Bus_B(Bus_B)); // B data (input/input) / Bus B (output/output)
          
Instruction_Dec ID0(.IR(IR), .RW(RW), .DA(DA), .MD(MD), // Program memory (input/input) / Read/write (output reg/output) / Destination Addr (output reg/output) / MUX D (output reg/output)
                .BS(BS), .PS(PS), .MW(MW), .FS(FS), // Bit select (output reg/output) / Polarity select (output reg/output) / Mem write (output reg/output) / Function sel (output reg/output)
                .MA(MA), .MB(MB), .AA(AAnet), .BA(BAnet), // MUX A (output reg/wire) / MUX B (output reg/wire) / A Addr (output reg/output) / B Addr (output reg/output)
                .CS(CS) // Constant select (output reg/wire)
                );
                
endmodule