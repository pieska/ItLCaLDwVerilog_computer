import common::*;

module control_unit_tb;

	timeunit 1ns/1ps;

	logic clock_tb;
	logic reset_tb;
  register_t IR_tb;
  ccr_t CCR_Result_tb;
	logic IR_Load_tb;
  logic MAR_Load_tb;
  logic PC_Load_tb;
  logic PC_Inc_tb;
  logic A_Load_tb;
  logic B_Load_tb;
  alu_op_t ALU_Sel_tb;
  logic CCR_Load_tb;
  logic[1:0] Bus2_Sel_tb;
  logic[1:0] Bus1_Sel_tb;
  logic write_tb;
  logic mce_tb;

	control_unit uut (
		.clock(clock_tb),
		.reset(reset_tb),
  	.IR(IR_tb),
  	.CCR_Result(CCR_Result_tb),
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
  	.write(write_tb),
  	.mce(mce_tb)
  );

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
	
		clock_tb = 1'b0;
		reset_tb = 1'b0;
		IR_tb = 'b0;
		CCR_Result_tb = 'b0;

		#3

		reset_tb = 1'b1;
		
		// TODO: nothing to test?
		
		#3
		
		$finish;

	end
	
endmodule
