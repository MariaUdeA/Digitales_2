#include <stdio.h>
#include "pico/stdlib.h"

#include "main.h"

int main() {
	printf("C1");
	stdio_init_all();
	printf(" C2");

	pwm_init_asm(PWM_PIN);

	adc_init_asm(ADC_PIN);
	printf("C3");
	//gpio_init_asm(LED_PIN);
	//gpio_init_asm(LED_PIN2);

	//gpio_set_dir_asm(LED_PIN, true);
	//gpio_set_dir_asm(LED_PIN2, true);

	//pwm_config_asm();

	while (1) {
		uint32_t out;
		out =adc_read_asm(ADC_PIN);
		printf("*** Value read from ADC channel 0: %d *** \n", out);
		delay_asm(TIME_DELAY);
		/*
		gpio_put_asm(LED_PIN, true);
		gpio_put_asm(LED_PIN2, false);
		uart_printMsg_asm(PWM_STATUS, PWM_STATUS);
		delay_asm(TIME_DELAY);
		
		gpio_put_asm(LED_PIN, false);
		gpio_put_asm(LED_PIN2, true);
		uart_printMsg_asm(PWM_STATUS,PWM_STATUS);
		delay_asm(TIME_DELAY);
		*/
	} 
	return 0;
}