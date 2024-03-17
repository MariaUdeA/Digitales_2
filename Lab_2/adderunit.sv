// **********************
// adder Unit Module
// **********************
module adderunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the sum
	logic sign_sum; 			//reconoce si los signos son iguales o diferentes
	logic sign_sum_out; 		//signo de la respuesta
	logic [7:0] exp_A;
	logic [7:0] exp_B;

	logic [7:0] exp_sum; 	//exponente de la suma sin normalizar
	logic [7:0] exp_sum_r;  //exponente de la suma final

	logic [4:0] bitshift;	//posicion del 1

	logic [24:0] mantissa_sum; 	//mantisa de la suma
	logic [24:0] mantissa_norm;	//mantisa normalizada
	logic [23:0] mantissa_A;		//mantiza de A
	logic [23:0] mantissa_B; 		//mantiza de B
	logic [23:0] mid;


	// Process: exponent and mantissa for adder
	//se toma el exp_sum del que tenga el mayor
	//la mantisa del menor se corre para que quede en el mismo exponente
	always_comb begin
		exp_A=dataA[30:23];
		exp_B=dataB[30:23];
		mantissa_B={1'b1, dataB[22:0]}; //se toman las ultimas 23 posiciones
		mantissa_A={1'b1, dataA[22:0]};
		if(exp_A > exp_B) begin
			exp_sum=exp_A;
			mid={1'b1, dataB[22:0]};
			mantissa_B=mid>>(exp_A-exp_B); 
		end else begin
			exp_sum=exp_B;
			mid={1'b1, dataA[22:0]};
			mantissa_A=mid>>(exp_B-exp_A);
		end
	end
	
	// Process: sign XORer
	
	always_comb begin
		sign_sum = dataA[31] ^ dataB[31];
		if(sign_sum==0) begin
			sign_sum_out=dataA[31]; //si se tienen signos iguales, no cambia el signo
		 end else
			if(mantissa_A>mantissa_B) // si se tienen signos distintos, se toma el del mayor
				sign_sum_out=dataA[31]; 
			else
				sign_sum_out=dataB[31];
	end
	
	// Process: mantissa sum or substraction
	always_comb begin
		if (sign_sum == 1) begin  // si los signos son diferentes, se restan las mantisas
			if (mantissa_A>mantissa_B) begin
				mantissa_sum = {1'b0, mantissa_A} - {1'b0, mantissa_B};
			end else
				mantissa_sum = {1'b0, mantissa_B} - {1'b0, mantissa_A};
		
		end else  // si los signos son iguales, se suman las mantisas
			mantissa_sum = {1'b0, mantissa_A} + {1'b0, mantissa_B};
	end
	
	always_comb begin
		bitshift=5'b00000;
		for (int cnt=24; cnt>=0 ;cnt=cnt-1)begin //for para saber donde esta el primer 1
			if(mantissa_sum[cnt])begin
				bitshift=cnt;
				break;
			end
		end
	end

	// Process: operand validator and result normalizer and assembler
	// Process special cases

	always_comb begin
		mantissa_norm=mantissa_sum;
		dataR[30:23]=exp_sum;
		if(bitshift==5'b11000)begin //normalizar si se pasa a la izquierda el 1
			mantissa_norm=mantissa_sum>>1;
			exp_sum_r=exp_sum+1'b1;		
		end else begin
			mantissa_norm=mantissa_sum<<(5'b10111-bitshift); // normalizar si se disminuye la posición de 1
			exp_sum_r=exp_sum-(5'b10111-bitshift);
		end	
		dataR[30:23]=exp_sum_r;
		dataR[31] = sign_sum_out;
		dataR[22:0]=mantissa_norm[22:0];

		//casos especiales
		if((exp_A==8'b11111111) || (exp_B==8'b11111111))begin //revisa si alguno es infinito
			if((exp_A==8'b11111111) && (exp_B==8'b11111111))begin //revisa si ambos son infinitos
				if(sign_sum)begin
					dataR=32'h7fc00000; //si son ambos infinitos con signo contrario, la salida es NaN
				end else begin
					dataR=dataA;  //ambos infinitos, mismo signo, mismo infinito de salida
				end
			end else begin
				if(exp_A==8'b11111111)begin //solo un infinito, se deja el infinito
					dataR=dataA;			
				end else begin
					dataR=dataB;
				end
			end
		end else begin
			if ((dataA[30:0]==dataB[30:0]) && (sign_sum==1'b1)) begin // revisa si las mantisas son iguales pero con signos distintos
				dataR=32'b0;
			end
		end
		
		
		if ((dataA[30:0]==31'b0) || (dataB[30:0]==31'b0)) begin // revisa si alguno es 0
			if((dataA[30:0]==31'b0) && (dataB[30:0]==31'b0)) begin //revisa si ambos son ceros
				dataR=32'h00000000;
			end if(dataA[30:0]==31'b0) begin //si uno es cero, la salida es el otro
				dataR=dataB;
			end else begin
				dataR=dataB;
			end
		end
	end
endmodule

 /* ****************
	Módulo testbench 
	**************** */

module testbench();
	/* Declaración de señales y variables internas */
   logic [31:0] dataA, dataB, dataR;

	
	localparam delay = 20ps;
	adderunit tb(dataA, dataB, dataR);
	// Simulación
	initial begin
	// suma de mayor negativo y menor positivo
	dataA=32'hc0fc0000; // -7.875
	dataB=32'h3e400000; //0.1875
	#(delay*2);
	
	// suma de +inf - inf
	dataA=32'h7f800000; // inf
	dataB=32'hff800000; // -inf
	#(delay*2);
	
	// suma de 0 - inf
	dataA=32'h00000000; // +0
	dataB=32'hff800000; // -inf
	#(delay*2);
	
	//suma de -7.875 y 7.9375	
	dataA=32'h40fe0000; // 7.9375
	dataB=32'hc0fc0000; // -7.875
	#(delay*2); //res 3d800000
	
	//suma de -7.875 y 7.875	
	dataA=32'h40fc0000; // 7.875
	dataB=32'hc0fc0000; // -7.875
	#(delay*2); //res 3d800000	

	//suma de 7.875 y 7.875	
	dataA=32'h40fc0000; // 7.875
	dataB=32'h40fc0000; // 7.875
	#(delay*2); //res 3d800000	

	end
endmodule
