module noise_gen (
	input wire clk, reset,
    input wire [31:0] period,
	output reg [7:0] value
);

    wire sg_out;
    wire [7:0] tri_out0, tri_out1, tri_out2, tri_out3;
    wire [15:0] rng_out;

    square_wave_gen swg (
        .clk(clk),
        .reset(reset),
        .period(period),
        .duty_cycle(period >> 2),
        .value(sg_out)
    );

    lsfr rng (
        .clk(clk),
        .reset(reset),
        .data(rng_out)
    );

    always @(posedge sg_out) begin
        value <= rng_out[7:0];
    end

endmodule