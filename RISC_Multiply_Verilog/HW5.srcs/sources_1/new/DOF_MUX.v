`timescale 1ns / 1ps


module DOF_MUX(
    input SEL,
    input [31:0] DATA_1, DATA_2,
    output [31:0] BUS
    );
    
    assign BUS = (!SEL)? DATA_1 : DATA_2;
    
endmodule
