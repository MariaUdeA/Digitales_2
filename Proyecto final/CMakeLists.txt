cmake_minimum_required(VERSION 3.13)

# Always include it
include(pico_sdk_import.cmake)

# Project's name (Replace my_DE3_Project with your own project's name)
project(Proyecto_final  C CXX ASM
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(PICO_BOARD "PICO")

# Desomentar para la board de Maria
# set(PICO_BOARD pico_w)

# SDK Initialization - Mandatory
pico_sdk_init()

# C/C++ project files
add_executable(Proyecto_final
    main.c
    gpio.s
    pwm.s
    uart.s
    adc.s
)

# pico_stdlib library. You can add more if they are needed
target_link_libraries(Proyecto_final 
            pico_stdlib
            hardware_adc
            )

# Enable usb output, disable uart output
pico_enable_stdio_usb(Proyecto_final 1)
pico_enable_stdio_uart(Proyecto_final 0)

# Need to generate UF2 file for upload to RP2040
pico_add_extra_outputs(Proyecto_final)