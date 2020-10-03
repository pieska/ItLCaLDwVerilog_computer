import common::*;

module memory_tb;

	timeunit 1ns/1ps;

	defparam uut.rom0.romfile = "rom_128x8_sync_tb.mem";

	logic clock_tb;
	logic resetN_tb;
	address_t address_tb;
	logic write_tb;
	data_t data_in_tb;
	data_t port_in_00_tb;
 	data_t port_in_01_tb;
 	data_t port_in_02_tb;
	data_t port_in_03_tb;
	data_t port_in_04_tb;
  data_t port_in_05_tb;
  data_t port_in_06_tb;
  data_t port_in_07_tb;
  data_t port_in_08_tb;
  data_t port_in_09_tb;
  data_t port_in_10_tb;
  data_t port_in_11_tb;
  data_t port_in_12_tb;
  data_t port_in_13_tb;
  data_t port_in_14_tb;
  data_t port_in_15_tb;
	data_t data_out_tb;
  data_t port_out_00_tb;
  data_t port_out_01_tb;
  data_t port_out_02_tb;
  data_t port_out_03_tb;
  data_t port_out_04_tb;
  data_t port_out_05_tb;
  data_t port_out_06_tb;
  data_t port_out_07_tb;
  data_t port_out_08_tb;
  data_t port_out_09_tb;
  data_t port_out_10_tb;
  data_t port_out_11_tb;
  data_t port_out_12_tb;
  data_t port_out_13_tb;
  data_t port_out_14_tb;
  data_t port_out_15_tb;

	memory uut (
		.clock(clock_tb),
		.resetN(resetN_tb),
		.address(address_tb),
		.write(write_tb),
		.data_in(data_in_tb),
		.port_in_00(port_in_00_tb),
 		.port_in_01(port_in_01_tb),
 		.port_in_02(port_in_02_tb),
		.port_in_03(port_in_03_tb),
		.port_in_04(port_in_04_tb),
  	.port_in_05(port_in_05_tb),
  	.port_in_06(port_in_06_tb),
  	.port_in_07(port_in_07_tb),
  	.port_in_08(port_in_08_tb),
  	.port_in_09(port_in_09_tb),
  	.port_in_10(port_in_10_tb),
  	.port_in_11(port_in_11_tb),
  	.port_in_12(port_in_12_tb),
  	.port_in_13(port_in_13_tb),
  	.port_in_14(port_in_14_tb),
  	.port_in_15(port_in_15_tb),
		.data_out(data_out_tb),
  	.port_out_00(port_out_00_tb),
  	.port_out_01(port_out_01_tb),
  	.port_out_02(port_out_02_tb),
  	.port_out_03(port_out_03_tb),
  	.port_out_04(port_out_04_tb),
  	.port_out_05(port_out_05_tb),
  	.port_out_06(port_out_06_tb),
  	.port_out_07(port_out_07_tb),
  	.port_out_08(port_out_08_tb),
  	.port_out_09(port_out_09_tb),
  	.port_out_10(port_out_10_tb),
  	.port_out_11(port_out_11_tb),
  	.port_out_12(port_out_12_tb),
  	.port_out_13(port_out_13_tb),
  	.port_out_14(port_out_14_tb),
  	.port_out_15(port_out_15_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
	
		clock_tb = 1'b0;
		resetN_tb = 1'b0;
		write_tb = 1'b0;
		
		#3;
	
		resetN_tb = 1'b1;
		
		// rom
		address_tb = 8'h00;
		#clockperiod;
		assert(data_out_tb == OPC_LDA_IMM) else $error("data_out not LDA_IMM");
		#clockperiod;

		address_tb = 8'h7F;
		#clockperiod;
		assert(data_out_tb == 8'h00) else $error("data_out not 0");
		#clockperiod;

		// ram
		address_tb = 8'h80;
		data_in_tb = 8'h55;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		#clockperiod;

		address_tb = 8'hDF;
		data_in_tb = 8'hAA;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		#clockperiod;

		address_tb = 8'h80;
		#clockperiod;
		assert(data_out_tb == 8'h55) else $error("data_out not 55");
		#clockperiod;

		address_tb = 8'hDF;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("data_out not AA");
		#clockperiod;

		// input ports, async
		address_tb = 8'hF0;
		port_in_00_tb = 8'h55;
		#clockperiod;
		assert(data_out_tb == 8'h55) else $error("data_out not 55");
		#clockperiod;

		address_tb = 8'hFF;
		port_in_15_tb = 8'hAA;
		#clockperiod;
		assert(data_out_tb == 8'hAA) else $error("data_out not AA");
		#clockperiod;
		
		// output ports
		address_tb = 8'hE0;
		data_in_tb = 8'h55;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		assert(port_out_00_tb == 8'h55) else $error("port_out_00 not 55");
		#clockperiod;

		address_tb = 8'hEF;
		data_in_tb = 8'hAA;
		write_tb = 1'b1;
		#clockperiod;
		write_tb = 1'b0;
		assert(port_out_15_tb == 8'hAA) else $error("port_out_15 not AA");
		#clockperiod;
		
		resetN_tb = 1'b0;
		#clockperiod;
		resetN_tb = 1'b1;
		assert(port_out_15_tb == 8'h00) else $error("port_out_15 not 00");
		#clockperiod;

		#3;

		$finish;

	end
	
endmodule