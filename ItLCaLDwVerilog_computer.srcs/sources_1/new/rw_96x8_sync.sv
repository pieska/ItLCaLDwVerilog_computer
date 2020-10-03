import common::*;

module rw_96x8_sync (
	input logic clock,
	input address_t address,
	input logic write,
	input data_t data_in,
	output data_t data_out
);

	timeunit 1ns/1ps;

	data_t RW[128:223];

	always_ff @(posedge clock) begin
		// address in valid range?	
		if((address >= $left(RW)) && (address <= $right(RW)))
			if(write) begin
				RW[address] <= data_in;
				// read-before-write
				data_out <= data_in;
			end else
				data_out <= RW[address];
	end

endmodule
