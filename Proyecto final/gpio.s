/**
 * @file gpio.s
 *
 * @brief Contiene las funciones para el control de GPIO
 */

// Definiciones generales
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000


/**
 * @brief gpio_init_asm
 *
 * Función que inicia el modulo GPIO
 * Paramtros:
 * R0: GPIO_NUM
 */

.global gpio_init_asm
gpio_init_asm:
    PUSH    {R0, LR}
    BL      release_reset_IO_bank
    POP     {R0}
    BL      setFunctionGPIO
    POP     {PC}


/*
 *@brief release_reset_IO_BANK
 *
 * Esta función realiza el reset de IOBANK
 * parametros:
 * NONE
 */
.equ    RESETS_BASE,        0x4000C000
.equ    RESETS_DONE_OFFSET, 0x08
.equ    IO_BANK0_BITMASK,   0x20                  // coloca un 1 en el bit 5 de la dirección de reset, lo cual es un 1 en el offset de IOBANK0

.global release_reset_IO_bank
release_reset_IO_bank:
    LDR     R0, =(RESETS_BASE+ATOMIC_CLR)       // Dirección para el reset atomic clear
    MOV     R1, #IO_BANK0_BITMASK               // CARGAR LA MASCARA DE BIT 
    STR     R1, [R0]                            // REALIZA EL RESET EN IOBANK0: 5
    LDR     R0, =(RESETS_BASE)                  // DIRECCIÓN BASE DEL RESET
     
rstiobank0done:
    LDR     R1, [R0, #RESETS_DONE_OFFSET]       // Carga la dirección del resetDone para checkear que se haya resetado     
    MOV     R2, #IO_BANK0_BITMASK               // Carga la mascara de bit para el reset de IOBANK0
    AND     R1, R1, R2                          // checkea que el reset se haya realizado
    BEQ     rstiobank0done                      // MIENTRAS LA OPERACIÓN AND SEA DIFERENTE DE CERO EL RESET NO SE HA COMPLETADO                    // MIENTRAS LA OPERACIÓN AND SEA DIFERENTE DE CERO EL RESET NO SE HA COMPLETADO
    BX      LR    


/* @brief setFunctionGPIO.
 * 
 * Esta función selecciona la función GPIO
 * para los GPIOx
 * Parametros: 
 * R0: GPIO_NUM
 * R1: FUNCSEL
 */
.equ    IO_BANK0_BASE,  0x40014000      // BASE DEL REGISTRO IOBANK0
.equ    CTRL_OFFSET,    0x04            // OFFSET DE LA DIRECCIÓN DE CONTROL IOBANK0
.equ    FUNCSEL_IO,     0x05

.global setFunctionGPIO
setFunctionGPIO:
    LDR     R2, =(IO_BANK0_BASE+CTRL_OFFSET)        // DIRECCIÓN BASE DE GPIOx_CTRL
    MOV     R1, #FUNCSEL_IO                         // CARGAR EL NUMERO DE LA FUNCIÓN
    LSL     R0, R0, #3                              // MOVIMIENTO DIABOLICO QUE MAGICAMENTE ME LLEVA A LA DIRECCIÓN DE CONTROL DEL GPIOx
    STR     R1, [R2, R0]                            // GUARDA EL VALOR DE FUNCSEL_IO EN EL REGISTRO DE CONTROL DEL GPIOx
    BX      LR

/*
 * @brief gpio_set_dir_asm
 *
 * Esta función determita la dirección para un GPIOx
 * Parametros:
 * R0: GPIO_NUM
 * R1: OUT: (0: INPUT, 1: OUTPUT)
 */

.global gpio_set_dir_asm
.equ SIO_BASE,              0xd0000000      // DIRECCIÓN BASE DE RESGISTRO PARA SIO
.equ GPIO_OE_OFFSET,        0x20            // OFFSET DEL REGISTRO OUTPUT ENABLE 
.equ GPIO_OE_SET_OFFSET,    0x24            // OFFSET DEL REGISTRO OUPUT ENABLE SET
.equ GPIO_OE_CLR_OFFSET,    0x28            // OFFSET DEL REGISTRO OUTPUT ENABLE CLEAR

gpio_set_dir_asm:                       
    MOV     R2, #1                          // CARGA UN 1 EN EL REGISTRO R2
    LSL     R2, R2, R0                      // SE ALINEA ESE 1, CON EL GPIOx
    LDR     R0, =SIO_BASE                   // SE CARGA LA DIRECCIÓN BASE DEL REGISTRO SIO
    CMP     R1, #0                          // SI R1=0 EL PIN ES UN INPUT
    BEQ     gpio_set_dir_asm_clr            // SE LIMPIA ESE BIT PARA ACTIVAR EL OUTPUT ENABLE
    STR     R2, [R0, #GPIO_OE_SET_OFFSET]   // SE INICIALIZA EL GPIO COMO OUTPUT
    BX      LR                              // RETORNA

gpio_set_dir_asm_clr:
    STR     R2, [R0, #GPIO_OE_CLR_OFFSET]   // SE REINICIA EL GPIO
    BX      LR


/*
 *@brief gpio_put_asm
 *
 * Esta función inicializa el modulo gpio.
 * Parametros:
 * R0: GPIO_NUM
 * R1: VALOR (0: BAJO, 1: ALTO)
 */
.global gpio_put_asm
.equ GPIO_OUT_OFFSET,       0x10
.equ GPIO_OUT_SET_OFFSET,   0x14
.equ GPIO_OUT_CLR_OFFSET,   0x18
gpio_put_asm:
    MOV     R2, #1
    LSL     R2, R2, R0
    LDR     R0, =(SIO_BASE)
    CMP     R1, #0
    BEQ     gpio_put_clear_asm
    STR     R2, [R0, #GPIO_OUT_SET_OFFSET]
    BX      LR

gpio_put_clear_asm:
    STR     R2, [R0, #GPIO_OUT_CLR_OFFSET]
    BX      LR

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