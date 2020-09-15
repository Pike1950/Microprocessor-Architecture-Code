`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bradley Ward
// 
// Create Date: 02/15/2020 04:51:07 PM
// Design Name: 
// Module Name: Payment
// Project Name: Vending_Machine
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


module Payment(input clk, reset, 
               input [7:0] payment, 
               input NickelAdd, DimeAdd, QuarterAdd, HalfDollarAdd, DollarAdd,
               output reg [7:0] SodaCost, OutCoin, 
               output reg IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickel, ExactChange,
               input ReturnChange, CancelTrans
    );
    
    reg [7:0] Nickels, Dollars, Quarters, HalfDollars, Dimes;
    reg [2:0] state = 0;
    reg [2:0] nextstate = 0;
    reg [7:0] cost = 8'd150;
    reg [7:0] temp = 0;
    reg [7:0] payment_old;
    
    localparam IDLE = 0;
    localparam MakeChange = 1;
    localparam Cancel_Transaction = 2;
    
    
    initial begin           // Set the amounts for the coins available in the machine
        Dollars = 7'd0;     // Just used for testing purposes, the machine only knows whether one coin exists at a time
        HalfDollars = 7'd0;
        Quarters = 7'd0;
        Dimes = 7'd0;
        Nickels = 7'd15;
        {SodaCost, OutCoin, IsDollar, IsQuarter, IsHalfDollar, IsDime, IsNickel, ExactChange} = 0;
        
     end 
     
     always @(posedge clk)
     begin
		if(reset)
			begin
				state <= IDLE;						// <= is reset of real flop with real clock edge
			end
		else
			state <= nextstate;		
     end
     
     always @(posedge clk)
     begin
        case(state)
            IDLE: // Check to see which coins are being added and increment by 1 as they are added
            begin
                OutCoin <= 0;
                
                if (DollarAdd)
                    Dollars <= Dollars + 1;
                    
                if (HalfDollarAdd)
                    HalfDollars <= HalfDollars + 1;
                    
                if (QuarterAdd)
                    Quarters <= Quarters + 1;
                    
                if (DimeAdd)
                    Dimes <= Dimes + 1;  
                    
                if (NickelAdd)
                    Nickels <= Nickels + 1;  
                
                if (Dollars < 1)    // Check to see if atleast one of the coin is available
                    IsDollar <= 0;
                else
                    IsDollar <= 1;
                    
                if (HalfDollars < 1)
                    IsHalfDollar <= 0;
                else
                    IsHalfDollar <= 1;
                    
                if (Quarters < 1)
                    IsQuarter <= 0;
                else
                    IsQuarter <= 1;
                
                if (Dimes < 1)
                    IsDime <= 0;
                else
                    IsDime <= 1;
                
                if (Nickels < 1)
                    IsNickel <= 0;
                else
                begin
                    IsNickel <= 1;
                    if (Nickels < 19 && IsDollar == 0 &&  IsHalfDollar == 0 &&  IsQuarter == 0 &&  IsDime == 0) // Check to see if there is enough change to guarantee a transaction
                        ExactChange <= 1;
                    else
                        ExactChange <= 0;
                end
                
                  
                if (payment_old != payment && payment >= 8'd150 && !CancelTrans) // Check to see if a rising edge occurred between the two payment registers and if enough coins were inputted
                begin
                    if (!ReturnChange) // if user wants to proceed with transaction
                        temp <= payment - cost;
                    else
                        temp <= payment; // otherwise, stop the transaction and return money
                            
                    nextstate <= MakeChange;         
                end
                
                else if (CancelTrans || ReturnChange) // stop transaction and return money to customer
                begin
                    nextstate <= MakeChange;
                    temp <= payment;
                end
                

            end
        MakeChange:
        begin
            
            SodaCost <= cost;
            
            if (temp != 0 && ExactChange == 0) // check to see if all money has been paid back to customer during guaranteed transaction
                begin
                    if (temp >= 8'd100 && IsDollar)
                        begin
                            OutCoin <= OutCoin + 8'd100;
                            temp <= temp - 8'd100;
                            Dollars <= Dollars - 1; // decrease the coin amount by 1 as it is paid back to customer
                        end
                    else if (temp >= 8'd50 && IsHalfDollar)
                        begin
                            OutCoin <= OutCoin + 8'd50;
                            temp <= temp - 8'd50;
                            HalfDollars <= HalfDollars - 1;
                        end
                    else if (temp >= 8'd25 && IsQuarter)
                        begin
                            OutCoin <= OutCoin + 8'd25;
                            temp <= temp - 8'd25;
                            Quarters <= Quarters - 1;
                        end
                    else if (temp >= 8'd10 && IsDime)
                        begin
                            OutCoin <= OutCoin + 8'd10;
                            temp <= temp - 8'd10;
                            Dimes <= Dimes - 1;
                        end
                    else
                        begin
                            OutCoin <= OutCoin + 8'd5;
                            temp <= temp - 8'd5;
                            Nickels <= Nickels - 1;
                        end
                end
            else if (ExactChange == 1) // if not enough to guarantee transaction, pay back as much as possible to customer
                begin
                    if (Nickels > 0)
                        begin
                            OutCoin <= OutCoin + 8'd5;
                            Nickels <= Nickels - 1;
                        end
                end
                
            if (Nickels == 0 || temp == 0) // If change has been made or all change has been dispensed from machine, go back to waiting for coins
                nextstate <= IDLE;
            else
                nextstate <= MakeChange; // otherwise keep going
        end
        
        endcase
        
        payment_old <= payment; // Used for checking the values to determine if a rising edge had occurred between the two registers
     end
    
endmodule
