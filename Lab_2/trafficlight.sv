/* **************************************
	Módulo controlador de tráfico de luces 
	************************************** */
	
module trafficlight #(FPGAFREQ = 50_000_000, tVERDE1 = 18, tAMAR1 = 4, tVERDE2 = 10, tAMAR2 = 3,tVERDE3=5, tROJO=2,tRESET=3)
   (clk, nreset, nbtn, main_lights, sec_lights, p_lights, btn_pressed, Seg0, Seg1);

	/* Entradas y salidas */
	input logic clk, nreset, nbtn;
	output logic [2:0] main_lights;	    // rojo, amarillo, verde
	output logic [2:0] sec_lights;	    // rojo, amarillo, verde
	output logic [1:0] p_lights; 		// rojo, verde
	output logic btn_pressed;			// Luz que indica que el boton fue presionado
	output logic [7:0] Seg0, Seg1;      // Salida del decodificador

	/* Circuito para invertir señal de reloj */
	logic reset;
	assign reset = ~nreset;
	
	/* Circuito para invertir señal del boton peatonal */
	logic btn;
	assign btn = ~nbtn;
	
	logic [3:0] decenas; //decenas de entrada al 7segmentos
	logic [3:0] unidades; //unidades de entrada al 7segmentos
	
	
	/* Conexión de los display 7 segmentos*/
	deco7seg_hexa deco0 (unidades, Seg0);
	deco7seg_hexa deco1 (decenas, Seg1);
	
	/* Señales internas para contar segundos a partir del reloj de la FPGA */
	localparam FREQDIVCNTBITS = $clog2(FPGAFREQ);	// Bits para contador divisor de frecuencia
	logic [FREQDIVCNTBITS-1:0] cnt_divFreq;			// Contador para generar un (1) segundo 
	
	/*CAMBIAR tVERDE1 SI NO ES EL TIEMPO MAS LARGO POR EL MAS LARGO*/
	localparam SECCNTBITS = $clog2(tVERDE1);	    // Bits para el contador de segundos
	logic [SECCNTBITS-1:0] cnt_secLeft;			    // Contador de segundos restantes
	logic cnt_timeIsUp;							    // Tiempo completado en estado actual
	
	/* Definición de estados de la FSM y señales internas para estado actual y siguiente */
	typedef enum logic [2:0] {Srst, Smg, Smy, Ssg, Ssy, Spg, Sar} State;
	State currentState, nextState;
	
	/* *********************************************************************************************
		Circuito secuencial para actualizar estado actual con el estado siguiente. 
		Se emplea señal de reloj de 50 Mhz.  
		********************************************************************************************* */
	always_ff @(posedge clk, posedge reset)
		if (reset)
			currentState <= Srst;
		else 
			currentState <= nextState;
			
	
	/* *********************************************************************************************
		Circuito secuencial para mantener el valor del boton pulsado.  
		********************************************************************************************* */
	always_ff @(posedge clk, posedge reset) begin
		if (reset) begin
			btn_pressed = 1'b0;
		end else if(btn) begin
			if (currentState == Srst) 
				btn_pressed <= 1'b0;
			else if (currentState == Spg)	
				btn_pressed <= 1'b0;
			else
				btn_pressed <= 1'b1;			
		end
	end
	/* *********************************************************************************************
		Circuito combinacional para determinar siguiente estado de la FSM 
		********************************************************************************************* */
	always_comb begin
		if(cnt_timeIsUp)
			case (currentState)
				Srst:
					nextState = Smg;
				Smg:	
					nextState = Smy;
				Smy:	
					nextState = Ssg;
				Ssg:	
					nextState = Ssy;
				Ssy:	
					nextState =(btn_pressed==1'b1) ? Spg:Smg;
				Spg:
					nextState = Sar;
				Sar:
					nextState = Smg;
				default:		
					nextState = Srst;
			endcase
		else	
			nextState = currentState;
	end	
	
	/* *********************************************************************************************
		Circuito combinacional para manejar las salidas
		********************************************************************************************* */
	always_comb begin
		main_lights = 3'b100;			    // Para simplificar cada case
		sec_lights = 3'b100;				// Para simplificar cada case
		p_lights = 2'b10;					//Para simplificar cada case
		case (currentState)
			Smg: 
				main_lights = 3'b001;
			Smy:  
				main_lights = 3'b010;
			Ssg: 
				sec_lights = 3'b001;
			Ssy:  
				sec_lights = 3'b010;
			Spg:
				p_lights = 2'b01;
			default:
				main_lights = 3'b100;
		endcase
	end	

	/* *********************************************************************************************
		Circuito secuencial para el contador de segundos y la visualización en displays
		********************************************************************************************* */
	always_ff @(posedge clk, posedge reset) begin
		if (reset) begin
			cnt_divFreq <= 0;
			cnt_secLeft <= SECCNTBITS'(tRESET-1);	// Casting
			cnt_timeIsUp <= 0;
		end else begin
			cnt_divFreq <= cnt_divFreq + 1'b1;
			cnt_timeIsUp <= 0;

			if (cnt_divFreq == FPGAFREQ-1) begin // ¿Un segundo completado?
				cnt_divFreq <= 0;
				cnt_secLeft <= cnt_secLeft - 1'b1;

				// Determinar si se completaron los segundos del estado correspondiente
				if(cnt_secLeft == 0) begin // Contador == 0 y pasará en este ciclo a modCnt-1
					cnt_timeIsUp <= 1;
					case (currentState)
						Srst:
							cnt_secLeft <= SECCNTBITS'(tVERDE1-1);	// Casting
						Smg:
							cnt_secLeft <= SECCNTBITS'(tAMAR1-1);	// Casting
						Smy:
							cnt_secLeft <= SECCNTBITS'(tVERDE2-1);	// Casting
						Ssg:
							cnt_secLeft <= SECCNTBITS'(tAMAR2-1);	// Casting
						Ssy:
							cnt_secLeft <= (btn_pressed==1'b1) ? SECCNTBITS'(tVERDE3-1):SECCNTBITS'(tVERDE1-1);	// Casting y revision de btnpress
						Spg:
							cnt_secLeft <= SECCNTBITS'(tROJO-1);    //Casting
						Sar:
							cnt_secLeft <= SECCNTBITS'(tVERDE1-1);
						
					endcase
				end
			end
		end	
	end
	
	/* *********************************************************************************************
		Modulo para dividir el cnt_secLeft en decenas y unidades
		********************************************************************************************* */
	always_comb begin
		decenas=4'(cnt_secLeft / 4'b1010); //casting y division entera
		unidades=4'(cnt_secLeft % 4'b1010); //casting y modulo
	end
	
	
	
