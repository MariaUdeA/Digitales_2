transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/julia/Desktop/Universidad/Electronica\ Digital\ 2/Laboratorio/Lab_2 {C:/Users/julia/Desktop/Universidad/Electronica Digital 2/Laboratorio/Lab_2/trafficlight.sv}
vlog -sv -work work +incdir+C:/Users/julia/Desktop/Universidad/Electronica\ Digital\ 2/Laboratorio/Lab_2 {C:/Users/julia/Desktop/Universidad/Electronica Digital 2/Laboratorio/Lab_2/deco7seg_hexa.sv}

