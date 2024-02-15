module main #(SHIFT_BITS = 10, TOPVALUE = 50_000_000) (clk, rst, qLeds)
	// Entradas y salidas
	input logic clk, rst;
	output logic [SHIFT_BITS-1 : 0] qLeds;
	
	// Señales internas
	logic clkout;
	
	// Instancia del contador divisor
	cntdiv_n #(TOPVALUE) cntdiv (clk, ~rst, clkout);
	
	// Instancia del shift register
	shift_led #(SHIFT_BITS) shiffter (clk, ~rst, qLeds);
	

endmodule