/*
 * Testbench to test the peripherals part
 */ 
module testbench_peripherals();
	logic clk;
	logic reset;
	logic [9:0] switches, leds;

	localparam DELAY = 10;
	
	// instantiate device to be tested
	top dut(clk, reset, switches, leds);

	// initialize test
	initial
	begin
		reset <= 0; #DELAY; 
		reset <= 1; 
		
		switches <= 10'd4; #(DELAY*2000);
		
		$stop;
	end

	// generate clock to sequence tests
	always
	begin
		clk <= 1; #(DELAY/2); 
		clk <= 0; #(DELAY/2);
	end
endmodule