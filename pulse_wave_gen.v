module pulse_wave_gen (
    input wire clk, reset,
    input wire [3:0] duty_div,
    input wire [31:0] period,
    output wire [7:0] value
);

    wire sg_out;

    assign value = sg_out ? 8'd255 : 8'd0;

    square_wave_gen swg (
        .clk(clk),
        .reset(reset),
        .period(period),
        .duty_cycle(period >> duty_div),
        .value(sg_out)
    );

endmodule