import common::*;

module cpu (
	input logic clock,
	input logic resetN,
	input data_t from_memory,
	output address_t address,
	output logic write,
	output data_t to_memory,
	output logic mce
);

	timeunit 1ns/1ps;

	logic IR_Load;
	register_t IR;
	logic MAR_Load;
	logic PC_Load;
	logic PC_Inc;
	logic A_Load;
	logic B_Load;
	alu_op_t ALU_Sel;
	ccr_t CCR_Result;
	logic CCR_Load;
	logic [1:0] Bus2_Sel;
	logic [1:0] Bus1_Sel;


	control_unit control_unit0 (
		.clock(clock),
		.resetN(resetN),
  	.IR(IR),
  	.CCR_Result(CCR_Result),
		.IR_Load(IR_Load),
  	.MAR_Load(MAR_Load),
  	.PC_Load(PC_Load),
  	.PC_Inc(PC_Inc),
  	.A_Load(A_Load),
  	.B_Load(B_Load),
  	.ALU_Sel(ALU_Sel),
  	.CCR_Load(CCR_Load),
  	.Bus2_Sel(Bus2_Sel),
  	.Bus1_Sel(Bus1_Sel),
  	.write(write),
  	.mce(mce)
  );

	data_path data_path0 (
		.clock(clock),
		.resetN(resetN),
		.IR_Load(IR_Load),
		.MAR_Load(MAR_Load),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.A_Load(A_Load),
		.B_Load(B_Load),
		.ALU_Sel(ALU_Sel),
		.CCR_Load(CCR_Load),
		.Bus2_Sel(Bus2_Sel),
		.Bus1_Sel(Bus1_Sel),
		.from_memory(from_memory),
		.IR(IR),
		.address(address),
		.CCR_Result(CCR_Result),
		.to_memory(to_memory)
	);

endmodule
