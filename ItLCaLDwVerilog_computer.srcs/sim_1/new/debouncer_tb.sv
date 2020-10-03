module debouncer_tb;

	timeunit 1ns/1ps;

	logic clock_tb;
	logic raw_tb;
	logic valid_tb;
	logic deb_tb;

	localparam STABLECYCLES = 3;
		localparam WAITCLOCKS = (STABLECYCLES + 2) * 2;

	debouncer #(.STABLECYCLES(STABLECYCLES)) uut (
		.clock(clock_tb),
		.raw(raw_tb),
		.valid(valid_tb),
		.deb(deb_tb)
	);

	// Clock generator
  initial forever
    #1 clock_tb = ~clock_tb;

	initial begin
		clock_tb = 1'b0;

		// at startup signal should be valid after timer
		raw_tb = 1'b0;
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// jitterfree transition from 0 -> 1		
		raw_tb = 1'b1;
		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// keep at 1 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// jitterfree transition from 1 -> 0		
		raw_tb = 1'b0;
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// keep at 0 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// jitter transition from 0 -> 1		
		raw_tb = 1'b1;
		#3
		raw_tb = 1'b0;
		#5
		raw_tb = 1'b1;

		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch, %b %b", `__LINE__, deb_tb, valid_tb);

		// keep at 1 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// just jitter
		raw_tb = 1'b1;
		#3
		raw_tb = 1'b0;
		#5
		raw_tb = 1'b1;

		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// keep at 1 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b1 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);
		
		// jitter transition from 1 -> 0		
		raw_tb = 1'b0;
		#3
		raw_tb = 1'b1;
		#5
		raw_tb = 1'b0;
		
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// keep at 1 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// just jitter		
		raw_tb = 1'b0;
		#3
		raw_tb = 1'b1;
		#5
		raw_tb = 1'b0;
		
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		// keep at 1 for at least 6 clocks
		#WAITCLOCKS
		assert(deb_tb == 1'b0 && valid_tb == 1'b1) else $error("%d: deb_tb/valid mismatch", `__LINE__);

		#5
		
		$finish;
	end



endmodule
