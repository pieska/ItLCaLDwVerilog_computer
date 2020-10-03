import common::*;

module rom_128x8_sync (
	input logic clock,
	input address_t address,
	output data_t data_out
);

	timeunit 1ns/1ps;

	parameter romfile = "rom_128x8_sync.mem";

//	const data_t ROM[0:127] = '{default:0}; fails with "[Synth 8-2898] ignoring malformed $readmem task: invalid memory name"
	data_t ROM[0:127];

	initial
		$readmemh(romfile, ROM);
	
	always_ff @(posedge clock) begin
		if((address >= $left(ROM)) && (address <= $right(ROM)))
			data_out <= ROM[address];
	end

endmodule
