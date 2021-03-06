module top_zedboard (
	input logic GCLK,
	input logic BTNC,
	input logic SW0,
	input logic SW1,
	input logic SW2,
	input logic SW3,
	input logic SW4,
	input logic SW5,
	input logic SW6,
	input logic SW7,
	output logic LD0,
	output logic LD1,
	output logic LD2,
	output logic LD3,
	output logic LD4,
	output logic LD5,
	output logic LD6,
	output logic LD7
);

	// mit 1 funktioniert computer, mit 16 sind LEDs OK, mit 24 ist vio brauchbar
	localparam CLOCKBIT = 24;
	localparam STABLECYCLES =(100 * 10**6) / 1000 * 10; // 10ms @ 100 MHz

	logic clock;
	logic mce;
	logic BTNC_deb;
	logic BTNC_valid;
	logic [7:0] SW_deb;
	logic SW_valid;
	logic resetN;
	logic [7:0] SW;

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

	clock_divider #(.CLOCKBIT(CLOCKBIT)) clock_divider0 (
		.sysclock(GCLK),
		.divclock(clock)
	);

	debouncer #(.STABLECYCLES(STABLECYCLES)) debouncer0_1 (
		.clock(GCLK),
		.raw(BTNC),
		.valid(BTNC_valid),
		.deb(BTNC_deb)
	);

	assign resetN = BTNC_valid ? ~BTNC_deb : 0;

	debouncer #(.WIDTH(8),.STABLECYCLES(STABLECYCLES)) debouncer0_8 (
		.clock(GCLK),
		.raw({SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0}),
		.valid(SW_valid),
		.deb(SW_deb)
	);

	assign SW = SW_valid ? SW_deb : 0;

  computer computer0 (
		.clock(clock),
		.resetN(resetN),
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
  	.port_out_00({LD7,LD6,LD5,LD4,LD3,LD2,LD1,LD0}),
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
