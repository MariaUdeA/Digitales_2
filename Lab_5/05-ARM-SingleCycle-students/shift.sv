module shift (
	input logic [31:0] entrada,
	input logic [6:0] instr,
	output logic [31:0] b
);

	logic [1:0] shtype;

	assign shtype = instr [1:0];

	always_comb begin
		case (shtype)
		2'b00: b = entrada << instr[6:2]; 												//LSL
		2'b01: b = entrada >> instr[6:2]; 												//LSR
		2'b10: b = entrada >>> instr[6:2]; 												//ASR
		2'b11: b = (entrada >> instr[6:2]) | (entrada << (32-instr[6:2])); 	//ROR

		endcase
	end
endmodule

