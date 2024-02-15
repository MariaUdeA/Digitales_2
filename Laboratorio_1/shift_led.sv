module shift_led #(BITS = 10) (clk, rst, qLeds);
	input logic clk, rst;
	output logic qLeds;
	
	//Control de dirección
	logic toLeft
	
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			qLeds <= 1'b1;
			toleft <= 1'b1;
		end
		
		else if (toLeft) begin
			qLeds <= qLeds << 1;
			if (qLeds[BITS - 2]) begin
				toleft = 1'b0;
			end
		end
		
		else begin
				qLeds <= qLeds >> 1;
				if (qLeds[1]) begin
					toleft = 1'b1;
				end
		end
		
		
	end
	
	

endmodule 