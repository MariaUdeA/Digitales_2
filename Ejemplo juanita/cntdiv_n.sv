module cntdiv_n #(TOPVALUE = 50_000_000) (clk, rst, clkout);
	input logic clk, rst;
	output logic clkout;
	
	//Registro del contador
	localparam BITS = $clog2(TOPVALUE/2);
	logic [BITS-1 : 0] rcounter;
	
	//incrementar o resetear el contador
	
	always @(posedge clk, posedge rst) begin
		if (rst)begin
			rcounter <= 0;
			clkout <= 0;
		end
		
		else begin
			rcounter <= rcounter + 1'b1;
			if (rcounter == TOPVALUE/2 -1) begin  // -1 debido por la naturaleza del codigo
				clkout <= ~clkout;
				rcounter <= 0;
			end
			
		end
	
			
	end




endmodule