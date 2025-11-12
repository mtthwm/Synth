module audio_board_fsm (
    input wire key, reset,
    input wire [3:0] tone,
    output wire sda, sca, sdata, sbitclk, sframeclk
);

    wire [15:0] _samp_out, _tg1_per;
    wire _sw1_out;

    tone_gen #(.CLOCK_SPEED(32'd50000000)) tg1 (
        .tone(tone),
        .period(_tg1_per)
    );

    square_wave_gen sw (
        .clk(clk),
        .reset(reset),
        .period(_tg1_per),
        .duty_cycle(_tg1_per >> 1),
        .value(_sw1_out)
    );

    square_amp sa (
        .in(key ? _sw1_out : 1'b0),
        .out(_samp_out)
    );

    i2s_controller is (
        .clk(clk),
        .reset(reset),
        .send(send),
        .sample_left(_samp_out),
        .sample_right(_samp_out),
        .frame_clk(sframeclk),
        .bit_clk(sbitclk),
        .data(sdata)
    );


endmodule