import common::*;

module alu_tb;

	timeunit 1ns/1ps;

	localparam testfile = "alu_tb.txt";

	register_t A_tb;
	register_t B_tb;
	alu_op_t ALU_Sel_tb;
	ccr_t NZVC_tb;
	data_t ALU_Result_tb;

	alu uut (
		.A(A_tb),
		.B(B_tb),
		.ALU_Sel(ALU_Sel_tb),
		.NZVC(NZVC_tb),
		.ALU_Result(ALU_Result_tb)
	);

	initial begin
		int unsigned fd;		// descriptor for testfile
 		string line; 	// string value read from testfile

		string OP_field;
  	register_t A_field;
  	register_t B_field;
  	register_t Result_field;
  	ccr_t NZVC_field;
  
		fd = $fopen (testfile, "r");
		
		if(!fd)
			$fatal(1, "Opening file '%s' for reading failed.", testfile);

		// read line by line until EOF
    while($fgets(line, fd)) begin

 			// skip over empty lines and comments
      if(line.len() == 1 || line[0] == "#" )
      	continue;

			// exit if line couln't parsed
      if( $sscanf(line, "%s %d %d %d %b", OP_field, A_field, B_field, Result_field, NZVC_field) != 5)
      	$fatal(1, "Line failed: %s", line);
      
      // assign test vectors
      case (OP_field)
      	"ADD"	: ALU_Sel_tb = ALU_OP_ADD;
      	"SUB"	: ALU_Sel_tb = ALU_OP_SUB;
      	"AND"	: ALU_Sel_tb = ALU_OP_AND;
      	"OR"	: ALU_Sel_tb = ALU_OP_OR;
      	"INC"	: ALU_Sel_tb = ALU_OP_INC;
      	"DEC"	: ALU_Sel_tb = ALU_OP_DEC;
      	default : ALU_Sel_tb = ALU_OP_ERR;
      endcase
      
			A_tb = A_field;
			B_tb = B_field;

			// wait a clock cycle
			#clockperiod;
		
			// check values against test data and report mismatches, X and Z in RHS are treated as wildcards
			assert(ALU_Result_tb ==? Result_field) else $error("Result mismatch '%d' in line: %s", ALU_Result_tb, line);
 			assert(NZVC_tb ==? NZVC_field) else $error("NZVC mismatch '%b' in line: %s", NZVC_tb, line);

 		end

	 	$fclose(fd);
	 	
	 	#3 $finish;

   end
endmodule
