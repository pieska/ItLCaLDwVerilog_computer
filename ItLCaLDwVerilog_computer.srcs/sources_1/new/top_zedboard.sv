import common::*;

module top_zedboard (
	input logic GCLK,
	input logic BTNC,
	input logic[7:0] SW,
	output logic[7:0] LED
);

	logic clock;
	logic mce;

	// Dashboard to see the Registers, need CLOCKBIT(24+)
	vio_0 vio (
		.clk(GCLK),
		.probe_in0(computer0.cpu0.data_path0.PC),
		.probe_in1(computer0.cpu0.data_path0.IReg),
		.probe_in2(computer0.cpu0.data_path0.MAReg),
		.probe_in3(computer0.cpu0.data_path0.A),
		.probe_in4(computer0.cpu0.data_path0.B),
		.probe_in5(computer0.cpu0.data_path0.ALU_Result),
		.probe_in6(computer0.cpu0.data_path0.CCR_Result),
		.probe_in7(computer0.cpu0.data_path0.from_memory),
		.probe_in8(computer0.cpu0.data_path0.to_memory),
		.probe_in9(computer0.cpu0.control_unit0.write),
		.probe_in10(mce)
	);

	// mit 1 funktioniert computer, mit 24 ist vio brauchbar
	clock_divider #(.CLOCKBIT(24)) clock_divider0 (
		.sysclock(GCLK),
		.divclock(clock)
	);

  computer computer0 (
		.clock(clock),
		.reset(~BTNC),
		.port_in_00(SW),
 		.port_in_01(8'h00),
 		.port_in_02(8'h00),
		.port_in_03(8'h00),
		.port_in_04(8'h00),
  	.port_in_05(8'h00),
  	.port_in_06(8'h00),
  	.port_in_07(8'h00),
  	.port_in_08(8'h00),
  	.port_in_09(8'h00),
  	.port_in_10(8'h00),
  	.port_in_11(8'h00),
  	.port_in_12(8'h00),
  	.port_in_13(8'h00),
  	.port_in_14(8'h00),
  	.port_in_15(8'h00),
  	.mce(mce),
  	.port_out_00(LED),
  	.port_out_01(/*UNUSED*/),
  	.port_out_02(/*UNUSED*/),
  	.port_out_03(/*UNUSED*/),
  	.port_out_04(/*UNUSED*/),
  	.port_out_05(/*UNUSED*/),
  	.port_out_06(/*UNUSED*/),
  	.port_out_07(/*UNUSED*/),
  	.port_out_08(/*UNUSED*/),
  	.port_out_09(/*UNUSED*/),
 		.port_out_10(/*UNUSED*/),
 		.port_out_11(/*UNUSED*/),
  	.port_out_12(/*UNUSED*/),
  	.port_out_13(/*UNUSED*/),
  	.port_out_14(/*UNUSED*/),
  	.port_out_15(/*UNUSED*/)
	);

endmodule
