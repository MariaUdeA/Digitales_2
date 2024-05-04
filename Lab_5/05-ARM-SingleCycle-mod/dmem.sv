/*
 * This module is the Data Memory of the ARM single-cycle processor
 * It corresponds to the RAM array and some external peripherals
 */ 
module dmem(input logic clk, we, input logic [31:0] a, wd, output logic [31:0] rd,
            input logic [9:0] switches, output logic [9:0] leds);
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[63:0];

	initial
		// Uncomment the following line only if you want to load the required data for the peripherals test
		$readmemh("dmem_to_test_peripherals.dat",RAM);

		// Uncomment the following line only if you want to load the required data for the program made by your group
		// $readmemh("dmem_made_by_students.dat",RAM);
	
	// Process for reading from RAM array or peripherals mapped in memory
	always_comb
		if (a == 32'hC000_0000)			// Read from Switches (10-bits)
			rd = {22'b0, switches};
		else									// Reading from 0 to 252 retrieves data from RAM array
			rd = RAM[a[31:2]]; 			// Word aligned (multiple of 4)
	
	// Process for writing to RAM array or peripherals mapped in memory
	always_ff @(posedge clk) begin
		if (we)
			if (a == 32'hC000_0004)	// Write into LEDs (10-bits)
				leds <= wd[9:0];
			else	
				RAM[a[31:2]] <= wd;
	end	
endmodule