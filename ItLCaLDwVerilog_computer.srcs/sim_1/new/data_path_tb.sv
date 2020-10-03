import common::*;

module data_path_tb;

	timeunit 1ns/1ps;

	logic clock_tb;
	logic resetN_tb;
	logic IR_Load_tb;
	register_t IR_tb;
	logic MAR_Load_tb;
	address_t address_tb;
	logic PC_Load_tb;
	logic PC_Inc_tb;
	logic A_Load_tb;
	logic B_Load_tb;
	alu_op_t ALU_Sel_tb;
	ccr_t CCR_Result_tb;
	logic CCR_Load_tb;
	logic [1:0] Bus2_Sel_tb;
	logic [1:0] Bus1_Sel_tb;
	data_t from_memory_tb;
	data_t to_memory_tb;

	data_path uut (
		.clock(clock_tb),
		.resetN(resetN_tb),
		.IR_Load(IR_Load_tb),
		.MAR_Load(MAR_Load_tb),
		.PC_Load(PC_Load_tb),
		.PC_Inc(PC_Inc_tb),
		.A_Load(A_Load_tb),
		.B_Load(B_Load_tb),
		.ALU_Sel(ALU_Sel_tb),
		.CCR_Load(CCR_Load_tb),
		.Bus2_Sel(Bus2_Sel_tb),
		.Bus1_Sel(Bus1_Sel_tb),
		.from_memory(from_memory_tb),
		.IR(IR_tb),
		.address(address_tb),
		.CCR_Result(CCR_Result_tb),
		.to_memory(to_memory_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
	
		clock_tb = 1'b0;
		resetN_tb = 1'b0;
		IR_Load_tb = 1'b0;
		MAR_Load_tb = 1'b0;
		PC_Load_tb = 1'b0;
		PC_Inc_tb = 1'b0;
		A_Load_tb = 1'b0;
		B_Load_tb = 1'b0;
		ALU_Sel_tb = ALU_OP_NUL;
		CCR_Load_tb = 1'b0;
		Bus2_Sel_tb = 2'b00;
		Bus1_Sel_tb = 2'b00;

		#3

		resetN_tb = 1'b1;
		
		// put x55 in BUS2 to be read from registers
		from_memory_tb = 8'h55;
		Bus2_Sel_tb = 2'b10;
		#clockperiod

		/*
		** we check the muxes too, so instead of checking regs we check signals on busses
		*/

		// IR
		assert(IR_tb == 8'h00) else $error("IR Reset failed");	// IR == IReg

		IR_Load_tb = 1'b1;
		#clockperiod
		IR_Load_tb = 1'b0;

		assert(IR_tb == 8'h55) else $error("IR Load failed");

		// MAR
		assert(address_tb == 8'h00) else $error("MAR Reset failed");	// MAR == address

		MAR_Load_tb = 1'b1;
		#clockperiod
		MAR_Load_tb = 1'b0;

		assert(address_tb == 8'h55) else $error("MAR Load failed");

		// PC
		Bus1_Sel_tb = 2'b00;
		#clockperiod
		assert(uut.BUS1 == 8'h00) else $error("PC Reset failed");	// BUS1 == PC

		PC_Load_tb = 1'b1;
		#clockperiod
		PC_Load_tb = 1'b0;

		assert(uut.BUS1 == 8'h55) else $error("PC Load failed");

		PC_Inc_tb = 1'b1;
		#clockperiod
		PC_Inc_tb = 1'b0;

		assert(uut.BUS1 == 8'h56) else $error("PC Inc failed");

		// A
		Bus1_Sel_tb = 2'b01;
		#clockperiod
		assert(uut.BUS1 == 8'h00) else $error("A Reset failed");	// BUS1 == A

		A_Load_tb = 1'b1;
		#clockperiod
		A_Load_tb = 1'b0;

		assert(uut.BUS1 == 8'h55) else $error("A Load failed");

		// B
		Bus1_Sel_tb = 2'b10;
		#clockperiod
		assert(uut.BUS1 == 8'h00) else $error("B Reset failed");	// BUS1 == B

		B_Load_tb = 1'b1;
		#clockperiod
		B_Load_tb = 1'b0;

		assert(uut.BUS1 == 8'h55) else $error("B Load failed");

		// ALU
		ALU_Sel_tb = ALU_OP_SUB;	// A (55) - B (55) == 00 NZVC(0100)
		Bus2_Sel_tb = 2'b00;			// put ALU_result on BUS2
		#clockperiod

		assert(uut.BUS2 == 8'h00) else $error("ALU Sub failed");
	
		// CCR
		assert(CCR_Result_tb == 4'b0000) else $error("CCR Reset failed");

		CCR_Load_tb = 1'b1;
		#clockperiod
		CCR_Load_tb = 1'b0;

		assert(CCR_Result_tb == 4'b0100) else $error("CCR Load failed");

		#3
				
		$finish;

	end
	
endmodule
