`timescale 1ns / 1ps

module Register_file(
    input clk, rst, RW_1, // Clock and reset for all clocked registers, per Fig. 10-15
    input [4:0] DA_1, AA, BA, // Destination address / Register A address / Register B address
    input [31:0] D_DATA, // Destination data
    output reg [31:0] A_DATA, B_DATA // Data from Register A address / Register B address
    );
    
reg [31:0] REGISTER [31:0]; // 32 32-bit registers

integer i;

initial begin 
        for(i = 0; i < 32; i = i + 1)
                REGISTER[i] = i; // initialize the registers to a generic value (will be reset later during test benching to zero the registers)
end

always@(*) begin // Set the A/B data based on current A/B address
        A_DATA = REGISTER[AA];
        B_DATA = REGISTER[BA];
end
    
always@(posedge clk) begin
        REGISTER[DA_1] <= ((RW_1) && (DA_1 == 0))? 0 : // don't change R0 from 0
                                (RW_1)? D_DATA[31:0] : REGISTER[DA_1]; // If reading/writing, update register value, otherwise leave alone                     
end            
    
always@(posedge rst) begin // if reset is triggered, zero the registers
        if(rst) begin
                for(i = 0; i < 32; i = i + 1)
                        REGISTER[i] <= 0;
        end
end    
    
endmodule