endmodule

/* ****************
	Módulo testbench 
	**************** */
module testbench();
	/* Declaración de señales y variables internas */
	logic clk, reset, btn;
	logic [2:0] main_lights, sec_lights;
	logic [1:0] p_lights;



	localparam FPGAFREQ = 8;
	localparam tRESET = 1;
	localparam tVERDE1 = 4;
	localparam tAMAR1 = 2;
	localparam tVERDE2 = 2;
	localparam tAMAR2 = 2;
	localparam tVERDE3 = 2;
	localparam tROJO = 2;
	
	localparam delay = 20ps;
	

	// Instanciar objeto
	trafficlight #(FPGAFREQ, tVERDE1, tAMAR1, tVERDE2, tAMAR2,tVERDE3, tROJO,tRESET) tl 
	              (clk,~reset,~btn, main_lights, sec_lights, p_lights, btn_pressed, Seg0, Seg1);
	// Simulación
	initial begin
		//ciclo sin botón
		/*
		clk = 0;
		reset = 1;
		#(delay);
		reset = 0;
		#(delay*(tRESET+tVERDE1+tAMAR1+tVERDE2+tAMAR2)*FPGAFREQ*2);*/
		
		//Ciclo con botón en rst y afuera
		/*clk = 0;
		reset = 1;
		btn=0;
		#(delay);
		reset = 0;
		btn=1;
		#(delay);
		btn =0;
		#(delay*(tVERDE2+tAMAR2)*FPGAFREQ*2);*/

		clk = 0;
		reset = 1;
		#(delay);
		reset = 0;
		btn = 1'b1;
		#(delay*(tRESET+tVERDE1+tAMAR1+tVERDE2+tAMAR2+tVERDE3+tROJO)*FPGAFREQ*2);
		$stop;
	end
	
	// Proceso para generar el reloj
	always #(delay/2) clk = ~clk;
endmodule