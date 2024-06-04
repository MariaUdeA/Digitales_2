#include <stdio.h>
#include "pico/stdlib.h"
#include "main.h"

int main() {
	//setup
	printf("Setup: ");
	stdio_init_all();
	//configurar pwm
	pwm_init_asm(PWM_PIN1);
	pwm_init_asm(PWM_PIN2);
	printf("PWM done. ");
	//configurar adc
	adc_init_asm(ADC_PIN1);
	adc_init_asm(ADC_PIN2);
	printf("ADC done.\n");
	//Configurar uart (yay t-t)
	printf("UART done.\n");

	//main (LOOP)
	while (1) {
		//Lectura de los ADC
		uint32_t out1, out2;
		out1 = adc_read_asm(ADC_PIN1);
		out2 = adc_read_asm(ADC_PIN2);

		printf("*** Value read from ADC channel 0: %d *** \n", out1);
		printf("*** Value read from ADC channel 1: %d *** \n", out1);

		//criterio de movimiento de los pwm
		pwm2 = (MIN_PWM-MAX_PWM)/(MAX_ADC-MIN_ADC)*(out1-MIN_ADC)+MAX_PWM;
		pwm1 = (MIN_PWM-MAX_PWM)/(MAX_ADC-MIN_ADC)*(out1-MIN_ADC)+MAX_PWM;
		// mover motores
		Set_cycle_A_asm(pwm1);
		Set_cycle_B_asm(pwm2);
		//delay entre lecturas (se podría quitar, pero hay que ver)
		delay_asm(TIME_DELAY);
	} 
	return 0;
}