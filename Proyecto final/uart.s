
/**
 * @file uart.s
 * 
 * @brief: Incluye las funciones para el uso del UART 
 */

/**
 * @brief uart_printMsg_asm
 *
 * Función que imprime un mensaje en la terminal.
 */

.global uart_printMsg_asm

uart_text_PWMStatus:       .string "Canal PWM 1 ciclo de trabajo: %d, Canal PWM 2 ciclo de trabajo:  %d\n"
uart_text_ADCStatus:       .string "Canal ADC 0 valor: %d, Canal ADC 1 valor:  %d\n"

.align 2 
/*
@brief uart_printMsg_asm
entradas:
r0 - pwm1 / adc1
r1 - pwm2 / adc2
r2 - pwm (1) o adc (0)
*/

uart_printMsg_asm:
    PUSH    {LR}
    MOV R3, R2 // LLEVA A R3 EL COSO PARA DECIDIR ENTRE ADC O PWM
    // Prepara los argumentos para la función printf
    MOV     R2, R1      // MUEVO EL CICLO DE TRABAJO DE PWM 2 (R1) A R2
    MOV     R1, R0      // MUEVO EL CICLO DE TRABAJO DE PWM 1 (R0) A R1

    CMP    R3, #0X1
    BEQ       _uart_printMsg_asm_PWM
    BNE       _uart_printMsg_asm_ADC

_uart_printMsg_asm_PWM:
    LDR     R0, =uart_text_PWMStatus
    BL      __wrap_printf
    POP     {PC}

_uart_printMsg_asm_ADC:
    LDR     R0, =uart_text_ADCStatus
    BL      __wrap_printf
    POP     {PC}