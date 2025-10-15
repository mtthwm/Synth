module piano_demo_top (
    input clk, reset,
    input wire [3:0] keys,
    output wire frame_clk, bit_clk, sound_data, sdc, sda
);
    wire [15:0] _tg1_per, _samp_out;
    wire _sw1_out;

    tone_gen tg1 (
        .tone(0),
        .period(_tg1_per)
    );

    square_wave_gen sw (
        .clk(clk),
        .reset(reset),
        .period(_tg1_per),
        .duty_cycle(_tg1_per >> 1),
        .output(_sw1_out)
    );

    square_amp sa (
        .in(_sw1_out),
        .out(_samp_out)
    );

    i2s is (
        .clk(clk),
        .reset(reset),
        .word_length(8'd16),
        .send_queue_left(_samp_out),
        .send_queue_right(_samp_out),
        .frame_clk(frame_clk),
        .bit_clk(bit_clk),
        .data(sound_data)
    );

endmodule