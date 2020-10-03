import common::*;

module computer (
	input logic clock,
	input logic resetN,
	input data_t port_in_00,
 	input data_t port_in_01,
 	input data_t port_in_02,
	input data_t port_in_03,
	input data_t port_in_04,
  input data_t port_in_05,
  input data_t port_in_06,
  input data_t port_in_07,
  input data_t port_in_08,
  input data_t port_in_09,
  input data_t port_in_10,
  input data_t port_in_11,
  input data_t port_in_12,
  input data_t port_in_13,
  input data_t port_in_14,
  input data_t port_in_15,
  output logic mce,
  output data_t port_out_00,
  output data_t port_out_01,
  output data_t port_out_02,
  output data_t port_out_03,
  output data_t port_out_04,
  output data_t port_out_05,
  output data_t port_out_06,
  output data_t port_out_07,
  output data_t port_out_08,
  output data_t port_out_09,
  output data_t port_out_10,
  output data_t port_out_11,
  output data_t port_out_12,
  output data_t port_out_13,
  output data_t port_out_14,
  output data_t port_out_15
);

	timeunit 1ns/1ps;

	address_t memory_address;
	data_t memory_in;
	data_t memory_out;
	logic memory_write;

	cpu cpu0 (
		.clock(clock),
		.resetN(resetN),
		.from_memory(memory_out),
		.address(memory_address),
		.write(memory_write),
		.to_memory(memory_in),
		.mce(mce)
	);

	memory memory0 (
		.clock(clock),
		.resetN(resetN),
		.address(memory_address),
		.write(memory_write),
		.data_in(memory_in),
		.port_in_00(port_in_00),
 		.port_in_01(port_in_01),
 		.port_in_02(port_in_02),
		.port_in_03(port_in_03),
		.port_in_04(port_in_04),
  	.port_in_05(port_in_05),
  	.port_in_06(port_in_06),
  	.port_in_07(port_in_07),
  	.port_in_08(port_in_08),
  	.port_in_09(port_in_09),
  	.port_in_10(port_in_10),
  	.port_in_11(port_in_11),
  	.port_in_12(port_in_12),
  	.port_in_13(port_in_13),
  	.port_in_14(port_in_14),
  	.port_in_15(port_in_15),
		.data_out(memory_out),
  	.port_out_00(port_out_00),
  	.port_out_01(port_out_01),
  	.port_out_02(port_out_02),
  	.port_out_03(port_out_03),
  	.port_out_04(port_out_04),
  	.port_out_05(port_out_05),
  	.port_out_06(port_out_06),
  	.port_out_07(port_out_07),
  	.port_out_08(port_out_08),
  	.port_out_09(port_out_09),
  	.port_out_10(port_out_10),
  	.port_out_11(port_out_11),
  	.port_out_12(port_out_12),
  	.port_out_13(port_out_13),
  	.port_out_14(port_out_14),
  	.port_out_15(port_out_15)
	);

endmodule
