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

/*
module testbench();
	
	logic clk = 0;
   logic nreset = 1'b0;
   logic nenter = 1'b0;
   logic [7:0] inputdata;
   logic [6:0] disp3, disp2, disp1, disp0;
   localparam delay = 10ps;
    
    // Instantiate the top module
   top tb(clk, nreset, nenter, inputdata, disp3, disp2, disp1, disp0);


	// Simulación
	initial begin
	nreset = 1'b1;
	#((delay)*2);
	nreset = 1'b0;
	nenter = 1'b0;
	#((delay)*2);
	
	//**********************DATO A***************************************
	//Dato A3
	inputdata = 8'h3f;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	//Dato A2
	inputdata = 8'h80;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	//Dato A1
	inputdata = 8'h00;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	
	//Dato A0
	inputdata = 8'h00;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	
	//**********************DATO B***************************************
	
	//Dato B3
	inputdata = 8'h3f;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	//Dato B2
	inputdata = 8'h80;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	//Dato B1
	inputdata = 8'h00;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	
	//Dato B0
	inputdata = 8'h00;
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	nenter = 1'b1;
	#((delay)*2)
	nenter = 1'b0;
	#((delay)*2)
	
	
	$stop;
	
	
	
	end

	// Generador del reloj
	always #((delay)/2)clk = ~clk;
endmodule */

