.global _start
.equ MAXN, 90
.text
_start:
	//carga de datos
	ldr R0, =N
	ldr R0, [R0]
	
	ldr R1, =POS
	
	ldr R2, =ORDER
	ldr R2, [R2]
	BL Sort
	B _stop
	Sort:
		/*Entradas: R0 (L, largo del vector), R1 ([pos]), R2 (ORDER)
		  Salidas, ninguna, se organiza el vector en pos con N posiciones ascendente si ORDER=0, descendente si Order=1
		  OJO: se utiliza R12
		/*
		for index from 1 to length(array)
        	key = array[index]
        	j = index - 1
	        while j >= 0 and array[j] > key
	            array[j + 1] = array[j]
	            j = j - 1
        array[j + 1] = key
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
_stop:
	b _stop //loop de fin
.data
	N:				.DC.L 5
	POS:			.DC.L 6,4,3,11,10 //salida: 2,3,13,21,89 
	ORDER:			.DC.L 1