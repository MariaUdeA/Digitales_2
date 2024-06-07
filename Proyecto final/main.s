.equ ADC_PIN1, 27
.equ ADC_PIN2, 28

// definiciones PWM
.equ PWM_PIN1, 8
.equ PWM_PIN2, 9

// leds GPIO
.equ LED_PIN2, 19
.equ LED_PIN1, 18

.equ TIME_DELAY, 0x123A96
.equ gap_dir, 100

//#define ADC_MIN  1000

.global main_asm
main_asm:
    BL setUp
    B loop

setUp:
    PUSH    {LR}
    BL      stdio_init_all

    //CONFIGURAR GPIOS
    MOV R0, #LED_PIN1
    BL  gpio_init_asm
    MOV R0, #LED_PIN2
    BL  gpio_init_asm

    //ASIGNAR GPIOS COMO SALIDAS
    MOV R0, #LED_PIN1
    MOV R1, #1
    BL  gpio_set_dir_asm

    MOV R0, #LED_PIN2
    MOV R1, #1
    BL  gpio_set_dir_asm

    //CONFIGURAR PWM
    MOV R0, #PWM_PIN1
    BL  pwm_init_asm
    MOV R0, #PWM_PIN2
    BL  pwm_init_asm

    BL  pwm_config_asm

	//CONFIGURAR ADC
    MOV R0, #ADC_PIN1
    BL  adc_init_asm
    MOV R0, #ADC_PIN2
    BL  adc_init_asm

    POP {PC}

loop:
    // R4 - ADC_OUT 1, R5 - ADC_OUT 2
    MOV R0, #ADC_PIN1
    BL adc_read_asm
    MOV R4, R0

    MOV R0, #ADC_PIN2
    BL adc_read_asm
    MOV R5, R0

    //print msg adc
    MOV R0, R4
    MOV R1, R5
    MOV R2, #0
    BL uart_printMsg_asm

    //Mapeo del PWM
    // R4 - PWM2, R5 - PWM1
    MOV R0, R4
    BL Map
    MOV R4, R0

    MOV R0, R5
    BL Map
    MOV R5, R0
       

    //INICIALIZAR GPIOS PARA QUE SIEMPRE SEA UNO SOLO PRENDIDO
    MOV R0, #LED_PIN1
    MOV R1, #0
    BL gpio_put_asm

    MOV R0, #LED_PIN2
    MOV R1, #0
	BL gpio_put_asm

    // si la diferencia de pwm es mas grande que el gap, se prende el led
    MOV R6, #gap_dir
    
    MOV R0, #LED_PIN1
    SUB R1, R4, R5
    CMP R6, R1
    BGE on_led
    
    MOV R0, #LED_PIN2
    SUB R1, R5, R4
    CMP R6, R1
    BGE on_led

    B print_pwm

    on_led:
    BL gpio_put_asm

    print_pwm:
    //PRINT PWM
    MOV R0, R5 //PWM 1 -> R5
    MOV R1, R4 //PWM 2 -> R4
    MOV R2, #1
    BL uart_printMsg_asm

    //MOVER MOTORES
    MOV R0, R5
    BL Set_cycle_A_asm

    LDR R0, =(TIME_DELAY)
    BL delay_asm

    MOV R0, R4
    BL Set_cycle_B_asm  

    LDR R0, =(TIME_DELAY)
    BL delay_asm

    B loop