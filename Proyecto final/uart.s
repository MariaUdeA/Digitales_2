
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

.ALIGN 2 

uart_printMsg_asm:
    PUSH    {LR}
    // Prepara los argumentos para la función printf
    MOV     R3, R1      // MUEVO EL CICLO DE TRABAJO DE PWM 2 (R1) A R3
    MOV     R1, R0      // MUEVO EL CICLO DE TRABAJO DE PWM 1 (R0) A R1
    MOV     R2, R3      // MUEVO EL CICLO DE TRABAJO DE PWM 2 (R3) A R2
    B       _uart_printMsg_asm

_uart_printMsg_asm:
    LDR     R0, =uart_text_PWMStatus
    BL      __wrap_printf
    POP     {PC}
