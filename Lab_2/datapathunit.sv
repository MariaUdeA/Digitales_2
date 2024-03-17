// ******************** 
// Datapath Unit Module
// ******************** 
module datapathunit (clk, reset, enter, inputdata,
						   loaddata, inputdata_ready,
						   disp3, disp2, disp1, disp0);
	
	input logic  clk, reset, enter;
	input logic  [7:0] inputdata;
	input logic  loaddata;
	output logic inputdata_ready;
	output logic [6:0] disp3, disp2, disp1, disp0;

	// Internal signals and module instantiation for multiplier unit
	logic [31:0] dataA, dataB, dataR;
	adderunit addd0 (dataA, dataB, dataR);
	
	// Internal signals and module instantiation for peripherals unit
	peripherals p0 (clk, reset, enter, inputdata, loaddata, inputdata_ready, dataA, dataB, dataR, disp3, disp2, disp1, disp0);
endmodule

