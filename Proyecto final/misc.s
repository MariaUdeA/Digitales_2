.equ ADC_MAX, 4000
.equ ADC_MIN, 1000
.equ PWM_MAX, 1000
.equ PWM_MIN, 500

.global Map
Map:
//Entradas: R0-> valor a mapear (PWM)
//Salidas->(x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min; en R0
	PUSH {R4, R5, LR}
	MOV R5, R0 // GUARDAR EN R5 LA EN
	LDR R3, =(ADC_MIN)
	LDR R4, =(PWM_MIN)
	LDR R1, =(ADC_MAX)
	LDR R0, =(PWM_MAX)
    // SI ES MENOR AL MINIMO, ASIGNA CERO Y SE VA
    CMP R5, R3
    BLE Se_va
// calcular la m
	SUB R0, R0, R4 // Dividendo 
	SUB R1, R1, R3	//Divisor
// Multiplicar por x-in_min
	SUB R5, R5, R3
	MUL R0, R5, R0
	BL Div

// Sumar out_min
	ADD R0, R0, R4
	POP {R4, R5, PC}
	//MOV PC,LR
	
Div:
//IMPORTANTE: Esta funcion solo sirve si el dividendo es mayor al divisor
// Entradas: R0-> dividendo, R1-> divisor
// Salidas: R0-> Resultado 
	MOV R2, #0
	Loop_div:
		ADD R2, #1 // contador para la división
   		SUB R0, R1
   		CMP R0,#0
   		BGT Loop_div
	MOV R0, R2
	MOV PC, LR
Se_va:
    MOV R0, #0x0
	POP {R4, R5, PC}

/*
 *@brief delay_asm
 *
 * Esta función gasta tiempo
 * Parametros:
 * R0: BIG_NUM
 */

 .global delay_asm
 delay_asm:
    SUB      R0, R0, #1
    BNE     delay_asm
    BX      LR


.global Factor
.equ FACTOR, 600
.equ over, 1000
//entrada R0
Factor:
	PUSH {LR}
	LDR R1, =(FACTOR)
	MUL R0, R0, R1
	LDR R1, =(over)
	BL  Div
	POP {PC}