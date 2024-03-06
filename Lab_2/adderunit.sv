// **********************
// adder Unit Module
// **********************
module adderunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	logic sign_sum;
	logic [7:0] exp_sum;
	logic [24:0] mantissa_sum;
	
	// Process special cases

	always_comb begin
		case(dataA[31])
		1'b0:
			
		
	end
		
	
	
			
	// Process: sign XORer
	always_comb
		sign_sum = dataA[31] ^ dataB[31];
	
	// Process: exponent adder
	always_comb begin
		exp_sum = (dataA[30:23] - dataB[30:23])- 8'd127;  //PREGUNTAR POR LA NORMALIZACIÓN
	end
	
	// Process: mantissa sum
	always_comb begin
		if (sign_sum == 1) begin
			if (dataA[31])
				mantissa_sum = {1'b1, dataA[22:0]} - {1'b1, dataB[22:0]};
			else
				mantissa_sum = -{1'b1, dataA[22:0]} + {1'b1, dataB[22:0]};
		
		end else
			mantissa_sum = {1'b1, dataA[22:0]} + {1'b1, dataB[22:0]};
		
	end
	
	// Process: operand validator and result normalizer and assembler
	always_comb begin
		dataR[31] = sign_sum;
		if (mantissa_multR[24]) begin
			dataR[30:23] = exp_sum + 8'd1;
			dataR[22:0] = mantissa_sum[23:1];
		end else begin
			dataR[30:23] = exp_multR;
			dataR[22:0] = mantissa_multR[22:0];
		end
	end
endmodule

