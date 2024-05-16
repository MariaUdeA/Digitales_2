/*
 * This module is the Data Memory of the ARM single-cycle processor
 * It corresponds to the RAM array and some external peripherals
 */ 

 module dmem(input logic clk,reset, enter, we, input logic [31:0] a, wd, output logic [31:0] rd,
            input logic [9:0] switches, output logic [9:0] leds, 
				output logic[6:0] disp0, disp1, disp2, disp3, disp4 );
	//manejo del enter
	//logic enterpulse;
	//peripheral_pulse pl0 (enter, clk, reset, enterpulse);
	
	
	//MAPA
	//c000_0000 escribir leds (valor de los switches)leer pulsador
	//C000_0004 leer switches
	//c000_0008 escribir displays
	//c000_000c escribir abr
	//c000_0010 leer pulsador

	
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[63:0];

	initial
		// Uncomment the following line only if you want to load the required data for the peripherals test
		//$readmemh("dmem_to_test_peripherals.dat",RAM);

		// Uncomment the following line only if you want to load the required data for the program made by your group
	   $readmemh("C:/Users/julia/Desktop/Universidad/Electronica Digital 2/Laboratorio/Lab_5/05-ARM-SingleCycle-students/dmem_made_by_students.dat",RAM);
	
	// Process for reading from RAM array or peripherals mapped in memory
	always_comb
		if (a == 32'hC000_0004)			// Read from Switches (10-bits)
			rd = {22'b0, switches};
		else if (a==32'hc000_0010)
			rd = {31'b0, enter};
		else									// Reading from 0 to 252 retrieves data from RAM array
			rd = RAM[a[31:2]]; 			// Word aligned (multiple of 4)
	
	// Process for writing to RAM array or peripherals mapped in memory
	
	logic [3:0] entry_letter;
	logic [7:0] entry_num;
	displays disps(entry_letter, entry_num, disp4, disp3, disp2, disp1, disp0);

	
	always_ff @(posedge clk) begin
		if (we)
			if (a == 32'hc000_0000)	// Write into LEDs (10-bits)
				leds <= {2'b0,wd[7:0]};
			else if (a == 32'hC000_0008) begin
				entry_num<=wd[7:0];
			end else if (a == 32'hC000_000C)begin
				entry_letter<=wd[3:0];
				//escribir r a b (A=10, B=11, R=12, extended=1)
			end else	
				RAM[a[31:2]] <= wd;
	end	
endmodule