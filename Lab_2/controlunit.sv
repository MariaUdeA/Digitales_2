// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;

	// Internal signals for state machine
	typedef enum logic [1:0] {s_loaddata, s_multiply} State;
	State currentState, nextState;

	// Process (Sequential): update currentState
	always_ff @(posedge clk, posedge reset)
		if (reset)
			currentState <= s_loaddata;
		else
			currentState <= nextState;
	
	// Process (Combinational): update nextState
	always_comb
		case (currentState)
			s_loaddata:
				if (inputdata_ready)
					nextState = s_multiply;
				else
					nextState = s_loaddata;
			s_multiply:
				nextState = s_multiply;
		endcase

	// Process (Combinational): update outputs 
	always_comb
		case (currentState)
			s_loaddata:
				loaddata = 1'b1;
			s_multiply:
				loaddata = 1'b0;
		endcase
endmodule

