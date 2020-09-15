`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2020 01:03:47 PM
// Design Name: 
// Module Name: Vending_Machine_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Vending_Machine_TB;
    
    reg clk, reset, ReturnChange;
    reg [7:0] InCoin;
    reg [2:0] SodaSel;
    wire [5:0] IsSodaOut;
    wire ExactChange, IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickel;
    wire [7:0] OutCoin, SodaCost;
    
    integer i;
    
    Vending_Machine uut (
		.clk(clk), 
		.reset(reset),
		.ReturnChange(ReturnChange),
		.InCoin(InCoin),
		.SodaSel(SodaSel),
		.IsSodaOut(IsSodaOut),
		.ExactChange(ExactChange), .IsDollar(IsDollar), .IsQuarter(IsQuarter), .IsHalfDollar(IsHalfDollar),
		.IsDime(IsDime), .IsNickel(IsNickel),
		.OutCoin(OutCoin), .SodaCost(SodaCost)
	);
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		InCoin = 0;
		ReturnChange = 0;

		// Wait 100 ns for global reset to finish
		#105;
		
		SodaSel = 3'b001;
		
		#100
		InCoin = 50;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 50;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
		SodaSel = 3'b001;
		
		#100
		InCoin = 50;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 50;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 55;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 43;
		
		#100
		InCoin = 0;
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
		#100
		SodaSel = 3'b000;
		
		#94
		InCoin = 25;
		
		#58
		InCoin = 0;
		
		#110
		InCoin = 10;
		
		#130
		InCoin = 0;
		
		#52
		InCoin = 10;
		
		#62
		InCoin = 0;
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
		#100
		ReturnChange = 1;
		
		#100
		ReturnChange = 0;
		
		SodaSel = 3'b010;
		
		for(i = 0; i < 29; i = i + 1)
		begin
		      #100
		      InCoin = 5;
		
		      #100
		      InCoin = 0;
		end
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
		SodaSel = 3'b010;
		
		for(i = 0; i < 29; i = i + 1)
		begin
		      #100
		      InCoin = 5;
		
		      #100
		      InCoin = 0;
		end
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
		SodaSel = 3'b010;
		
		for(i = 0; i < 29; i = i + 1)
		begin
		      #100
		      InCoin = 5;
		
		      #100
		      InCoin = 0;
		end
		
		#100
		InCoin = 100;
		
		#100
		InCoin = 0;
		
	end
	
	always
		begin
			#5 clk = ~clk;			// 10 tick clock
      end
	
	
endmodule
