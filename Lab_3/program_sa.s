.global _start
	.equ MAXN, 30
	.equ NUM, 10
	.text

_start:
		 	 
	 LDR R0, =vector
	 LDR R1, =N
	 LDR R2, =SortedValues
	 LDR R1, [R1]
	 LDR R9, =a1
	 LDR R9, [R9]
	 	 
	 //Interrupción cuando el N es menor a 5
	 CMP R1, #5
	 STRLO R9, [R2]
	 BLO _stop
	 	 
	 //Interrupción cuando N es mayor a 30
	 CMP R1, #30
	 STRHI R9, [R2]
	 BHI _stop
	 	 
	 B Fibo

//Generar los valores de la serie de fibonnacci.
	
	Fibo:
		MOV R2, #0
		STR R2, [R0], #4
		MOV R2, #1
		STR R2, [R0], #4
		STR R2, [R0], #4
		SUB R1, R1, #3

	Loop:
		LDR R2, [R0, #-8]
		LDR R3, [R0, #-4]
		ADD R3, R2, R3
		STR R3, [R0], #4
	
		SUBS R1, R1, #1
		BNE Loop

//Carga Y organización de los datos

	LDR R0, =vector    		//Carga de vector y sus elementos
	LDR R1, [R0], #4
	
	LDR R2, =SortedValues	//Carga de dirección de sortedValues
	
	LDR R3, =POS			//Carga de POS y su primer elemento
	LDR R4, [R3]
	
	LDR R5, =ORDER			//Carga de order y su elemento
	LDR R5, [R5]
	
	MOV R6, #1				//Inicio del contador
	
	LDR R7, =N				//Carga de N y su valor
	LDR R7, [R7]
	

	//Elección de orden descendente o ascendente
	
	CMP R5, R6			//Actualización de las flags, revisa si es un uno o no
	LDR R5, =ORDER  	//R5 toma el valor del final del vector POS
	BEQ sorted_cre			//Si hay igualdad salta a sorted_cre
	
	MOVNE R6, R7			   //Inicio del contador en N para decreciente
	LDRNE R0, =SortedValues-4    //Carga de vector y sus elementos, empezando desde atrás
	LDRNE R1, [R0]
	sorted_dec:
		BEQ _stop //detiene el programa si R6=0
		
		CMP R4, R6		//Comparación de POS[i] y CONT
		
		//Si son iguales guardamos esa posicion de vector
		BNE not_save_dec
		
		save_dec:
			
			STR R1, [R2], #4 //carga R1 en sorted values
			
			LDR R1, [R0, #-4]! //carga en R1 el siguiente de vector
			SUBS R6, R6, #1 //siguiente CONT
			LDR R3, =POS //reinicia pos
			LDR R4, [R3]
			
			B sorted_dec
			
		not_save_dec:
			LDR R4, [R3, #4]!	//Tomo la siguiente posición a guardar de POS			
			
			CMP R5, R3 //revisar si es el ultimo pos
			LDREQ R3, =POS //reinicia pos y carga el primero de pos
			LDREQ R4, [R3]
			LDREQ R1, [R0, #-4]! //siguiente del vector
			SUBEQS R6, R6, #1 //siguiente CONT
			
			B sorted_dec
			
	sorted_cre:
		CMP R6, R7 //compara el contador con N
		BHS _stop //detiene el programa
		
		CMP R4, R6		//Comparación de POS[i] y CONT
		
		//Si son iguales guardamos esa posicion de vector
		BNE not_save
		
		save:
			
			STR R1, [R2], #4 //carga R1 en sorted values
			
			LDR R1, [R0], #4 //carga en R1 el siguiente de vector
			ADD R6, R6, #1 //siguiente CONT
			LDR R3, =POS //reinicia pos
			LDR R4, [R3]
			
			B sorted_cre
			
		not_save:
			LDR R4, [R3, #4]!	//Tomo la siguiente posición a guardar de POS			
			
			CMP R5, R3 //revisar si es el ultimo pos
			LDREQ R3, =POS //reinicia pos y carga el primero de pos
			LDREQ R4, [R3]
			LDREQ R1, [R0], #4 //siguiente del vector
			ADDEQ R6, R6, #1 //siguiente CONT
			
			B sorted_cre
	

_stop:
 B _stop


 .data
 
 /*
  *Lista de variables en la memoria
  */
a1: 			.DC.L 0xA5A5A5A5
N:				.DC.L NUM
POS:			.DC.L 1,9,5,8 //salida: 0,3,21
ORDER:			.DC.L 0
vector:			.DS.L NUM
SortedValues:	.DC.L MAXN
