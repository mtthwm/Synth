module gpio_test (
	input wire btn, clk, reset,
	output wire gpio, led
);

	wire sw_out;
	
	assign gpio = sw_out;
	assign led = sw_out;
	
	square_wave_gen sw (
		.clk(clk),
		.reset(reset),
		.period(32'd5_000_000),
		.duty_cycle(32'd2_500_00),
		.value(sw_out)
	);

endmodule