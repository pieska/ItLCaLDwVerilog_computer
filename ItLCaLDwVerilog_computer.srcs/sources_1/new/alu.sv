import common::*;

module alu (
	input register_t A,
	input register_t B,
	input alu_op_t ALU_Sel,
	output ccr_t NZVC,
	output data_t ALU_Result
);

	timeunit 1ns/1ps;

	always_comb begin
	
		automatic ccr_t NZVC_i = 'b0;

		case (ALU_Sel)
			ALU_OP_ADD,
			ALU_OP_SUB,
			ALU_OP_INC,
			ALU_OP_DEC	: begin
											case(ALU_Sel)
												ALU_OP_ADD	: {NZVC_i[0], ALU_Result} = A + B;
												ALU_OP_SUB	: {NZVC_i[0], ALU_Result} = A - B;
												ALU_OP_INC	: {NZVC_i[0], ALU_Result} = A + 1;
												ALU_OP_DEC	: {NZVC_i[0], ALU_Result} = A - 1;
												default 		: {NZVC_i[0], ALU_Result} = 'bX;
											endcase

											//-- Negative Flag
							        NZVC_i[3] = ALU_Result[7];
     							   //-- Two's Comp Overflow Flag
    							    NZVC_i[1] = (((A[7] == 0) && (B[7] == 0) && (ALU_Result[7] == 1)) ||
                  							   ((A[7] == 1) && (B[7] == 1) && (ALU_Result[7] == 0))) ? 1 : 0;
										end
			
			ALU_OP_AND	: ALU_Result = A & B;
				
			ALU_OP_OR		: ALU_Result = A | B; 
				
			// no valid alu op
			default			: begin
											ALU_Result = 'bX;
											NZVC_i = 'bX;
										end
			
		endcase

		//-- Zero Flag
		NZVC_i[2] = ALU_Result == 0 ? 1 : 0;

		NZVC = NZVC_i;

	end

endmodule
