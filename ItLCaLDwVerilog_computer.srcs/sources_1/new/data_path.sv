import common::*;

module data_path (
	input logic clock,
	input logic	reset,
	input logic IR_Load,
	input logic MAR_Load,
	input logic PC_Load,
	input logic	PC_Inc,
	input logic A_Load,
	input logic B_Load,
	input alu_op_t ALU_Sel,
	input logic CCR_Load,
	input logic[1:0] Bus2_Sel,
	input logic[1:0] Bus1_Sel,
	input data_t from_memory,
	output register_t IR,
	output address_t address,
	output ccr_t CCR_Result,
	output data_t to_memory
);

	timeunit 1ns/1ps;

	ccr_t CCR;
	data_t ALU_Result;
	ccr_t NZVC;

	data_t BUS2;
	data_t BUS1;
	register_t IReg;
	register_t MAReg;
	register_t PC;
	register_t A;
	register_t B;

	alu alu0 (
		.A(BUS1),		// im buch ist A und B vertauscht
		.B(B),			// im buch ist A und B vertauscht
		.ALU_Sel(ALU_Sel),
		.NZVC(NZVC),
		.ALU_Result(ALU_Result)
	);

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			IReg <= 'b0;
		else if(IR_Load)
			IReg <= BUS2;
	end

	assign IR = IReg;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			MAReg <= 'b0;
		else if(MAR_Load)
			MAReg <= BUS2;
	end

	assign address = MAReg;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			PC <= 'b0;
		else if(PC_Load)
			PC <= BUS2;
		else if(PC_Inc)
			PC <= PC + 1;	// im buch PC <= MAR + 1
	end

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			A <= 'b0;
		else if(A_Load)
			A <= BUS2;
	end

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			B <= 'b0;
		else if(B_Load)
			B <= BUS2;
	end

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			CCR <= 'b0;
		else if(CCR_Load)
			CCR <= NZVC;
	end

	assign CCR_Result = CCR;

	always_comb begin
		case(Bus2_Sel)
			2'b00		: BUS2 = ALU_Result;
			2'b01		: BUS2 = BUS1;
			2'b10		: BUS2 = from_memory;
			default	: BUS2 = 'bX;
		endcase
	end

	always_comb begin
		case(Bus1_Sel)
			2'b00		: BUS1 = PC;
			2'b01		: BUS1 = A;
			2'b10		: BUS1 = B;
			default	: BUS1 = 'bX;
		endcase
	end

	assign to_memory = BUS1;

endmodule
