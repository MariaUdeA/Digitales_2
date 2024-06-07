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
 *@brief pwm_init_asm
 *
 * This functión does what it needs to do
 * Parameters:
 * R0: GPIO_NUM
 */

.global pwm_init_asm
pwm_init_asm:
    PUSH    {R0, LR}
    BL      release_reset_PWM_bank
    POP     {R0}
    BL      setFunctionPWM
    POP     {PC}


/*
 * @brief pwm_reset_release
 *
 * Función que libera el reset del periférico PWM
 * Parametros:
 * NONE
 */

.equ    RESETS_BASE,            0x4000C000
.equ    RESETS_DONE_OFFSET,     0x08
.equ    PWM_BITMASK,            0x4             

release_reset_PWM_bank:
    LDR     R0, =(RESETS_BASE+ATOMIC_CLR)
    MOV     R1, #PWM_BITMASK
    LSL     R1, R1, #8
    STR     R1, [R0]
    LDR     R0, =(RESETS_BASE)    

rstPWMdone:
    LDR     R1, [R0, #RESETS_DONE_OFFSET]
    MOV     R2, #PWM_BITMASK
    LSL     R2, R2, #8
    AND     R1, R1, R2
    BEQ     rstPWMdone
    BX      LR

/*
 *@brief setFunctionPWM
 *
 * Esta función seleciona la función PWM a un
 * Gpix
 * Parametros:
 * R0: GPIO_NUM
 *
 */
.equ    IO_BANK0_BASE,      0x40014000
.equ    CTRL_OFFSET,        0x04
.equ    GPIO_PWM_FUNCTION,  0x04

setFunctionPWM:
    LDR     R2, =(IO_BANK0_BASE+CTRL_OFFSET)
    MOV     R1, #GPIO_PWM_FUNCTION
    LSL     R0, R0, #0x03
    STR     R1, [R2, R0]
    BX      LR





/*
 * @brief pwm_config
 *
 * Función que configura el divisor de frecuencia del PWM
 * Parametros:
 * R0: CH_PWM
 */
.equ    PWM_BASE,   0x40050000
.equ    CH4_CSR,    0x50
.equ    CH4_DIV,    0x54
.equ    CH4_CC,     0x5c
.equ    CH4_TOP,    0x60

.equ    DEC_PART,   0           
.EQU    INT_PART,   128         
.equ    TOP_VALUE,  999         
.equ    CC_VALUE,   500

// prueba = 750 ---> 1KHz ---> 75%
//        = 500 ---> 1KHz ---> 50%
//        = 250 ---> 1KHz ---> 25%
//        = 100 ---> 1KHz ---> 10%
//        = 50  ---> 1KHz ---> 5%

.global pwm_config_asm
pwm_config_asm:

// Primero se carga el valor del divisor de frecuencia. --> 133MHz
// Para una frecuencia de 10KHz el CLK_DIV = 12.5
    LDR     R0, =(PWM_BASE + CH4_DIV)               // Carga la dirección del registro base 
    LDR     R1, =(INT_PART)                         // Almacena en R1 la parte entera
    LDR     R2, =(DEC_PART)                         // Almacena en R2 la parte decimal 
    LSL     R1, R1, #4                              // Alinea la parte entera
    ORR     R1, R2, R1

    STR     R1, [R0]
//  Se configura el registro cc para que el ciclo de trabajo sea del 50%
    LDR     R0, =(PWM_BASE + CH4_CC)        // CARGA LA DIRECCIÓN DEL REGISTRO CC
    LDR     R1, =CC_VALUE                   // R1 = VALOR DEL COUNTER COMPARE
    STR     R1, [R0]                        // SE GUARDA ESA DIRECCIÓN

// Ahora se carga el valor de TOP en el registro PWM_BASE+CH4_TOP
    LDR     R0, =(PWM_BASE + CH4_TOP)       
    LDR     R1, =TOP_VALUE    
    STR     R1, [R0]

// Se configura el registro CSR para que el PWM se active
    LDR     R0, =(PWM_BASE + CH4_CSR)
    MOV     R1, #0x1
    STR     R1, [R0]

    BX      LR    
 

/*
 * @brief Set_cycle_asm
 * Esta función modifica el valor del registro CHx_CC
 * Y con esto el ciclo de trabajo
 *
 * Parametros:
 * R0: CC_VALUE
 */
.equ    PWM_BASE,   0x40050000
.equ    CH4_CC,     0x5c

.global Set_cycle_A_asm
Set_cycle_A_asm:
    LDR     R1, =(PWM_BASE + CH4_CC)
    STR     R0, [R1]
    BX      LR

/*
 * @brief Set_cycle_asm
 * Esta función modifica el valor del registro CHx_CC
 * Y con esto el ciclo de trabajo
 *
 * Parametros:
 * R0: CC_VALUE
 */
.equ    PWM_BASE,   0x40050000
.equ    CH4_CC,     0x5c

.global Set_cycle_B_asm
Set_cycle_B_asm:
    LDR     R1, =(PWM_BASE + CH4_CC)
    LSL     R0, #16
    STR     R0, [R1]
    BX      LR
