module tbmain ();
	// Parametros locales
	localparam SHIFT_BITS = 4;
	localparam TOPVALUE = 8;
	localparam CLK_PERIOD = 20ns;
	
	// Señales internas 
	logic clk, rst;
	logic [SHIFT_BITS-1 : 0] qLeds;
	
	// Instancia del modulo main
	main #(SHIFT_BITS, TOPVALUE) mInst (clk, ~rst, qLeds)
	
	// Simulation process
	initial begin
		clk = 0;
		rst = 0;
		#(CLK_PERIOD * 5);
		rst = 0;
		#(CLK_PERIOD * 100);
		
		$stop;
	end
	
	//generador de la señal de reloj
	
	always #(CLK_PERIOD/2) clk = ~clk;

endmodule