.global _start
	.equ MAXN, 30	
	.text
_start:
	/* Inicio de programa:
	 * Inicialización de registros y lectura de valores requeridos la memoria
	 */
	 
	
	/* Cuerpo del programa:
	 *Codigo principal para generar los valores solicitados de la serie Finonnacci
	 */
	 	 
	 LDR R0, =vector
	 LDR R2, =SortedValues 
	 LDR R1, =N
	 LDR R1, [R1]
	 LDR R9, =a1
	 LDR R9, [R9]
	 
	 
	 //Interrupción cuando el N es menor a 5
	 CMP R1, #5
	 STR R9, [R2]
	 BLO _stop
	 
	 
	 //Interrupción cuando N es mayor a 30
	 CMP R1, #30
	 STR R9, [R2]
	 BHI _stop
	 	 
	 BL Fibo
	
	//Corregir que esto no genera el 0
	
	
Fibo:
	MOV R2, #1
	STR R2, [R0], #4
	STR R2, [R0], #4
	SUB R1, R1, #2

Loop:
	LDR R2, [R0, #-8]
	LDR R3, [R0, #-4]
	ADD R3, R2, R3
	STR R3, [R0], #4
	
	SUBS R1, R1, #1
	BNE Loop

EndLoop:
	MOV PC, LR
	 
	 
	 /* Fin de programa
	  * Bucle infinito para evitar la busqueda de nuevas instrucciones
	  */
	  
		
_stop:
 B _stop


 .data
 
 /*
  *Lista de variables en la memoria
  */
a1: 			.DC.L 0xA5A5A5A5
N:				.DC.L 5
POS:			.DC.L 2,9
ORDER:			.DC.L 1
vector:			.DS.L 5
SortedValues:	.DC.L MAXN

