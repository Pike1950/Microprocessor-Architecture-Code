`timescale 1ns / 1ps

module WB_SECT(input [31:0] F, Data_out,
               input VxorN,
               input [1:0] MD_1,
               input [4:0] DA,
               output [31:0] Bus_D);
               
wire [31:0] status = 0;
            
assign status = {31'd0, VxorN}; // Pad the status with zeroes to fit into register file in WB section

MUX_D MD0(.MD_1(MD_1), .F(F), .Data_out(Data_out), .status(status), // MUX D (input/input) / Function data (input/input) / Data mem output (input/input) / Status (input/wire)
          .Bus_D(Bus_D)); // Bus D (output reg/output)
               
endmodule
