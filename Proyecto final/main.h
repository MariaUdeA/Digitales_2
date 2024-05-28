/**
 * @brief Main header file
*/

#ifndef MAIN_H
#define MAIN_H

//definitions
#define LED_PIN 25
#define LED_PIN2 17
#define TIME_DELAY 0x1523A96

void delay_asm(uint32_t);
void gpio_init_asm(uint32_t);
void release_reset_IO_bank(uint32_t);
void gpio_set_dir_asm(uint32_t, bool);
void gpio_put_asm(uint32_t, bool);


#endif
