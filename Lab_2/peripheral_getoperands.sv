// ******************* 
// Get Operands Module
// ******************* 
module peripheral_getoperands (clk, reset, inputdata, enterpulse, datainput_i, dataA, dataB);
	input logic clk, reset;
	input logic [7:0] inputdata;
	input logic enterpulse;
	input logic [3:0] datainput_i;
	output logic [31:0] dataA, dataB;

	// Internal signals to store data
	logic [63:0] reg_datainput;
	
	// Process: store data into reg_datainput
	always_ff @(posedge reset, posedge clk) begin
		if (reset) begin
			reg_datainput <= 0;
		end else if (datainput_i < 8) begin
			reg_datainput[(datainput_i*8) +: 8] <= inputdata;
		end
	end
	
	// Structural Process: assign A and B to signals
	assign dataA = reg_datainput[31:0];
	assign dataB = reg_datainput[63:32];
endmodule			