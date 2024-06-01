#include <stdio.h>
#include "pico/stdlib.h"

#include "main.h"

int main() {
	stdio_init_all();

	
	pwm_init_asm(PWM_PIN);

	gpio_init_asm(LED_PIN);
	gpio_init_asm(LED_PIN2);

	gpio_set_dir_asm(LED_PIN, true);
	gpio_set_dir_asm(LED_PIN2, true);

	pwm_config_asm();
	while (1) {
		gpio_put_asm(LED_PIN, true);
		gpio_put_asm(LED_PIN2, false);
		uart_printMsg_asm(PWM_STATUS, PWM_STATUS);
		delay_asm(TIME_DELAY);
		
		gpio_put_asm(LED_PIN, false);
		gpio_put_asm(LED_PIN2, true);
		uart_printMsg_asm(PWM_STATUS,PWM_STATUS);
		delay_asm(TIME_DELAY);
	} 
	
}