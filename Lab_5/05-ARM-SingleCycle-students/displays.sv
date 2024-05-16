// ******************* 
// Displays Module
// ******************* 

module displays (input logic[3:0] entry_letter, input logic [7:0] entry_num,
					  output logic [6:0] disp4, disp3, disp2, disp1, disp0);
	logic [3:0] val0, val1, val2, val3;
	logic [3:0] uni, dec, cen, sign;
	logic [7:0] neg_wd;
	logic ex1, ex2;
	//logic extended_extra;
	
	peripheral_deco7seg dp4 (entry_letter, 1, disp4);
	peripheral_deco7seg dp3 (val3, 1, disp3);
	peripheral_deco7seg dp2 (val2, ex2, disp2);
	peripheral_deco7seg dp1 (val1, ex1, disp1);
	peripheral_deco7seg dp0 (val0, 0, disp0);
	
	assign neg_wd = ~entry_num+1'b1;
	// Process: store data into reg_datainput
	
	always_comb begin
		begin
			if(entry_num[7]) begin  //mira si es negativo
				sign = 4'b1;
				cen=4'(neg_wd / 7'b1100100); //centenas
				dec=4'((neg_wd %  7'b1100100) / 4'b1010); //decenas
				uni=4'(neg_wd % 4'b1010); //unidades
			end else begin
				sign = 4'b0;
				cen=4'(entry_num / 7'b1100100); //centenas
				dec=4'((entry_num %  7'b1100100) / 4'b1010); //decenas
				uni=4'(entry_num % 4'b1010); //unidades
			end
			
			val0=uni;
			
			if(cen==4'b0) begin		//se revisa si las centenas estan en 0
				val3=4'b0;   			//cuarto display en 0
				if (dec==4'b0) begin	//se revisa si las decenas estan en 0
					val1=sign;			//se pone el signo en el segundo display y el tercero se apaga
					ex1=1'b1;
					val2=4'hF;
					ex2=1'b0;
				end else begin 		//se deja el signo en el tercer display
					val1=dec;			// el valor de decenas en el segundo
					ex1=1'b0;
					val2=sign;
					ex2=1'b1;
				end
			end else begin 			//funcionamiento normal
				val3=sign;
				val2=cen;
				val1=dec;
				ex2=1'b0;
				ex1=1'b0;
			end
		end
	end

endmodule