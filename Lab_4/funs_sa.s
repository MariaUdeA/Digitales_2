.global _start
.equ MAXN, 90
.text
_start:
	mov R0, #60     	//numero de valores de generar de fibo
	LDR R1, =vector 	//donde meterlos
	
	//valores para probar el stack
	mov R5, #18			
	mov R4, #19
	
	bl Fibonacci
	b _stop
	
		//LDR R0, =vector

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
		adds R0, R0,R2
		adc R1, R1, R3
		mov pc,lr
	
_stop:
	b _stop //loop de fin
.data
	vector:			.DS.L MAXN
