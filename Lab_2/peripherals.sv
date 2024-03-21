// *********************** 
// Peripherals Unit Module
// *********************** 
module peripherals (clk, reset, enter, inputdata,
						  loaddata, inputdata_ready,
                    dataA, dataB, dataR, 
						  disp3, disp2, disp1, disp0);
	input logic  clk, reset, enter;
	input logic  [7:0] inputdata;
	input logic  loaddata;
	output logic inputdata_ready;
	output logic [31:0] dataA, dataB;
	input logic  [31:0] dataR;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals and module instantiation for pulse generation
	logic enterpulse;
	peripheral_pulse pl0 (enter, clk, reset, enterpulse);

	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	logic [3:0] datainput_i;
	logic [1:0] dataoutput_i;
	always_ff @(posedge reset, posedge clk) begin
		if (reset) begin
			datainput_i <= 4'b0;
			dataoutput_i <= 2'b0;
		end else if (loaddata) begin
			if (datainput_i < 8 && enterpulse) 
				datainput_i <= datainput_i + 4'b1;
		end else if (enterpulse) begin
			dataoutput_i <= dataoutput_i + 2'b1;
		end
	end
	
	assign inputdata_ready = (datainput_i == 4'd8) ? 1'b1 : 1'b0;
	
	// Internal signals and module instantiation for getting operands
	peripheral_getoperands go0 (clk, reset, inputdata, enterpulse, datainput_i, dataA, dataB);	

	// Internal signals, module instantiation and process for showing operands and result
	logic [15:0] valuestoshowondisps;
	peripheral_deco7seg dp3 (valuestoshowondisps[15:12], 1, disp3);
	peripheral_deco7seg dp2 (valuestoshowondisps[11:8],  0, disp2);
	peripheral_deco7seg dp1 (valuestoshowondisps[7:4],   0, disp1);
	peripheral_deco7seg dp0 (valuestoshowondisps[3:0],   0, disp0);
	always_comb begin
		valuestoshowondisps = 16'b0;
		
		if (loaddata) begin
			valuestoshowondisps[11:8] = {2'b0, ~datainput_i[1:0]};
			valuestoshowondisps[7:0] = inputdata;
			if (datainput_i[2] == 0) 
				valuestoshowondisps[15:12] = 4'b1010;	// A0 - A3
			else 
				valuestoshowondisps[15:12] = 4'b1011;	// B0 - B3
		end else begin
			valuestoshowondisps[15:12] = 4'b1100;
			valuestoshowondisps[11:8] = {2'b0, ~dataoutput_i};
			valuestoshowondisps[7:0] = dataR[~dataoutput_i*8 +: 8];
		end
	end
endmodule