module tb_mix ();

    wire [7:0] chan_out0, chan_out1, chan_out2, chan_out3;
    reg clk, reset;
    wire [15:0] samp_out;

    // Wave Generators
    pulse_wave_gen pwg0 (
        .clk(clk),
        .reset(reset),
        .period(32'd23),
        .duty_div(1),
        .value(chan_out0)
    );

    pulse_wave_gen pwg1 (
        .clk(clk),
        .reset(reset),
        .period(32'd245),
        .duty_div(2),
        .value(chan_out1)
    );

    triangle_wave_gen twg0 (
        .clk(clk),
        .reset(reset),
        .period(32'd16),
        .value(chan_out2)
    );

    noise_gen nwg0 (
        .clk(clk),
        .reset(reset),
        .period(32'd64),
        .value(chan_out3)
    );
    // End Wave Generators

    mix4 mixer0 (
        .samp0(chan_out0),
        .samp1(chan_out1),
        .samp2(chan_out2),
        .samp3(chan_out3),
        .samp_out(samp_out)
    );


    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;
    end

endmodule