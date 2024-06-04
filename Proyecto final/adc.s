/*
 *@brief adc.s
 *
 * Contiene las funciones para la configuración del
 * periferico adc
*/
//Generales
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000
// 
/*
 *@brief adc_init_asm
 *
 * This functión does what it needs to do
 * Parameters:
 * R0: GPIO_NUM
 */

.global adc_init_asm
adc_init_asm:
    PUSH    {R0, LR}
    BL      release_reset_ADC_bank
    POP     {R0}

    PUSH    {R0}
    BL      setFunctionGPIO
    POP     {R0}
    MOV     R1, #0              //avisa que el pin es un input
    BL      gpio_set_dir_asm
    POP     {PC}


/*
 * @brief adc_reset_release
 *
 * Función que libera el reset del periférico adc
 * Parametros:
 * NONE
 */

.equ    RESETS_BASE,            0x4000C000
.equ    RESETS_DONE_OFFSET,     0x08
.equ    ADC_BITMASK,            0x001         

release_reset_ADC_bank:
    LDR     R0, =(RESETS_BASE+ATOMIC_CLR)       // Dirección para el reset atomic clear
    MOV     R1, #ADC_BITMASK                    // CARGAR LA MASCARA DE BIT 
    STR     R1, [R0]                            // REALIZA EL RESET EN IOBANK0: 5
    LDR     R0, =(RESETS_BASE)                  // DIRECCIÓN BASE DEL RESET

rstADCdone:
    LDR     R1, [R0, #RESETS_DONE_OFFSET]       // Carga la dirección del resetDone para checkear que se haya resetado     
    MOV     R2, #ADC_BITMASK                    // Carga la mascara de bit para el reset de IOBANK0
    AND     R1, R1, R2                          // checkea que el reset se haya realizado
    BEQ     rstADCdone                          // MIENTRAS LA OPERACIÓN AND SEA DIFERENTE DE CERO EL RESET NO SE HA COMPLETADO                    // MIENTRAS LA OPERACIÓN AND SEA DIFERENTE DE CERO EL RESET NO SE HA COMPLETADO
    BX      LR    

/*
 * @brief adc_config_asm
 *
 * Función que configura la lectura del ADC
 * Parametros:
 * R0: GPIO_NUM
 * Salidas:
 * R0: result_adc
 */
.equ    ADC_BASE,      0x4004C000
.equ    BASE_PIN,      26     
.equ    START_VAL,     5            //Registro de CS
.equ    ADC_DIV,       0x10         //frecuencia
.equ    ADC_RESULT,    0x04         //registro de resultado       

.equ    INT_SEG,   11         
.equ    DEC_SEG,   128 
.equ    READY_SIG,  1   

.global adc_read_asm
adc_read_asm:
    LDR     R2, =(BASE_PIN)
    SUB     R2, R0, R2            //configurar pin usado

//Primero se configura el registro CS
    LDR     R0, =(ADC_BASE)         //carga la dirección del registro CS
    mov     R1, #START_VAL          //carga el valor de enable y start_once
    LSL     R2, R2, #12             //mueve el canal 12 posiciones a la izquierda
    ADD     R2, R2, R1              //se pone también el enable y el start once 
    LDR     R1, [R0]                //carga en r0 el cs
    ORR     R1, R1, R2              //Escribir en enable y el start_once un 1 y el valor de la celda en 
    STR     R1, [R0]                //Escribir el cambio

//Configurar el registro DIV
// Para una frecuencia de 10KHz el CLK_DIV = 12.5
    LDR     R0, =(ADC_BASE + ADC_DIV)              // Carga la dirección del registro base
    mov     R1, #INT_SEG                           // Almacena en R1 la parte entera
    mov     R2, #DEC_SEG                           // Almacena en R2 la parte decimal 
    LSL     R1, R1, #8                             // Alinea la parte entera
    ORR     R1, R2, R1
    STR     R1, [R0]


    MOV     R2, #READY_SIG
    
Wait_sample:
    LDR     R1, =(ADC_BASE)         //Cargar el cosiaco de control
    LDR     R1, [R1]
    LSR     R1, R1, #8
    AND     R1, R1, R2              //saca el READY de la dirección
    CMP     R1, #0
    BEQ     Wait_sample

//Tomar muestra desde el registro de resultado
    LDR     R0, =(ADC_BASE+ADC_RESULT)
    LDR     R0, [R0]                //OJALA FUNCIONE
    BX      LR    
