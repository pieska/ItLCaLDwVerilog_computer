import common::*;

module control_unit (
	input logic clock,
	input logic resetN,
  input register_t IR,
  input ccr_t CCR_Result,
	output logic IR_Load,
  output logic MAR_Load,
  output logic PC_Load,
  output logic PC_Inc,
  output logic A_Load,
  output logic B_Load,
  output alu_op_t ALU_Sel,
  output logic CCR_Load,
  output logic [1:0] Bus2_Sel,
  output logic [1:0] Bus1_Sel,
  output logic write,
  output logic mce
);

	timeunit 1ns/1ps;

	typedef enum logic [6:0] {
		S_FETCH_0, S_FETCH_1, S_FETCH_2,
		S_DECODE_3,
		S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
		S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
		S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
		S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,										
		S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
		S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,										
		S_ADD_AB_4,
		S_SUB_AB_4,
		S_AND_AB_4,
		S_OR_AB_4,
		S_INCA_4,
		S_INCB_4,
		S_DECA_4,
		S_DECB_4, 
		S_BRA_4, S_BRA_5, S_BRA_6,
		S_BMI_4, S_BMI_5, S_BMI_6, S_BMI_7,
		S_BPL_4, S_BPL_5, S_BPL_6, S_BPL_7,
		S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7,
		S_BNE_4, S_BNE_5, S_BNE_6, S_BNE_7,
		S_BVS_4, S_BVS_5, S_BVS_6, S_BVS_7,
		S_BVC_4, S_BVC_5, S_BVC_6, S_BVC_7,
		S_BCS_4, S_BCS_5, S_BCS_6, S_BCS_7,
		S_BCC_4, S_BCC_5, S_BCC_6, S_BCC_7,
		S_BHI_4, S_BHI_5, S_BHI_6, S_BHI_7,
		S_BLS_4, S_BLS_5, S_BLS_6, S_BLS_7,
		S_BGE_4, S_BGE_5, S_BGE_6, S_BGE_7,
		S_BLT_4, S_BLT_5, S_BLT_6, S_BLT_7,
		S_BGT_4, S_BGT_5, S_BGT_6, S_BGT_7,
		S_BLE_4, S_BLE_5, S_BLE_6, S_BLE_7,
		S_MCE} state_t;

	state_t current_state = S_FETCH_0, next_state;

	always_ff @(posedge clock, negedge resetN) begin
		if(!resetN)
			current_state <= S_FETCH_0;
		else
			current_state <= next_state;
	end


	always_comb begin
	
		unique case(current_state)
			S_FETCH_0		: next_state = S_FETCH_1;
			S_FETCH_1		: next_state = S_FETCH_2;
			S_FETCH_2		: next_state = S_DECODE_3;
			S_DECODE_3	: case(IR)
											OPC_LDA_IMM	: next_state = S_LDA_IMM_4;
											OPC_LDA_DIR	:	next_state = S_LDA_DIR_4;
											OPC_LDB_IMM	:	next_state = S_LDB_IMM_4;
											OPC_LDB_DIR	: next_state = S_LDB_DIR_4;
											OPC_STA_DIR	: next_state = S_STA_DIR_4;
											OPC_STB_DIR	: next_state = S_STB_DIR_4;
											OPC_ADD_AB	:	next_state = S_ADD_AB_4;
											OPC_SUB_AB	: next_state = S_SUB_AB_4;
											OPC_AND_AB	: next_state = S_AND_AB_4;
											OPC_OR_AB		: next_state = S_OR_AB_4;
											OPC_INCA		: next_state = S_INCA_4;
											OPC_INCB		: next_state = S_INCB_4;
											OPC_DECA		:	next_state = S_DECA_4;
											OPC_DECB		:	next_state = S_DECB_4;
											OPC_BRA			: next_state = S_BRA_4;
											OPC_BMI			: next_state = CCR_Result[3] ? S_BMI_4 : S_BMI_7;
											OPC_BPL			: next_state = CCR_Result[3] ? S_BPL_7 : S_BPL_4;
											OPC_BEQ			: next_state = CCR_Result[2] ? S_BEQ_4 : S_BEQ_7;
											OPC_BNE			: next_state = CCR_Result[2] ? S_BEQ_7 : S_BEQ_4;
											OPC_BVS			: next_state = CCR_Result[1] ? S_BVS_4 : S_BVS_7;
											OPC_BVC			: next_state = CCR_Result[1] ? S_BVC_7 : S_BVC_4;
											OPC_BCS			: next_state = CCR_Result[0] ? S_BCS_4 : S_BCS_7;
											OPC_BCC			: next_state = CCR_Result[0] ? S_BCC_7 : S_BCC_4;
											OPC_BHI			: next_state = ({CCR_Result[2],CCR_Result[0]} == 2'b01) ? S_BHI_4 : S_BHI_7;
											OPC_BLS			: next_state = ({CCR_Result[2],CCR_Result[0]} == 2'b10) ? S_BLS_4 : S_BLS_7;
											OPC_BGE			: next_state = (({CCR_Result[3],CCR_Result[1]} == 2'b00) ||
																									({CCR_Result[3],CCR_Result[1]} == 2'b11)) ? S_BGE_4 : S_BGE_7;
											OPC_BLT			: next_state = (({CCR_Result[3],CCR_Result[1]} == 2'b10) ||
																									({CCR_Result[3],CCR_Result[1]} == 2'b01)) ? S_BLT_4 : S_BLT_7;
											OPC_BGT			: next_state = ((CCR_Result[3:1] == 3'b000) ||
																									(CCR_Result[3:1] == 3'b101)) ? S_BGT_4 : S_BGT_7;
											OPC_BLE			: next_state = (({CCR_Result[3],CCR_Result[1]} == 2'b10) ||
																									({CCR_Result[3],CCR_Result[1]} == 2'b01) ||
																										CCR_Result[2]) ? S_BLE_4 : S_BLE_7;						
																									
											default			: next_state = S_MCE;	// invalid OPC stops FSM
										endcase
			// LDA_IMM
			S_LDA_IMM_4	: next_state = S_LDA_IMM_5;
			S_LDA_IMM_5	: next_state = S_LDA_IMM_6;
			S_LDA_IMM_6 : next_state = S_FETCH_0;
			// LDA_DIR
			S_LDA_DIR_4	: next_state = S_LDA_DIR_5;
			S_LDA_DIR_5	: next_state = S_LDA_DIR_6;
			S_LDA_DIR_6	: next_state = S_LDA_DIR_7;
			S_LDA_DIR_7	: next_state = S_LDA_DIR_8;
			S_LDA_DIR_8 : next_state = S_FETCH_0;
			// LDB_IMM
			S_LDB_IMM_4	: next_state = S_LDB_IMM_5;
			S_LDB_IMM_5	: next_state = S_LDB_IMM_6;
			S_LDB_IMM_6	: next_state = S_FETCH_0;
			// LDB_DIR
			S_LDB_DIR_4	: next_state = S_LDB_DIR_5;
			S_LDB_DIR_5	: next_state = S_LDB_DIR_6;
			S_LDB_DIR_6	: next_state = S_LDB_DIR_7;
			S_LDB_DIR_7	: next_state = S_LDB_DIR_8;
			S_LDB_DIR_8	: next_state = S_FETCH_0;
			// STA_DIR
			S_STA_DIR_4	: next_state = S_STA_DIR_5;
			S_STA_DIR_5	: next_state = S_STA_DIR_6;
			S_STA_DIR_6	: next_state = S_STA_DIR_7;
			S_STA_DIR_7	: next_state = S_FETCH_0;
			// STB_DIR
			S_STB_DIR_4	: next_state = S_STB_DIR_5;
			S_STB_DIR_5	: next_state = S_STB_DIR_6;
			S_STB_DIR_6	: next_state = S_STB_DIR_7;
			S_STB_DIR_7	: next_state = S_FETCH_0;
			// ADD_AB
			S_ADD_AB_4	: next_state = S_FETCH_0;
			// SUB_AB
			S_SUB_AB_4	: next_state = S_FETCH_0;
			// AND_AB
			S_AND_AB_4	: next_state = S_FETCH_0;
			// OR_AB
			S_OR_AB_4		: next_state = S_FETCH_0;
			// INCA
			S_INCA_4		: next_state = S_FETCH_0;
			// INCB
			S_INCB_4		: next_state = S_FETCH_0;
			// DECA
			S_DECA_4		: next_state = S_FETCH_0;
			// DECB
			S_DECB_4		: next_state = S_FETCH_0;
			// BRA
			S_BRA_4			: next_state = S_BRA_5;
			S_BRA_5			: next_state = S_BRA_6;
			S_BRA_6			: next_state = S_FETCH_0;
			// BMI
			S_BMI_4			: next_state = S_BMI_5;
			S_BMI_5			: next_state = S_BMI_6;
			S_BMI_6,
			S_BMI_7			: next_state = S_FETCH_0;
			// BPL
			S_BPL_4			: next_state = S_BPL_5;
			S_BPL_5			: next_state = S_BPL_6;
			S_BPL_6,
			S_BPL_7			: next_state = S_FETCH_0;
			// BEQ
			S_BEQ_4			: next_state = S_BEQ_5;
			S_BEQ_5			: next_state = S_BEQ_6;
			S_BEQ_6,
			S_BEQ_7			: next_state = S_FETCH_0;
			// BNE
			S_BNE_4			: next_state = S_BNE_5;
			S_BNE_5			: next_state = S_BNE_6;
			S_BNE_6,
			S_BNE_7			: next_state = S_FETCH_0;
			// BVS
			S_BVS_4			: next_state = S_BVS_5;
			S_BVS_5			: next_state = S_BVS_6;
			S_BVS_6,
			S_BVS_7			: next_state = S_FETCH_0;
			// BVC
			S_BVC_4			: next_state = S_BVC_5;
			S_BVC_5			: next_state = S_BVC_6;
			S_BVC_6,
			S_BVC_7			: next_state = S_FETCH_0;
			// BCS
			S_BCS_4			: next_state = S_BCS_5;
			S_BCS_5			: next_state = S_BCS_6;
			S_BCS_6,
			S_BCS_7			: next_state = S_FETCH_0;
			// BVC
			S_BCC_4			: next_state = S_BVC_5;
			S_BCC_5			: next_state = S_BCC_6;
			S_BCC_6,
			S_BCC_7			: next_state = S_FETCH_0;
			// BHI
			S_BHI_4			: next_state = S_BHI_5;
			S_BHI_5			: next_state = S_BHI_6;
			S_BHI_6,
			S_BHI_7			: next_state = S_FETCH_0;
			// BLS
			S_BLS_4			: next_state = S_BLS_5;
			S_BLS_5			: next_state = S_BLS_6;
			S_BLS_6,
			S_BLS_7			: next_state = S_FETCH_0;
			// BGE
			S_BGE_4			: next_state = S_BGE_5;
			S_BGE_5			: next_state = S_BGE_6;
			S_BGE_6,
			S_BGE_7			: next_state = S_FETCH_0;
			// BLT
			S_BLT_4			: next_state = S_BLT_5;
			S_BLT_5			: next_state = S_BLT_6;
			S_BLT_6,
			S_BLT_7			: next_state = S_FETCH_0;
			// BGT
			S_BGT_4			: next_state = S_BGT_5;
			S_BGT_5			: next_state = S_BGT_6;
			S_BGT_6,
			S_BGT_7			: next_state = S_FETCH_0;
			// BLE
			S_BLE_4			: next_state = S_BLE_5;
			S_BLE_5			: next_state = S_BLE_6;
			S_BLE_6,
			S_BLE_7			: next_state = S_FETCH_0;
			// something went wrong
			S_MCE				: next_state = S_MCE;
		endcase

	end


	always_comb begin

		// defaults
		IR_Load = 1'b0;
		MAR_Load = 1'b0;
		PC_Load = 1'b0;
		PC_Inc = 1'b0;
		A_Load = 1'b0;
		B_Load = 1'b0;
		ALU_Sel = ALU_OP_NUL;
		CCR_Load = 1'b0;
		Bus1_Sel = 2'b00;				// 00 PC, 01 A, 10 B
		Bus2_Sel = 2'b00;				// 00 ALU_Result, 01 Bus1, 10 from_memory
		write = 1'b0;
		mce = 1'b0;

		unique case(current_state)
			S_FETCH_0		: begin									// Put PC onto MAR to read Opcode
											MAR_Load = 1'b1;
											Bus2_Sel = 2'b01;		//00 ALU_Result, 01 Bus1, 10 from_memory
										end
									
			S_FETCH_1		:	PC_Inc = 1'b1;	 			// Increment PC
			
			S_FETCH_2		: begin									// Load Opcode in IR
											IR_Load = 1'b1;
											Bus2_Sel = 2'b10;		//00 ALU_Result, 01 Bus1, 10 from_memory
										end
										
			S_DECODE_3	: ;											// NULL
									
			S_LDA_IMM_4,
			S_LDA_DIR_4,
			S_LDB_IMM_4,
			S_LDB_DIR_4,
			S_STA_DIR_4,
			S_STB_DIR_4,
			S_BRA_4,
			S_BMI_4,
			S_BPL_4,
			S_BEQ_4,
			S_BNE_4,
			S_BVS_4,
			S_BVC_4,
			S_BCS_4,
			S_BCC_4,
			S_BHI_4,
			S_BLS_4,
			S_BGE_4,
			S_BLT_4,
			S_BGT_4,
			S_BLE_4			: begin
											MAR_Load = 1'b1;
											Bus2_Sel = 1'b01;		// 00 ALU_Result, 01 Bus1, 10 from_memory
										end
									
			S_ADD_AB_4,
			S_SUB_AB_4,
			S_AND_AB_4,
			S_OR_AB_4,
			S_INCA_4,
			S_INCB_4,
			S_DECA_4,
			S_DECB_4		: begin
											Bus2_Sel = 2'b00;		// 00 ALU_Result, 01 Bus1, 10 from_memory
											unique case(current_state)
												S_ADD_AB_4	: begin
																				ALU_Sel = ALU_OP_ADD;
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_SUB_AB_4	: begin
																				ALU_Sel = ALU_OP_SUB;
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_AND_AB_4	: begin
																				ALU_Sel = ALU_OP_AND;						
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_OR_AB_4		: begin
																				ALU_Sel = ALU_OP_OR;						
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_INCA_4		: begin
																				ALU_Sel = ALU_OP_INC;						
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_DECA_4		: begin
																				ALU_Sel = ALU_OP_DEC;						
																				Bus1_Sel = 2'b01;				// 00 PC, 01 A, 10 B
																				A_Load = 1'b1;
																			end
												S_INCB_4		: begin
																				ALU_Sel = ALU_OP_INC;						
																				Bus1_Sel = 2'b10;				// 00 PC, 01 A, 10 B
																				B_Load = 1'b1;
																			end
												S_DECB_4		: begin
																				ALU_Sel = ALU_OP_DEC;						
																				Bus1_Sel = 2'b10;				// 00 PC, 01 A, 10 B
																				B_Load = 1'b1;
																			end
												default 		: ALU_Sel = ALU_OP_ERR;
											endcase
											CCR_Load = 1'b1;
										end

			S_LDA_IMM_5,
			S_LDA_DIR_5,
			S_LDB_IMM_5,
			S_LDB_DIR_5,
			S_STA_DIR_5,
			S_STB_DIR_5	: PC_Inc = 1'b1;
				
			S_BRA_5,
			S_BMI_5,
			S_BPL_5,
			S_BEQ_5,
			S_BNE_5,
			S_BVS_5,
			S_BVC_5,
			S_BCS_5,
			S_BCC_5,
			S_BHI_5,
			S_BLS_5,
			S_BGE_5,
			S_BLT_5,
			S_BGT_5,
			S_BLE_5			: ;											// NULL

			S_LDA_IMM_6	: begin
											A_Load = 1'b1;
											Bus2_Sel = 2'b10;		// 00 ALU_Result, 01 Bus1, 10 from_memory
										end

			S_LDB_IMM_6	: begin
											B_Load = 1'b1;
											Bus2_Sel = 2'b10;		// 00 ALU_Result, 01 Bus1, 10 from_memory
										end
						
			S_LDA_DIR_6,
			S_LDB_DIR_6,
			S_STA_DIR_6,
			S_STB_DIR_6	: begin
											MAR_Load = 1'b1;
											Bus2_Sel = 2'b10;		// 00 ALU_Result, 01 Bus1, 10 from_memory	
										end

			S_BRA_6,
			S_BMI_6,
			S_BPL_6,
			S_BEQ_6,
			S_BNE_6,
			S_BVS_6,
			S_BVC_6,
			S_BCS_6,
			S_BCC_6,
			S_BHI_6,
			S_BLS_6,
			S_BGE_6,
			S_BLT_6,
			S_BGT_6,
			S_BLE_6			: begin
											PC_Load = 1'b1;
											Bus2_Sel = 2'b10;		// 00 ALU_Result, 01 Bus1, 10 from_memory	
										end

			S_LDA_DIR_7,
			S_LDB_DIR_7	: ;											// NULL

			S_STA_DIR_7		: begin
												Bus1_Sel = 2'b01;	// 00 PC, 01 A, 10 B
												write = 1'b1;
											end
				
			S_STB_DIR_7		: begin
												Bus1_Sel = 2'b10;	// 00 PC, 01 A, 10 B
												write = 1'b1;
											end
			
			S_BMI_7,
			S_BPL_7,
			S_BEQ_7,
			S_BNE_7,
			S_BVS_7,
			S_BVC_7,
			S_BCS_7,
			S_BCC_7,
			S_BHI_7,
			S_BLS_7,
			S_BGE_7,
			S_BLT_7,
			S_BGT_7,
			S_BLE_7				: PC_Inc = 1'b1;
				
			S_LDA_DIR_8		: begin
												A_Load = 1'b1;
												Bus2_Sel = 2'b10;	// 00 ALU_Result, 01 Bus1, 10 from_memory
											end

			S_LDB_DIR_8		: begin
												B_Load = 1'b1;
												Bus2_Sel = 2'b10;	// 00 ALU_Result, 01 Bus1, 10 from_memory
											end

			// assert mce if something went wrong
			S_MCE					: mce = 1'b1;
		endcase

	end

endmodule
