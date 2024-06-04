#include <stdio.h>
#include "pico/stdlib.h"
#include "main.h"

int main() {

	// Se inicializa el pwm 
	
	pwm_init_asm(PWM_PIN);
	pwm_init_asm(PWM_PIN1);
	

	// Declaración de los pines de salida digital
	gpio_init_asm(PIN_IN1);
	gpio_init_asm(PIN_IN2);
	gpio_init_asm(PIN_IN3);
	gpio_init_asm(PIN_IN4);

	// Dirección de los pines digitales salida
	gpio_set_dir_asm(PIN_IN1, true);
	gpio_set_dir_asm(PIN_IN2, true);
	gpio_set_dir_asm(PIN_IN3, true);
	gpio_set_dir_asm(PIN_IN4, true);

	// Salidas digitales

	gpio_put_asm(PIN_IN1, true);
	gpio_put_asm(PIN_IN2, false);
	gpio_put_asm(PIN_IN3, true);
	gpio_put_asm(PIN_IN4, false);

	// ciclo de dureza del pwm
	pwm_config_asm();
	pwm_config_asm();
	
	
	while (1) {
		Set_cycle_B_asm(duty_cycle);
		Set_cycle_A_asm(duty_cycle);
		delay_asm(TIME_DELAY);
	} 
	return 0;
}