`timescale 1ns / 1ps

module Adder(
    input [31:0] B, PC_2,
    output reg [31:0] BrA
    );

reg C = 0;

always@(*) begin

    BrA = B + PC_2;

end
    
endmodule
