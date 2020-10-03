module debouncer
	#(
		parameter WIDTH = 1,
		parameter STABLECYCLES = (100 * 10**6) / 1000 * 10	// default to 10ms @ 100 MHz
	) (
	input logic clock,
	input logic [WIDTH - 1:0] raw,
	output logic valid,
	output logic [WIDTH - 1:0] deb
);

	timeunit 1ns/1ps;
	
	integer unsigned timer = STABLECYCLES;
	logic [WIDTH - 1:0] last_raw;

	always_ff @(posedge clock) begin
		
		if(raw != last_raw) begin										// changed -> timer resets
			timer <= STABLECYCLES;
			valid <= 1'b0;
		end else begin															// no change -> timer continues

			if(timer == 0) begin											// if timer reaches zero we have a stable raw signal
				valid <= 1'b1;
				deb <= raw;
			end else
				timer <= timer - 1;

		end

		last_raw <= raw;

	end

endmodule


