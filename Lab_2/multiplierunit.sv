// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	logic sign_multR;
	logic [7:0] exp_multR;
	logic [47:0] mantissa_multR;
			
	// Process: sign XORer
	always_comb
		sign_multR = dataA[31] ^ dataB[31];
	
	// Process: exponent adder
	always_comb begin
		exp_multR = dataA[30:23] - 8'd127 + dataB[30:23];
	end
	
	// Process: mantissa multiplier
	always_comb begin
		mantissa_multR = {1'b1, dataA[22:0]} * {1'b1, dataB[22:0]};
	end
	
	// Process: operand validator and result normalizer and assembler
	always_comb begin
		dataR[31] = sign_multR;
		if (mantissa_multR[47]) begin
			dataR[30:23] = exp_multR + 8'd1;
			dataR[22:0] = mantissa_multR[46:24];
		end else begin
			dataR[30:23] = exp_multR;
			dataR[22:0] = mantissa_multR[45:23];
		end
	end
endmodule

