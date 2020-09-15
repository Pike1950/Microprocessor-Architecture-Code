`timescale 1ns / 1ps

module RISC_CPU_PIPELINE(input clk,
                         input rst);
                         
reg [31:0] PC = 0;      // Program Counter - PC -> + 1/Instruction Mem
reg [31:0] PC_1 = 0;    // Program Counter + 1 - PC+1 -> PC+2
reg [31:0] PC_2 = 0;    // Program Counter + 2 - PC+2 -> Adder
reg [31:0] IR = 0;	    // Instruction Register - Instruction Mem -> Instruction Decoder/Constant Unit
reg RW = 0;             // Read/Write - Register File (WB)
reg [4:0] DA = 0;       // Destination Add - Register File (WB)
reg [1:0] MD = 0;       // Mux D - MUX D -> D Data (WB)
reg [1:0] BS = 0;       // Affects MUX C
reg PS = 0;             // Polarity Select - Affects
reg MW = 0;             // Memory Write - Data Memory (EX)
reg [4:0] FS = 0;       // Function Select - Modified function unit (EX)
reg [4:0] SH = 0;       // Shifter - Modified function unit (EX)
reg [31:0] A = 0;       // 32 bit A data to Modified function unit/Data memory blocks/RAA
reg [31:0] B = 0;       // 32 bit B data to Modified function unit/Data memory blocks/Adder
reg VxorN = 0;	        // Status bit
reg [31:0] F = 0;       // Result from function unit to MUX D (WB)
reg [31:0] Data_out;    // MUX_D
reg [31:0] D_DATA = 0;  // Destination data
reg RW_1 = 0;           // Read/Write - Register File (WB)
reg [31:0] Bus_A = 0;   // Clocked register for A data - DOF -> EX
reg [31:0] Bus_B = 0;   // Clocked register for B data - DOF -> EX
reg [4:0] DA_1 = 0;     // Destination Add - Register File (WB)
reg [1:0] MD_1 = 0;     // Mux D - MUX D -> D Data (WB)

// beginning of wires
wire [31:0] Bus_Anet, Bus_Bnet, Data_outnet, Fnet, BrAnet, RAAnet, IRnet, BrA, RAA, PC_1net, PC_net, Bus_Dnet;
wire RWnet, PSnet, MWnet, VxorNnet, Znet;
wire [1:0] MDnet, BSnet;
wire [4:0] SHnet, FSnet, AAnet, BAnet, DAnet;
wire [31:0] A_DATA, B_DATA; // Register file outputs - Register File -> MUX A/MUX B (DOF)


Register_file RF0(.clk(clk), .RW_1(RW_1), .rst(rst), // Clock (input/input) / Read/write (input/reg) / Reset (input/input)
					.DA_1(DA_1), .AA(AAnet), .BA(BAnet), // Destination Address (input/reg) / Source A (input/wire) / Source B (input/wire)
					.D_DATA(Bus_Dnet), // Destination Data (input/wire)
					.A_DATA(A_DATA), .B_DATA(B_DATA) // Source A Data (Output reg/wire) / Source B Data (Output reg/wire)
					);

MUXC_SECT T0(
			.BS(BS), .PS(PS), // Bit select (input/reg) / Polarity select (input/reg) 
			.Z(Znet), .PC_1(PC_1net), // Zero (input/wire) / Program Counter + 1 (input/wire)
			.BrA(BrAnet), .RAA(RAAnet), // Branch Address (input/wire) / Source A Address (input/wire)
			.PC(PC_net) // Program Counter (output/wire)
			);

IF_SECT IF0(.PC(PC), // Program counter (input/reg)
			.PC_1(PC_1net), // Program counter + 1 (output/wire)
			.IR(IRnet)); // Program memory (output/wire)
						

DOF_SECT DOF0(.IR(IR), .PC_1(PC_1), // Program memory (input/reg) / Program counter + 1 (input/reg)
              .A_DATA(A_DATA), .B_DATA(B_DATA), // Source A Data (input/wire) / Source B Data (input/wire)
			  .Bus_A(Bus_Anet), .Bus_B(Bus_Bnet), // Bus A (output/wire) / Bus B (output/wire)
			  .RW(RWnet), .PS(PSnet), .MW(MWnet), // Read/write (output/wire) / Polarity select (output/wire) / Mem write (output/wire)
			  .DA(DAnet), .FS(FSnet), .SH(SHnet), // Dest Address (output/wire) / Function Sel (output/wire) / Shifter (output/wire)
			  .MD(MDnet), .BS(BSnet), // MUX D (output/wire) / Bit Sel (output/wire)
			  .AAnet(AAnet), .BAnet(BAnet)); // A Address (output/wire) / B Address (output/wire)
			  
EX_SECT E0(
			.A(Bus_A), .B(Bus_B), .PC_2(PC_2), // A data (input/reg) / B data (input/reg) / Program Counter + 2 (input/reg)
			.SH(SH), .FS(FS), // Shifter (input/reg) / Function Sel (input/reg) 
			.clk(clk), .rst(rst), .MW(MW), // Clock (input/input) / Reset (input/input) / Mem write (input/reg)
			.F(Fnet), .Data_out(Data_outnet), .BrA(BrAnet), .RAA(RAAnet), // Function data (output/wire) / Data output (output/wire) / Branch Address (output/wire) / Source A Address (output/wire)
			.VxorN(VxorNnet), .Z(Znet)); // Status bit (output/wire) / Zero (output/wire)

WB_SECT WB0(.F(F), .Data_out(Data_out), // Function data (input/reg) / Data output (input/reg)
			.VxorN(VxorN), .MD_1(MD_1), // Status bit (input/reg) / MUX D (input/reg)
			.DA(DA), // Destination Address (input/reg)
			.Bus_D(Bus_Dnet)); // Bus D (output/wire)
			
always@(negedge clk) begin // Clocked on negedge per Fig. 10-15
        PC <= PC_net;
        PC_1 <= PC_1net;
        PC_2 <= PC_1;
        
        IR <= IRnet;
        
        {RW,DA,MD,BS,PS,MW,FS,SH} <= {RWnet,DAnet,MDnet,BSnet,PSnet,MWnet,FSnet,SHnet};
        
        {RW_1,DA_1,MD_1} <= {RW,DA,MD};
        
        {Bus_A, Bus_B} <= {Bus_Anet, Bus_Bnet};
        
        {VxorN, F, Data_out} <= {VxorNnet, Fnet, Data_outnet};
end

always@(posedge rst) begin // Reset all registers back to zero
        {PC, PC_1, PC_2} = 0;
        IR = 0;
        {RW,DA,MD,BS,PS,MW,FS,SH} = 0;
        {RW_1,DA_1,MD_1} = 0;
        {Bus_A, Bus_B} = 0; 
end
			
endmodule
