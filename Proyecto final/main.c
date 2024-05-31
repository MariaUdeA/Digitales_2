#include <stdio.h>
#include "pico/stdlib.h"

#include "main.h"

int main() {
	stdio_init_all();

	pwm_config_asm();

	gpio_init_asm(LED_PIN, FUNCSEL_SIO);
	gpio_init_asm(LED_PIN2, FUNCSEL_SIO);

	gpio_set_dir_asm(LED_PIN, true);
	gpio_set_dir_asm(LED_PIN2, true);


	while (1) {
		gpio_put_asm(LED_PIN, true);
		gpio_put_asm(LED_PIN2, false);
		delay_asm(TIME_DELAY);
		gpio_put_asm(LED_PIN, false);
		gpio_put_asm(LED_PIN2, true);
		delay_asm(TIME_DELAY);
	} 
	
}