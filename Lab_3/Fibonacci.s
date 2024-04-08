.global _start
	.equ MAXN, 30
	.equ NUM, 7
	.text

_start:
		 	 
	 LDR R0, =vector
	 LDR R1, =N
	 LDR R2, =SortedValue
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

LDR R0, =vector
LDR R2, =SortedValues    //Se carga la dirección de SortedValues[0]
LDR R1, =POS
LDR R3, [R1], #4		 //Asignamos la primera poscicion del POS
LDR R4, =ORDER
LDR R4, [R4]			//Obtenemos el valor de 1 o 0 de la organización
MOV R5, #1
LDR R6, =N
LDR R6, [R6]

SUBS R4, R4, #1
BEQ sorted


Sorted_inv:
	//Ordenador descendente	
	BNE sorted_inv
	

sorted:
	//Ordenador ascendente
	SUBS R7, R3, R5   		// POS[i] - CONT ACTUALIZA LAS ALUS
	BEQ Loop2	
	
	Loop2:
		STR R0, [R2], #4
	
	LDR R3, [R1], #4
	ADD R5, R5, #1
	
	SUBS R7, R6, R5
	BNE sorted
	
	

	


_stop:
 B _stop


 .data
 
 /*
  *Lista de variables en la memoria
  */
a1: 			.DC.L 0xA5A5A5A5
N:				.DC.L NUM
POS:			.DC.L 2,9
ORDER:			.DC.L 1
vector:			.DS.L NUM
SortedValues:	.DC.L MAXN

