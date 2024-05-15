// ******************* 
// Displays Module
// ******************* 

module displays (input logic[7:0] wd, input logic [3:0] entry_num,
					  output logic [6:0] disp4, disp3, disp2, disp1, disp0);
	logic [3:0] val0, val1, val2, val3;
	logic [31:0] neg_wd;
	//logic extended_extra;
	
	peripheral_deco7seg dp0 (val0, 0, disp0);
	peripheral_deco7seg dp1 (val1, 0, disp1);
	peripheral_deco7seg dp2 (val2, 0, disp2);
	peripheral_deco7seg dp3 (val3, 1, disp3);
	peripheral_deco7seg dp4 (entry_letter, 1, disp4);
	
	assign neg_wd = ~wd +1'b1;
	// Process: store data into reg_datainput
	
	always_comb begin
		val3=4'b0; val2=4'b0; val1=4'b0; val0 =4'b0;
		begin
			if(wd[7]) begin  //mira si es negativo
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