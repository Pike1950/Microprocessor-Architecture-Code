`timescale 1ns / 1ps

module ALU(
    input [31:0] A,B,
    input [4:0] SH,FS,
    output reg Z,C,N,V,
    output reg [31:0] F);
    
`include "FSCODES.INC";
    
initial begin
    {Z,C,N,V} = 0;
end

always@(*) begin
        case(FS)
            ADD:
            begin
                {C,F} = A + B;
                V= (((A[31]) && (B[31])) && (!F[31]))? 1 :              // negative+negative=positive
                        (((!A[31]) && (!B[31])) && (F[31]))? 1 : 0;     // positive+positive=negative
            end
            SUB:
            begin
                F = A - B;
                V= (((A[31]) && (!B[31])) && (!F[31]))? 1 :              // negative-positive=positive
                        (((!A[31]) && (B[31])) && (F[31]))? 1 : 0;     // positive-negative=negative
            end
            AND:	
			    F = A&B;
		    OR:		
			    F = A|B;
		    XOR:	
			    F = A^B;
		    NOT:
			    F = ~A;
		    MOV:	
			    F = A;
		    LSL:
			    F = A<<SH;
		    LSR:
			    F = A>>SH;
		    JML:
			    F = A;
			    
		    default: F = 0;    
        endcase
        
        Z = (FS == JML) ? Z : // Table 10-20
                (F == 0) ? 1 : 0; // If result is zero, then flag
                
        N  = ((FS == MOV) || (FS == JML)) ? N :  // Table 10-20
                (F[31]) ? 1 : 0; // If sign bit is high, then flag

end
    
endmodule
