/*
 *@brief pwm.s
 *
 * Contiene las funciones para la configuración del
 * perifereico PWM
*/
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000
/*
 * @brief pwm_config
 *
 * Función que configura el divisor de frecuencia del PWM
 * Parametros:
 * 
 */
.equ    PWM_BASE,   0x40050000
.equ    CH7_CSR,    0x8c
.equ    CH7_DIV,    0x90
.equ    CH7_CC,     0x98
.equ    CH7_TOP,    0x9c

.equ    DEC_PART,   0x8000      // 0.5 en punto fijo
.EQU    INT_PART,   0xc         // 12 en punto fijo
.equ    TOP_VALUE,  0x3e7       // 999 decimal
.equ    CC_VALUE,   0x1f4       // 500 decimal

.global pwm_config_asm
pwm_config_asm:

// Primero se carga el valor del divisor de frecuencia.
// Para una frecuencia de 10KHz el CLK_DIV = 12.5
    LDR     R0, =(PWM_BASE + CH7_DIV)              // Carga la dirección del registro base 
    LDR     R1, =(INT_PART)                         // Almacena en R1 la parte entera
    LDR     R2, =(DEC_PART)                         // Almacena en R2 la parte decimal 
    LSL     R1, R1, #4                              // Alinea la parte entera
    
    STR     R2, [R0]              // Se carga la parte decimal
    STR     R1, [R0]              // Se carga la parte entera

// Ahora se carga el valor de TOP en el registro PWM_BASE+CH7_TOP
    LDR     R0, =(PWM_BASE + CH7_TOP)
    LDR     R1, =TOP_VALUE    
    STR     R1, [R0]

//  Se configura el registro cc para que el ciclo de trabajo sea del 50%
    LDR     R0, =(PWM_BASE + CH7_CC)
    LDR     R1, =CC_VALUE
    STR     R1, [R0]

// Se configura el registro CSR para que el PWM se active
    LDR     R0, =(PWM_BASE + CH7_CSR)
    MOV     R1, #0x1
    STR     R1, [R0]

    BX      LR    



