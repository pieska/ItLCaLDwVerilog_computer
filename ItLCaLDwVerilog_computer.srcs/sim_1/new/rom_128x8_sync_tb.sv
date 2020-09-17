import common::*;

module rom_128x8_sync_tb;

	timeunit 1ns/1ps;

	logic clock_tb;
	address_t address_tb;
	data_t data_out_tb;

	defparam uut.romfile = "rom_128x8_sync_tb.mem";

	rom_128x8_sync uut (
		.clock(clock_tb),
		.address(address_tb),
		.data_out(data_out_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
	
		clock_tb = 1'b0;
		#3;
		
		address_tb = 8'h00;
		#clockperiod;
		assert(data_out_tb == OPC_LDA_IMM) else $error("@0 not LDA_IMM");
		#clockperiod;

		address_tb = 8'h7F;
		#clockperiod;
		assert(data_out_tb == 8'h00) else $error("@7f not 0");
		#clockperiod;

		address_tb = 8'h01;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("@1 not AA");
		#clockperiod;

		// 80 is oob, data_out_tb should not changed
		address_tb = 8'h80;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("@80 not AA");
		#clockperiod;

		#3 $finish;
	end
	
endmodule
