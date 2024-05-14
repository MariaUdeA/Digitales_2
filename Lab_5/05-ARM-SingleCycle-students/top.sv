/*
 * This module is the TOP of the ARM single-cycle processor
 */ 
module top(input logic clk, nreset,
			  input logic [9:0] switches,
			  output logic [9:0] leds,
			  //entradas y salidas de displays
			  input logic nenter,
			  output logic [6:0] disp4, disp3, disp2, disp1, disp0
			  );

	// Internal signals
	logic reset, enter;
	assign reset = ~nreset;
	assign enter = ~nenter;
	logic [31:0] PC, Instr, ReadData;
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;
	
	// Instantiate instruction memory
	imem imem(PC, Instr);

	// Instantiate data memory (RAM + peripherals)
	dmem dmem(clk, reset, enter, MemWrite, DataAdr, WriteData, ReadData, switches, leds, disp4, disp3, disp2, disp1, disp0);

	// Instantiate processor
	arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
	
endmodule