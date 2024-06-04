/**
 * @brief Main header file
*/

#ifndef MAIN_H
#define MAIN_H

//definitions ADC
#define ADC_PIN 26

// definiciones PWM
#define PWM_PIN 8
#define PWM_PIN1 9
#define PWM_CH 4
#define duty_cycle  500

// Salidas digitales de los motores
#define PIN_IN1 10
#define PIN_IN2 11
#define PIN_IN3 12
#define PIN_IN4 13


// Definiciones genreales del programa
#define FUNCSEL_SIO 5
#define FUNCSEL_PWM 4
#define TIME_DELAY 0x123A96


// Funciones para el control de los gpio
void delay_asm(uint32_t);
void gpio_init_asm(uint32_t); 
void release_reset_IO_bank(uint32_t);
void gpio_set_dir_asm(uint32_t, bool);
void gpio_put_asm(uint32_t, bool);

// Funciones para el control del PWM
void pwm_config_asm();
void Set_cycle_A_asm(uint32_t);
void pwm_init_asm(uint32_t);
void Set_cycle_B_asm(uint32_t);

// Funciones para el control del ADC
void adc_init_asm(uint32_t);
uint32_t adc_read_asm(uint32_t);

// Funciones para el uso de UART
void uart_printMsg_asm(uint32_t, uint32_t);



#endif
