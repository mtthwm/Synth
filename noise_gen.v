module noise_gen (
	input wire clk, reset,
    input wire [31:0] period,
	output wire [7:0] value
);

    wire [15:0] rng_out;

    lsfr rng (
        .clk(clk),
        .reset(reset),
        .data(rng_out)
    );

    assign value = period ? rng_out[7:0] : 32'd0;

endmodule