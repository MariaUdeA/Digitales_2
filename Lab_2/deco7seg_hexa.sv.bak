module deco7seg_hexa(
	input  logic [3:0] D,
	output logic [7:0] SEG);
 
	always_comb begin
		case(D)		   // pgfe_dcba
			4'h0: SEG = 8'b0011_1111;
			4'h1: SEG = 8'b0000_0110;
			4'h2: SEG = 8'b0101_1011;
			4'h3: SEG = 8'b0100_1111;
			4'h4: SEG = 8'b0110_0110;
			4'h5: SEG = 8'b0110_1101;
			4'h6: SEG = 8'b0111_1101;
			4'h7: SEG = 8'b0000_0111;
			4'h8: SEG = 8'b0111_1111;
			4'h9: SEG = 8'b0110_0111;
			4'hA: SEG = 8'b0111_0111;
			4'hB: SEG = 8'b0111_1100;
			4'hC: SEG = 8'b0011_1001;
			4'hD: SEG = 8'b0101_1110;
			4'hE: SEG = 8'b0111_1001;
			4'hF: SEG = 8'b0111_0001;
		endcase
	end
endmodule
