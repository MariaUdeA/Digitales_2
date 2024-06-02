#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/adc.h"
#include "main.h"

int main() {
	stdio_init_all();
	//inicializar el pwm
	pwm_init_asm(PWM_PIN);
	pwm_init_asm(PWM_PIN1);

	pwm_config_asm();
	while (1) {
		
		for (uint32_t i = 30; i < 900; i++)
		{
			Set_cycle_B_asm(i);
			Set_cycle_A_asm(i);
		}
		
		
	} 
	
}