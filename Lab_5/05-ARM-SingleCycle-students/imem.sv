/*
 * This module is the Instruction Memory of the ARM single-cycle processor
 */ 
module imem(input logic [31:0] a, output logic [31:0] rd);
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[255:0];

	// The following line loads the program instruction
	// Be careful to have a program longer than the memory available
	initial
		// Uncomment the following line only if you want to load the code given to check peripherals
		$readmemh(""C:/Users/julia/Desktop/Universidad/Electronica Digital 2/Laboratorio/Lab_5/05-ARM-SingleCycle-students/imem_to_test_peripherals.dat",RAM);

		// Uncomment the following line only if you want to load the code made by your group
		//Julian:
		//$readmemh("C:/Users/julia/Desktop/Universidad/Electronica Digital 2/Laboratorio/Lab_5/05-ARM-SingleCycle-students/imem_made_by_students.dat",RAM);
		//Maria: 
		//$readmemh("C:/Users/Compu de Maria/Desktop/UdeA/semestre6/digi2/Digitales_2/Lab_5/05-ARM-SingleCycle-students/imem_made_by_students.dat",RAM);

		
		//$readmemh("F:/Digitales 2/2024-1/Laboratorio/Laboratorio 5/Proyecto5_final/imems/imem_made_by_students.dat",RAM);

	assign rd = RAM[a[31:2]]; // word aligned
endmodule