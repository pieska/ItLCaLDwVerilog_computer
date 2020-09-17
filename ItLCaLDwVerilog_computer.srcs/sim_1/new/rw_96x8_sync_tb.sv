import common::*;

module rw_96x8_sync_tb;

	timeunit 1ns/1ps;

	logic clock_tb;
	address_t address_tb;
	logic write_tb;
	data_t data_in_tb;
	data_t data_out_tb;

	rw_96x8_sync uut (
		.clock(clock_tb),
		.address(address_tb),
		.write(write_tb),
		.data_in(data_in_tb),
		.data_out(data_out_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
	
		clock_tb = 1'b0;
		#3;
		
		address_tb = 8'h80;
		data_in_tb = 8'h55;
		#clockperiod;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		#clockperiod;

		address_tb = 8'hDF;
		data_in_tb = 8'hAA;
		#clockperiod;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		#clockperiod;

		address_tb = 8'h80;
		#clockperiod;
		assert(data_out_tb == 8'h55) else $error("@80 not 55");
		#clockperiod;

		address_tb = 8'hDF;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("@DF not AA");
		#clockperiod;

		// 7f and E0 are oob, data_out_tb should not changed
		address_tb = 8'h7F;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("@7F not AA");
		#clockperiod;

		address_tb = 8'hE0;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("@E0 not AA");
		#clockperiod;

		#3

		$finish;

	end

endmodule
