// ******************* 
// Displays Module
// ******************* 
module displays (input logic[31:0] wd, input logic extended, output logic [6:0] disp4, disp3, disp2, disp1, disp0);
	logic [3:0] val0, val1, val2, val3, val4;
	logic [31:0] neg_wd;

	peripheral_deco7seg dp0 (val0, extended, disp0);
	peripheral_deco7seg dp1 (val1, extended, disp1);
	peripheral_deco7seg dp2 (val2, extended, disp2);
	peripheral_deco7seg dp3 (val3, 1, disp3);
	peripheral_deco7seg dp4 (val4, extended, disp4);
	assign neg_wd = ~wd +1'b1;
	// Process: store data into reg_datainput
	always_comb begin
		val4=4'b0; val3=4'b0; val2=4'b0; val1=4'b0; val0 =4'b0;
		if (extended)    //revisa que sea abr
			val4 = wd[3:0];
		else begin
			if(wd[31]) begin  //mira si es negativo
				val3 = 4'b1;
				val2=4'(neg_wd / 7'b1100100); //centenas
				val1=4'((neg_wd %  7'b1100100) / 4'b1010); //decenas
				val0=4'(neg_wd % 4'b1010); //unidades
			end else begin
				val3 = 4'b0;
				val2=4'(wd / 7'b1100100); //centenas
				val1=4'((wd %  7'b1100100) / 4'b1010); //decenas
				val0=4'(wd % 4'b1010); //unidades
			end
		end
	end

endmodule