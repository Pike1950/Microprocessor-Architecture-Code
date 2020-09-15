`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 02/15/2020 03:49:34 PM
// Design Name: 
// Module Name: Vending_Machine
// Project Name: Vending Machine
// Target Devices: 
// Tool Versions: 
// Description: Emulation of a 1 column 6-item vending machine which inputs coins larger than a penny and up to a dollar coin. The price of the sodas are 1.50 a piece
//              and the vending machine has a preset amount of drinks to dispense and change to give back to the customer. The machine will be able to determine whether
//              exact change is needed and will keep track coin amounts via internal registers that are not visible to the user. The methodology for giving change is based
//              on whether a single specific coin is available and the machine will continue to dispense the proper change based on the existence of the coin within. The user
//              will have the option to return change prior to vending and if all sodas are sold out, then the machine will return the user's change.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Vending_Machine(
    input clk, reset, ReturnChange,
    input [7:0] InCoin,
    input [2:0] SodaSel,
    output [5:0] IsSodaOut,
    output ExactChange, IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickel,
    output [7:0] OutCoin, SodaCost
    );
    
    

    
    Vending a1( clk, 
                reset, 
                ReturnChange,
                InCoin,
                SodaSel, 
                ExactChange, IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickel, IsSodaOut, 
                SodaCost, OutCoin);
    
    
endmodule
