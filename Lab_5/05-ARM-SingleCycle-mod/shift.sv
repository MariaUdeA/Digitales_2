/*
 * This module performs the shifting operations
 * LRL, LSR, ASR, ROR	
 */ 

module shift(input logic [6:0] sh,
				 input logic [31:0] RD2,
				 output logic [31:0] y);
	

	
	// AQUI DEBEN IR LAS OPERACIONES DE SHIFT
	always_comb begin
		case(sh[1:0])
			2'b00: y = RD2 << sh[6:2];					//Logical Left Shift
			2'b01: y = RD2 >> sh[6:2];					//Logical Right Shift
			2'b10: y = RD2 >>> sh[6:2];				//Arithmetic Right Shift
			2'b11: y = (RD2 >> sh[6:2]) | (RD2 << (32-sh[6:2])); 		//Rotate Right
			
			default: y = RD2; //No shift
		endcase
	end
	
	
	
endmodule
