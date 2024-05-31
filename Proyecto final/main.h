/**
 * @brief Main header file
*/

#ifndef MAIN_H
#define MAIN_H

//definitions
#define LED_PIN 16
#define LED_PIN2 17
#define FUNCSEL_SIO 5
#define TIME_DELAY 0x1523A96

// Funciones para el control de los gpio
void delay_asm(uint32_t);
void gpio_init_asm(uint32_t, uint32_t); 
void release_reset_IO_bank(uint32_t);
void gpio_set_dir_asm(uint32_t, bool);
void gpio_put_asm(uint32_t, bool);

// Funciones para el control del PWM
void pwm_config_asm();



#endif
