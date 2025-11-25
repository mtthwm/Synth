module noise_gen (
	input wire clk, reset,
	output wire [7:0] value
);

    wire [15:0] rng_out;

    lsfr rng (
        .clk(clk),
        .reset(reset),
        .data(rng_out)
    );

    assign value = rng_out[7:0];

endmodule