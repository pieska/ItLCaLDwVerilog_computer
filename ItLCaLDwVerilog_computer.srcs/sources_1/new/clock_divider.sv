import common::*;

module clock_divider #(parameter CLOCKBIT = 1) (
	input logic sysclock,
	output logic divclock
);

	timeunit 1ns/1ps;

	logic[CLOCKBIT-1:0] counter = 0;

	always_ff @ (posedge sysclock)
		counter <= counter + 1;
		
	assign divclock = counter[$left(counter)];

endmodule
