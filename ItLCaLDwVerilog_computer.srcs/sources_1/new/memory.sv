import common::*;
	
module memory (
	input logic clock,
	input logic reset,
	input address_t address,
	input logic write,
	input data_t data_in,
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
	output data_t data_out,
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

	data_t rom0_data_out;
	data_t rw0_data_out;

	rom_128x8_sync rom0 (
		.clock(clock),
		.address(address),
		.data_out(rom0_data_out)
	);
	
	rw_96x8_sync rw0 (
		.clock(clock),
		.address(address),
		.write(write),
		.data_in(data_in),
		.data_out(rw0_data_out)
	);

	always_comb begin
	
		if((address >= 8'h00) && (address <= 8'h7F))
			data_out = rom0_data_out;
		else if((address >= 8'h80) && (address <= 8'hDF))
			data_out = rw0_data_out;
		else if(address == 8'hF0)
			data_out = port_in_00;
		else if(address == 8'hF1)
			data_out = port_in_01;
		else if(address == 8'hF2)
			data_out = port_in_02;
		else if(address == 8'hF3)
			data_out = port_in_03;
		else if(address == 8'hF4)
			data_out = port_in_04;
		else if(address == 8'hF5)
			data_out = port_in_05;
		else if(address == 8'hF6)
			data_out = port_in_06;
		else if(address == 8'hF7)
			data_out = port_in_07;
		else if(address == 8'hF8)
			data_out = port_in_08;
		else if(address == 8'hF9)
			data_out = port_in_09;
		else if(address == 8'hFA)
			data_out = port_in_10;
		else if(address == 8'hFB)
			data_out = port_in_11;
		else if(address == 8'hFC)
			data_out = port_in_12;
		else if(address == 8'hFD)
			data_out = port_in_13;
		else if(address == 8'hFE)
			data_out = port_in_14;
		else if(address == 8'hFF)
			data_out = port_in_15;
		else
			data_out = 'bX;

  end

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_00 <= 8'h00;
		else if((address == 8'hE0) && (write))
			port_out_00 <= data_in;
	end

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_01 <= 8'h00;
		else if((address == 8'hE1) && (write))
			port_out_01 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_02 <= 8'h00;
		else if((address == 8'hE2) && (write))
			port_out_02 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_03 <= 8'h00;
		else if((address == 8'hE3) && (write))
			port_out_03 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_04 <= 8'h00;
		else if((address == 8'hE4) && (write))
			port_out_04 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_05 <= 8'h00;
		else if((address == 8'hE5) && (write))
			port_out_05 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_06 <= 8'h00;
		else if((address == 8'hE6) && (write))
			port_out_06 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_07 <= 8'h00;
		else if((address == 8'hE7) && (write))
			port_out_07 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_08 <= 8'h00;
		else if((address == 8'hE8) && (write))
			port_out_08 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_09 <= 8'h00;
		else if((address == 8'hE9) && (write))
			port_out_09 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_10 <= 8'h00;
		else if((address == 8'hEA) && (write))
			port_out_10 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_11 <= 8'h00;
		else if((address == 8'hEB) && (write))
			port_out_11 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_12 <= 8'h00;
		else if((address == 8'hEC) && (write))
			port_out_12 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_13 <= 8'h00;
		else if((address == 8'hED) && (write))
			port_out_13 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_14 <= 8'h00;
		else if((address == 8'hEE) && (write))
			port_out_14 <= data_in;
	end;

	always_ff @ (posedge clock, negedge reset) begin
		if(!reset)
			port_out_15 <= 8'h00;
		else if((address == 8'hEF) && (write))
			port_out_15 <= data_in;
	end;

endmodule
