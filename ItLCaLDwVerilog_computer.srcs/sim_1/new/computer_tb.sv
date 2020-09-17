import common::*;

module computer_tb;

	timeunit 1ns/1ps;

	defparam uut.memory0.rom0.romfile = "rom_128x8_sync_tb.mem";

	logic clock_tb;
	logic reset_tb;
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
  logic mce_tb;
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
  
  computer uut (
		.clock(clock_tb),
		.reset(reset_tb),
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
  	.mce(mce_tb),
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

  	$monitor("%d PC %h IReg %h MAReg %h A %h B %h ALU_Result %h CC_Result %b from_memory %h to_memory %h write %b mce %b",
  		$stime, 
			uut.cpu0.data_path0.PC,
			uut.cpu0.data_path0.IReg,
			uut.cpu0.data_path0.MAReg,
			uut.cpu0.data_path0.A,
			uut.cpu0.data_path0.B,
			uut.cpu0.data_path0.ALU_Result,
			uut.cpu0.data_path0.CCR_Result,
			uut.cpu0.data_path0.from_memory,
			uut.cpu0.data_path0.to_memory,
			uut.cpu0.control_unit0.write,
			mce_tb);

		clock_tb = 1'b0;
		reset_tb = 1'b0;

		port_in_00_tb = 8'h00;
		port_in_01_tb = 8'h01;
		port_in_02_tb = 8'h02;
		port_in_03_tb = 8'h03;
		port_in_04_tb = 8'h04;
		port_in_05_tb = 8'h05;
		port_in_06_tb = 8'h06;
		port_in_07_tb = 8'h07;
		port_in_08_tb = 8'h08;
		port_in_09_tb = 8'h09;
		port_in_10_tb = 8'h0A;
		port_in_11_tb = 8'h0B;
		port_in_12_tb = 8'h0C;
		port_in_13_tb = 8'h0D;
		port_in_14_tb = 8'h0E;
		port_in_15_tb = 8'h0F;

		#3

		reset_tb = 1'b1;

		// wait until port is at FF
		wait(port_out_00_tb == 8'hFF || mce_tb == 1'b1);

		// 10 cycles more for mce to show up in monitor
		#10
		
		$finish;

	end

endmodule
