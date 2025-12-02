module noise_gen (
	input wire clk, reset,
    input wire [31:0] period,
	output reg [7:0] value
);

    wire [7:0] tri_out0, tri_out1, tri_out2, tri_out3;
    wire [15:0] rng_out;

    triangle_wave_gen twg0 (
        .clk(clk),
        .reset(reset),
        .period(period),
        .value(tri_out0)
    );

    triangle_wave_gen twg1 (
        .clk(clk),
        .reset(reset),
        .period(period >> 1),
        .value(tri_out1)
    );

    triangle_wave_gen twg2 (
        .clk(clk),
        .reset(reset),
        .period(period >> 2),
        .value(tri_out2)
    );

    triangle_wave_gen twg3 (
        .clk(clk),
        .reset(reset),
        .period(period << 1),
        .value(tri_out3)
    );

    always @(*) begin
        value = (tri_out0 >> 2) + (tri_out1 >> 2) + (tri_out2 >> 2) + (tri_out3 >> 2);
        // if (period !== 32'd0) begin
        //     value = {4'd0, rng_out[3:0]} + {tri_out >> 1};
        // end else begin
        //     value = 4'd0;
        // end
    end

endmodule