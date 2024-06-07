#include <stdio.h>
#include "pico/stdlib.h"
#include "main.h"

int main() {
	//setup
	printf("Setup: ");
	stdio_init_all();
	//configurar GPIOS
	gpio_init_asm(LED_PIN1);
	gpio_init_asm(LED_PIN2);
	//se asocian a salidas
	gpio_set_dir_asm(LED_PIN1,true);
	gpio_set_dir_asm(LED_PIN2,true);

	//configurar pwm
	pwm_init_asm(PWM_PIN1);
	pwm_init_asm(PWM_PIN2);

	//configurar adc
	adc_init_asm(ADC_PIN1);
	adc_init_asm(ADC_PIN2);

	//main (LOOP)
	while (1) {
		//Lectura de los ADC
		uint32_t out1, out2;
		out1 = adc_read_asm(ADC_PIN1);
		out2 = adc_read_asm(ADC_PIN2);

		uart_printMsg_asm(out1, out2, false);

		//criterio de movimiento de los pwm
		pwm2 = Map(out1);
		pwm1 = Map(out2);

		gpio_put_asm(LED_PIN1,false);
		gpio_put_asm(LED_PIN2,false);

		if (pwm2-pwm1>100){
			gpio_put_asm(LED_PIN1,true);
		}
		else if (pwm1-pwm2>100){
			gpio_put_asm(LED_PIN2,true);
		}
		uart_printMsg_asm(pwm1, pwm2, true);

		// mover motores
		Set_cycle_A_asm(pwm1);
		Set_cycle_B_asm(pwm2);
		//delay entre lecturas (se podría quitar, pero hay que ver)
		delay_asm(TIME_DELAY);
	} 
	return 0;
}