import common::*;

module cpu_tb;

	timeunit 1ns/1ps;

	localparam testfile = "cpu_tb.txt";

	logic clock_tb;
	logic resetN_tb;
	address_t address_tb;
	logic write_tb;
	data_t to_memory_tb;
	data_t from_memory_tb;
	logic mce_tb;

	cpu uut (
		.clock(clock_tb),
		.resetN(resetN_tb),
		.from_memory(from_memory_tb),
		.address(address_tb),
		.write(write_tb),
		.to_memory(to_memory_tb),
		.mce(mce_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial
	begin
	
		int unsigned fd;		// descriptor for testfile
 		string line; 	// string value read from testfile

		register_t IR_field;
		register_t MAR_field;
		register_t PC_field;
		register_t A_field;
		register_t B_field;
		logic write_field;
		data_t to_memory_field;
		ccr_t CCR_field;
		data_t from_memory_field;
		register_t WA_field;
		register_t WB_field;
		ccr_t WCCR_field;
		
		fd = $fopen (testfile, "r");
		
		if(!fd)
			$fatal(1, "Opening file '%s' for reading failed.", testfile);

		clock_tb = 1'b0;
		resetN_tb = 1'b0;
		from_memory_tb = 'b0;

		#3

		resetN_tb = 1'b1;

		// read line by line until EOF
    while($fgets(line, fd)) begin

 			// skip over empty lines and comments
      if(line.len() == 1 || line[0] == "#" )
      	continue;

			// if '.' reset
			if(line[0] == ".") begin
				resetN_tb = 1'b0;
				from_memory_tb = 1'b0;
				#clockperiod
				resetN_tb = 1'b1;
				continue;
			end

			// exit if line couln't parsed
      if( $sscanf(line, "%h %h %h %h %h %b %h %b %h %h %h %b",
      	IR_field, MAR_field, PC_field, A_field, B_field, write_field, to_memory_field, CCR_field, from_memory_field,
      	WA_field, WB_field, WCCR_field) != 12)
      	$fatal(1, "Line failed: %s", line);

			// first set values if not X
			if(from_memory_field !== 8'hXX)
				from_memory_tb = from_memory_field;

			if(WA_field !== 8'hXX)
				force uut.data_path0.A = WA_field;
			else
				release uut.data_path0.A;

			if(WB_field !== 8'hXX)
				force uut.data_path0.B = WB_field;
			else
				release uut.data_path0.B;

			if(WCCR_field !== 4'bXXXX)
				force uut.data_path0.CCR = WCCR_field;
			else
				release uut.data_path0.CCR;

			// check stage, we use 4-state-logic 
			#clockperiod;

			assert(uut.data_path0.IReg ==? IR_field) else $error("IR mismatch '%h' in line: %s", uut.data_path0.IReg, line);
			assert(uut.data_path0.MAReg ==? MAR_field) else $error("MAR mismatch '%h' in line: %s", uut.data_path0.MAReg, line);
			assert(uut.data_path0.PC ==? PC_field) else $error("PC mismatch '%h' in line: %s", uut.data_path0.PC, line);
			assert(uut.data_path0.A ==? A_field) else $error("A mismatch '%h' in line: %s", uut.data_path0.A, line);
			assert(uut.data_path0.B ==? B_field) else $error("B mismatch '%h' in line: %s", uut.data_path0.B, line);
			assert(write_tb ==? write_field) else $error("write mismatch '%h' in line: %s", write_tb, line);

			// check to_memory only on writes
			if(write_tb)
				assert(to_memory_tb ==? to_memory_field) else $error("to_memory mismatch '%h' in line: %s", to_memory_tb, line);

			assert(uut.control_unit0.CCR_Result ==? CCR_field) else $error("CCR_result mismatch '%h' in line: %s", uut.control_unit0.CCR_Result, line);

 		end

	 	$fclose(fd);
	
		// MCE Test
		resetN_tb = 1'b0;
		from_memory_tb = 1'b0;
		#clockperiod
		resetN_tb = 1'b1;
		// invalid
		from_memory_tb = 8'hFF;
		// fetch_0
		#clockperiod
		// fetch_1
		#clockperiod
		// fetch_2
		#clockperiod
		// decode_3
		#clockperiod
		assert(mce_tb == 1'b1) else $error("mce failed");

		#3
		
		$finish;

	end

endmodule
