.global _start
	.equ MAXN, 40
	.text

_start:
	 	
	 LDR R4, =N
	 LDR R4, [R4] // carga de valor de N
	 
	 LDR R9, =a1
	 LDR R9, [R9]
	 	 
	 //Interrupción cuando el N es menor a 5
	 CMP R4, #5
	 STRLO R9, [R2]
	 BLO _stop
	 	 
	 //Interrupción cuando N es mayor a 30
	 CMP R4, #30
	 STRHI R9, [R2]
	 BHI _stop
	  
	//organizar POS
	//Primero se mira si el orden es ascendente o descendente
	LDR R9, =ORDER			//Carga de order y su elemento
	LDR R9, [R9]

	LDR R3, =POS			//Carga de POS
    sub r8, r4,#1       // para comparar con n-1
	
	//organizacion
	bubble_up:
	mov r5, #0                              @ Initialize outer loop counter r5 with 0

	outer_loop:
    	mov r6, #0                          @ Initialize inner loop counter r6 with 0
    
	inner_loop:
    	cmp r6, r8                          @ Compare inner loop counter with n-1
    	bge next_outer_loop                 @ If r6 >= r4, exit inner loop
    
    	ldr r0, =POS                        @ Load the address of Array into r0
    	add r0, r0, r6, LSL #2		        @ Calculate the address of Array[j]
    	ldr r1, [r0]                        @ Load Array[j] into r1
    
    	add r7, r6, #1                      @ r7 = r6 + 1
    	ldr r0, =POS                        @ Load the address of Array into r0
    	add r0, r0, r7, LSL #2			    @ Calculate the address of Array[j+1]
    	ldr r2, [r0]                        @ Load Array[j+1] into r2
    
    	cmp r9,#1
		beq up
		down:
			cmp r1, r2                          @ Compare Array[j] with Array[j+1]
    		bge no_swap
			str r2, [r0,#-4]                    @ Store Array[j] into Array[j+1]
    		str r1, [r0]   
			b no_swap
		up:
			cmp r1, r2                          @ Compare Array[j] with Array[j+1]
    		ble no_swap                         @ If Array[j] <= Array[j+1], no swap
    		str r2, [r0,#-4]                    @ Store Array[j] into Array[j+1]
    		str r1, [r0]   
			
	no_swap:
    	add r6, r6, #1                      @ Increment inner loop counter
    	b inner_loop
    
	next_outer_loop:
    	add r5, r5, #1                      @ Increment outer loop counter
    	cmp r5, r8                          @ Compare outer loop counter with n-1
    	blt outer_loop                      @ If r5 < r4, repeat outer loop
    										@ Sorted array is now in Array
	// elige el valor máximo para hacer vector
	
	cmp r9,#1 //revisa el orden
	moveq R1, R2    //el valor mayor de pos en la pos mayor
	ldreq R10, [R3] //el valor menor de pos en la pos menor
	
	ldrne R1, [R3]  // el valor mayor de pos en la pos menor
	movne R10, R2   //el valor menor de pos en la pos mayor
	
	LDR R8, =a1
	LDR R8, [R8]
	
	LDR R0, =vector
	LDR R2, =SortedValues
	
	//revisar si el mayor sobrepasa 40
	 CMP R1, #40
	 STRHI R8, [R2]
	 BHI _stop
	
	//revisar si el menor es menor o igual a cero
	CMP R10, #1
	STRLO R8, [R2]
	BLO _stop
	
	//Generar los valores de la serie de fibonnacci.
	Fibo:
		MOV R2, #0
		STR R2, [R0], #4
		MOV R2, #1
		STR R2, [R0], #4
		//STR R2, [R0], #4
		SUB R1, R1, #2

	Loop:
		LDR R2, [R0, #-8]
		LDR R3, [R0, #-4]
		ADD R3, R2, R3
		STR R3, [R0], #4
	
		SUBS R1, R1, #1
		BNE Loop

	//Carga de los datos
	LDR R0, =vector
	LDR R2, =SortedValues
	LDR R3, =POS			//Carga de POS
	LDR R4, =N
	LDR R4, [R4] // carga de valor de N
	MOV R5, #0
	WHILE:
		CMP R5, R4
		BGE _stop
		LDR R6, [R3], #4  // en r6 se carga la posicion
		LSL R6, #2        //se multiplica por 4
		ADD R6, R0, R6    // posicion de vector a guardar
		SUB R6, #4        //para empezar en 0, y no en 1
		LDR R6, [R6]	  //se carga en r6 el valor de vector
		STR R6, [R2], #4  //se escribe en sorted values lo que hay en r6	
		ADD R5, R5, #1 //para finalizar
		B WHILE	
_stop:
 B _stop


 .data 
 /*
  *Lista de variables en la memoria
  */
a1: 			.DC.L 0xA5A5A5A5
N:				.DC.L 5
POS:			.DC.L 12,9,5,8,4 //salida: 2,3,13,21,89 
ORDER:			.DC.L 0
vector:			.DS.L MAXN
SortedValues:	.DC.L MAXN
