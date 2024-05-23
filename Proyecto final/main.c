/**
 * @file main.c
 * @brief This is a brief description of the main C file.
 *
 * Detailed description of the main C file.
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"

// Include your own header files here

/**
 * @brief Main program.
 *
 * This function initializes the MCU and does an infinite cycle.
 */
int main() {
	// STDIO initialization
    stdio_init_all();
	
	// Write your initialization code here
	
	// Infinite loop. This function shouldn't finish or return
    while (1) {
        // Write your code here
        sleep_ms(1000);
    }
	
    return 0;
}