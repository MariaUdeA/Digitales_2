// **********
// Top Module
// ********** 
module top (clk, nreset, nenter, inputdata, disp3, disp2, disp1, disp0);
	input logic clk, nreset, nenter;
	input logic [7:0] inputdata;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals 
	logic loaddata, inputdata_ready;
	logic reset, enter;
	assign reset = ~nreset;
	assign enter = ~nenter;
	
	// Module instantation: control unit 
	controlunit cu0 (clk, reset, loaddata, inputdata_ready);

	// Module instantation: datapath unit 
	datapathunit dp0 (clk, reset, enter, inputdata,
						   loaddata, inputdata_ready,
						   disp3, disp2, disp1, disp0);
endmodule



 /* ****************
	Módulo testbench 
	**************** */


module testbench();
	
	logic clk = 0;
   logic reset = 1'b0;
   logic enter = 1'b0;
   logic [7:0] inputdata;
   logic [6:0] disp3, disp2, disp1, disp0;
   localparam delay = 100ps;
    
    // Instantiate the top module
   top tb(clk, ~reset, ~enter, inputdata, disp3, disp2, disp1, disp0);


	// Simulación
	initial begin
	reset = 1'b1;
	#((delay)*2);
	reset = 1'b0;
	enter = 1'b0;
	#((delay)*2);
	
	
	//**********************DATO A***************************************
	//Dato A3
	inputdata = 8'hc1;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato A2
	inputdata = 8'h90;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato A1
	inputdata = 8'h00;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato A0
	inputdata = 8'h00;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	
	//**********************DATO B***************************************
	
	//Dato B3
	inputdata = 8'h41;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato B2
	inputdata = 8'h1.8;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato B1
	inputdata = 8'h00;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato B0
	inputdata = 8'h00;
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*3)
	
	
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	
	//Dato R
	/*enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*2)
	enter = 1'b1;
	#((delay)*2)
	enter = 1'b0;
	#((delay)*4)
	*/
	
	$stop;
	
	
	
	end

	// Generador del reloj
	always #((delay)/2)clk = ~clk;
endmodule

