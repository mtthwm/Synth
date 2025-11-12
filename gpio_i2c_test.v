module gpio_i2c_test (
	input wire btn, clk, reset,
	output wire sda,
    output wire scl, led, 
    output wire [6:0] sevenseg1
);
	wire slow_clk;
    wire [3:0] state_out;
	
	assign led = slow_clk;
	
	square_wave_gen clock_div (
		.clk(clk),
		.reset(reset),
		.period(32'd5_000_000),
		.duty_cycle(32'd2_500_00),
		.value(slow_clk)
	);
	
	i2c_controller ctrl (
        .clk(slow_clk),
        .reset(reset),
        .enable(btn),
        .mode(1'b1),
        .periph_addr(7'd4),
        .transmit_byte(7'd230),
        .scl(scl),
        .sda(sda),
        .state(state_out),
        .ready(),
        .byte_reg()
    );

endmodule