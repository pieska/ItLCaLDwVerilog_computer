import common::*;

module clock_divider_tb;

	timeunit 1ns/1ps;

	logic sysclock_tb;
	logic divclock_tb;

	clock_divider #(.CLOCKBIT(0)) uut (
		.sysclock(sysclock_tb),
		.divclock(divclock_tb)
	);

	// Clock generator
  initial forever
    #1 sysclock_tb = ~sysclock_tb;

	initial begin
		sysclock_tb = 1'b0;
		
		#100
		
		$finish;
	end

endmodule
