.global _start
	.equ MAXN, 	30
	.text
_start:
	/* Inicio de programa:
	 * Inicialización de registros y lectura de valores requeridos la memoria
	 */
	 
	 
	 
	 
	 
	
	/* Cuerpo del programa:
	 *Codigo principal para generar los valores solicitados de la serie Finonnacci
	 */
	 LDR R0, =vector
	 MOV R1, #N
	 
	 CMP R1, #N
	 BLE _stop
	 
	 SUB
	 
	 
	 BL Fibo
	
Fibo:
	MOV R2, #1
	STR R2, [R0, #4]
	SUB R1, R1, #2

Loop:
	LDR R2, [R0, #-8]
	LDR R3, [R0, #-4]
	ADD R3, R2, R3
	STR R3, [R0, #4]
	
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
  *Lista de variables
  */

N:				.DC.L 5
POS:			.DC.L 2,9
ORDER:			.DC.L 1
vector:			.DS.L N
SortedValues:	.DC.L MAXN
