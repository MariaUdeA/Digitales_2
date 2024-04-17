.global _start
	.equ MAXN, 40
	.text

_start:
	 //Parámetros constantes del programa R4-R11
	 LDR R4, =N
	 LDR R4, [R4] 			// carga de valor de N
	 
	 LDR R5, =SortedValues	//ubicación de donde se guarda el vector de sorted values

	 LDR R9, =a1			//valor de salida error
	 LDR R9, [R9]
	 
	 LDR R6, =POS 			//pos de pos
	 
	 LDR R7, =ORDER
	 LDR R7, [R7] 			// carga de order
	 
	 LDR R8, =vector		//pos de vector donde se guarda fibonacci completo
	 
	 //Interrupción cuando el N es menor a 10
	 CMP R4, #10
	 STRLO R9, [R5]
	 BLO _stop
	 	 
	 //Interrupción cuando N es mayor a 50
	 CMP R4, #50
	 STRHI R9, [R5]
	 BHI _stop
	  
	//organizar POS usando sort
	//Primero se mira si el orden es ascendente o descendente
	mov R0, R4	     		//N
	mov R1, R6				//[pos]
	mov R2, R7			    //order
	
	BL Sort
	
	// elige el valor máximo para hacer vector
	// R1 se pone el menor y en R0 se pone el mayor
	// ascendente si ORDER=0, descendente si Order=1
	cmp   R7,#1 	//revisa el orden
	
	//descendente
	sub R4, R4, #1
	LDREQ R1, [R6,R4,LSL#2] 	//el valor menor de pos en la pos mayor
	ldreq R0, [R6] 		 		//el valor mayor de pos en la pos menor
	
	//ascendente
	ldrne R1, [R6] 			 	//el valor menor de pos en la pos menor
	LDRNE R0, [R6,R4,LSL#2]	    //el valor mayor de pos en la pos mayor
	add R4, R4, #1	
	
	//revisar si el menor R0 es menor o igual a cero
	CMP R1, #0
	STRLE R9, [R5]
	BLE _stop
	
	//revisar si el mayor sobrepasa 40
	 CMP R0, #90
	 STRHI R9, [R5]
	 BHI _stop
	
	//Generar los valores de la serie de fibonnacci
	//cargar los valores de entrada
	mov R1, R8
	
	BL Fibonacci
	
	
	//Carga de los datos
	
	MOV R0, #0 //contador
	WHILE:
		CMP R0, R4 					//compara contador con N
		BGE _stop
		LDR R1, [R6], #4  			// en R1 se carga la posicion
		SUB R1, #1 					//para que empiece en 0
		
		//num es R3:R2
		ADD R12, R8, R1, LSL #3
		LDR R3, [R12],#4		    //se carga en R2 lo que hay en [vector] + r1*4
		LDR R2, [R12],#4  		    //se carga eL siguiente valor
		
		STR R3, [R5], #4  			//se escribe en sorted values lo que hay en r6
		STR R2, [R5], #4  			//se escribe en sorted values lo que hay en r6	

		ADD R0, R0, #1 				//para finalizar
		B WHILE	
_stop:
 B _stop

Fibonacci:
	/*Recibe en RO=M y R1=[vector]
	Se hace la serie con M posiciones en [R1] y no se retornan valores  */
	
	//Guarda en Stack los registros que se van a utilizar y el LR para salir de la funcion (push)
	SUB SP,SP,#12
	STR LR,[SP,#8] 
	STR R5,[SP,#4] 
	STR R4,[SP]
	
	MOV R4, R0 //se guarda en r4 el M
	MOV R5, R1 // Se guarda en r5 la posicion de guardado
	
	//Inicio de fibonacci
	MOV R0, #0  		//R0 va a tener los valores de fibonacci LSB
	MOV R1, #0			//R1 va a tener los valores de fibonacci MSB
	STR R1, [R5], #4    //escribe primero la msw
	STR R0, [R5], #4

	MOV R0, #1
	STR R1, [R5], #4
	STR R0, [R5], #4
	
	SUB R4, R4, #2 		//contador
	
	//loop para generar la serie
	Loop:
		//primer num A
		LDR R1, [R5, #-16]  //msw
		LDR R0, [R5, #-12]	//lsw
		//segundo num B
		LDR R3, [R5, #-8] 	//msw
		LDR R2, [R5, #-4]  	//lsw
		
		//sumar
		BL add_64
		//escribir el num
		STR R1, [R5], #4 	//primero la msw
		STR R0, [R5], #4 
				
		//actualizar el contador	
		SUBS R4, R4, #1
		BNE Loop
		
	//devuelve al stack 
	LDR R4,[SP]
	LDR R5,[SP,#4]
	LDR LR,[SP,#8]
	ADD SP,SP,#12 //devuelve el espacio (POP)
	mov pc, lr
	
add_64:
	//Recibe: A=R1:R0, B=R3:R2
	//Hace A+B=C
	//Devuelve C=R1:R0
	//NO hace uso del stack porque no sale del uso de R0-R3
		adds R0, R0, R2
		adc  R1, R1, R3
		mov pc,lr


Sort:
		/*Entradas: R0 (L, largo del vector), R1 ([pos]), R2 (ORDER)
		  Salidas, ninguna, se organiza el vector en pos con N posiciones ascendente si ORDER=0, descendente si Order=1
		  OJO: se utiliza R12
		*/
		//key es R3
		//i es R4
		//j es R5
		//r12 al aire para operaciones
		SUB SP,SP,#8
		STR R5,[SP,#4] 
		STR R4,[SP]
		mov r4, #1
		For1:
			cmp R4, R0  //for index from 1 to length(array)
			BEQ End_for
			
			LDR R3, [R1,R4,LSL #2]	    //key=array[i], se carga en key lo que hay en [pos] + index*4
			
			sub R5, R4, #1			    //j=index-1
			
			while1:
				cmp R5, #0				//while j >= 0 
				BLT end_while1
				LDR R12, [R1,R5,LSL #2] //array[j]
				
				//decision de subir o bajar
				cmp R2,#0
				beq up
				down:
					cmp R12, R3				//and array[j] < key
					BGE end_while1
					B while2
				up:
					cmp R12, R3				//and array[j] > key
					BLE end_while1
				
				while2:	
				add R5, R5, #1 			//j=j+1
				STR R12, [R1,R5,LSL #2] //array[j+1]=array[j]
				SUB R5, R5, #2 			//j=j-2
				B while1
				
			end_while1:
			ADD R5, R5,#1
			STR R3, [R1,R5,LSL #2]		//array[j+1]=key
			SUB R5, R5, #1
			ADD R4, R4, #1
			B For1
		End_for:
			LDR R4,[SP]
			LDR R5,[SP,#4]
			ADD SP,SP,#8 //devuelve el espacio (POP)
			mov pc, lr
 .data 
 /*
	Lista de variables en la memoria
 */
a1: 			.DC.L 0xA5A5A5A5
N:				.DC.L 10
POS:			.DC.L 1,3,1,2,5, 10,12,2,3,2 //salida: 2,3,13,21,89 
ORDER:			.DC.L 1
vector:			.DS.L MAXN
SortedValues:	.DS.L MAXN