`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 02/15/2020 04:42:06 PM
// Design Name: 
// Module Name: Vending
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


module Vending(input clk, reset, ReturnChange,
               input [7:0] InCoin, 
               input [2:0] SodaSel,
               output ExactChange, IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickle, 
               output reg [5:0] IsSodaOut = {6'b0}, 
               output [7:0] SodaCost, OutCoin
    );
    
    reg [2:0] SodasAvail [5:0];
    reg [2:0] state = 0;
    reg [2:0] nextstate = 0;
    reg [7:0] coin_old = 0;
    reg [7:0] coin_old_old = 0;
    reg [7:0] payment = 0;
    reg [7:0] prev_coin = 0;
    reg Dollar, HalfDollar, Quarter, Dime, Nickel, CancelTrans;
    
    //localparam IDLE = 0;
    localparam CHECK_COIN = 0;
    localparam VEND_DRINK = 1;
    localparam RETURN_COIN = 2;
    
    initial begin                       // Set initial amounts of sodas available for purchase
        SodasAvail[0] = 3'd3;
        SodasAvail[1] = 3'd1;
        SodasAvail[2] = 3'd4;
        SodasAvail[3] = 3'd2;
        SodasAvail[4] = 3'd1;
        SodasAvail[5] = 3'd1;
        {Dollar, HalfDollar, Quarter, Dime, Nickel, CancelTrans} = 0;
     end   
    
    Payment a2( clk, 
                reset, 
                payment,
                Nickel, Dime, Quarter, HalfDollar, Dollar,
                SodaCost, OutCoin, 
                IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickle, 
                ExactChange,
                ReturnChange,
                CancelTrans);
                
     always @(posedge clk)
     begin
		if(reset)
			begin
				state <= CHECK_COIN;			// start the state machine at CHECK_COIN
			end                                 // <= is reset of real flop with real clock edge
		else
			state <= nextstate;		
     end
     
     always @(posedge clk)
     begin
        case(state)
            CHECK_COIN:
            begin
            
                Nickel <= 0;            // Zero out the 1-bit register after incrementing cash amount in the Payment module
                Dime <= 0;
                Quarter <= 0;
                HalfDollar <= 0;
                Dollar <= 0;
            
                coin_old <= InCoin;
                coin_old_old <= coin_old;   // Deal with metastability issue by stacking d-flip-flops to ensure a stable value
                
                if(coin_old_old != 0 && prev_coin == 0) // check whether the current value of coin versus the previous value to determine if a rising edge had occurred
                case(coin_old_old) // check for specific value of input, i.e. proper currency for application, accumulate the payment and turn on the increment coin flag for the payment module
                    8'd5:
                    begin
                         payment <= payment + coin_old_old;
                         Nickel <= 1;
                    end
                    8'd10:
                    begin
                        payment <= payment + coin_old_old; 
                        Dime <= 1;
                    end
                    8'd25:
                    begin
                        payment <= payment + coin_old_old;
                        Quarter <= 1;
                    end
                    8'd50:
                    begin
                        payment <= payment + coin_old_old;
                        HalfDollar <= 1;
                    end
                    8'd100:
                    begin
                        payment <= payment + coin_old_old;
                        Dollar <= 1;
                    end
                    default: payment <= payment;   // If not proper currency, do not accumulate anything
                endcase

                if (payment >= 8'd150)
                    nextstate <= VEND_DRINK; // If enough payment has occurred, go to the drink vending case
                else if (ReturnChange)
                   nextstate <= RETURN_COIN; // If user wants to stop transaction, then skip the drink vending case
                else
                   nextstate <= CHECK_COIN; // If not enough money to proceed, repeat this case
                   
            end
            VEND_DRINK:
            begin 
                case(SodaSel) // Depending on user selection, check if soda is availabe and dispense if so
                    3'b000 : 
                    begin
                        if (SodasAvail[0] > 0)
                            begin
                                SodasAvail[0] = SodasAvail[0] - 1; // Decrement the amount of sodas
                                nextstate <= CHECK_COIN; // Pay out user if change is needed and go back to checking for coins
                                payment <= 0; // Zero out accumulator as to not affect later purchases
                            end
                        else // Otherwise, display soda is out and go to return change to customer 
                            begin
                               IsSodaOut[0] <= 1;
                               nextstate = RETURN_COIN;
                            end
                    end 
                    3'b001 :
                    begin
                        if (SodasAvail[1] > 0)
                            begin
                                SodasAvail[1] = SodasAvail[1] - 1;
                                nextstate <= CHECK_COIN;
                                payment <= 0;
                            end
                        else
                            begin
                                IsSodaOut[1] <= 1;
                                nextstate = RETURN_COIN;
                            end
                    end
                    3'b010 :
                    begin
                        if (SodasAvail[2] > 0)
                            begin
                                SodasAvail[2] = SodasAvail[2] - 1;
                                nextstate <= CHECK_COIN;
                                payment <= 0;
                            end
                        else
                            begin
                               IsSodaOut[2] <= 1;
                               nextstate = RETURN_COIN;
                            end
                    end
                    3'b011 :
                    begin
                        if (SodasAvail[3] > 0)
                            begin
                                SodasAvail[3] = SodasAvail[3] - 1;
                                nextstate <= CHECK_COIN;
                                payment <= 0;
                            end
                        else
                            begin
                               IsSodaOut[3] <= 1;
                               nextstate = RETURN_COIN;
                            end
                    end
                    3'b100 :
                    begin
                        if (SodasAvail[4] > 0)
                            begin
                                SodasAvail[4] = SodasAvail[4] - 1;
                                nextstate <= CHECK_COIN;
                                payment <= 0;
                            end
                        else
                            begin
                               IsSodaOut[4] <= 1;
                               nextstate = RETURN_COIN;
                            end
                    end
                    3'b101 :
                    begin
                        if (SodasAvail[5] > 0)
                            begin
                                SodasAvail[5] = SodasAvail[5] - 1;
                                nextstate <= CHECK_COIN;
                                payment <= 0;
                            end
                        else
                            begin
                               IsSodaOut[5] <= 1;
                               nextstate = RETURN_COIN;
                            end
                    end
                    default :
                        begin  
                            nextstate = RETURN_COIN;
                        end                 
                endcase
            end
            RETURN_COIN:
            begin
                //if(!ReturnChange)
                    //CancelTrans <=1;
                    
                nextstate <= CHECK_COIN;
                payment <= 0; // If user canceled the transaction, then zero the accumulator
            end  
    endcase
    
    prev_coin <= coin_old_old; // Used for checking the values to determine if a rising edge had occurred between the two registers
    end
    
endmodule
