module song_fsm_top (
    input wire clk, reset,
    inout wire sda,
    output wire scl,
    output wire bit_clk, data, frame_clk, chip_clk,
    output wire [6:0] ss0, ss1, ss2, ss3
);

    parameter MAIN_CLK_SPEED = 32'd50_000_000;
    parameter SLOW_CLK_SPEED = 32'd12_288_000;
    parameter SONG_SPEED = 32'd4;

    wire [15:0] _samp_out;
    wire [31:0] _tg0_per, _tg1_per, _tg2_per, _tg3_per;
    wire [7:0] debug;

    wire _sw0_out;
    wire _sw1_out;
    wire _sw0_amp;
    wire _sw1_amp;
    wire _triangle_wave_out;
    wire _noise_wave_out;

    wire slow_clk;
    wire note_clk;

    wire [7:0] note_index_out;

    wire [3:0] tone0, tone1, tone2, tone3;

    assign chip_clk = slow_clk;

    sevenseg disp0 (
        .bcd(tone0),
        .seven_seg(ss0)
    );

    sevenseg disp1 (
        .bcd(tone1),
        .seven_seg(ss1)
    );

    sevenseg disp2 (
        .bcd(tone2),
        .seven_seg(ss2)
    );

    sevenseg disp3 (
        .bcd(tone1),
        .seven_seg(ss3)
    );

    song_fsm sf (
        .clk(note_clk),
        .note_index_out(note_index_out),
        .reset(reset),
        .tone0(tone0),
        .tone1(tone1),
        .tone2(tone2),
        .tone3(tone3)
    );

    tone_gen #(.CLOCK_SPEED(SLOW_CLK_SPEED)) tg1 (
        .tone0(tone0),
        .tone1(tone1),
        .tone2(tone2),
        .tone3(tone3),
        .period0(_tg0_per),
        .period1(_tg1_per),
        .period2(_tg2_per),
        .period3(_tg3_per)
    );

    square_wave_gen slow_clk_div (
        .clk(clk),
        .reset(reset),
        .period(MAIN_CLK_SPEED/SLOW_CLK_SPEED),
        .duty_cycle((MAIN_CLK_SPEED/SLOW_CLK_SPEED)/2),
        .value(slow_clk)
    );

    square_wave_gen note_clk_div (
        .clk(clk),
        .reset(reset),
        .period(MAIN_CLK_SPEED/SONG_SPEED),
        .duty_cycle((MAIN_CLK_SPEED/SONG_SPEED)/2),
        .value(note_clk)
    );

    square_wave_gen swg0 (
        .clk(slow_clk),
        .reset(reset),
        .period(_tg0_per),
        .duty_cycle(_tg0_per >> 1),
        .value(_sw0_out)
    );

    square_wave_gen swg1 (
        .clk(slow_clk),
        .reset(reset),
        .period(_tg1_per),
        .duty_cycle(_tg1_per >> 1),
        .value(_sw1_out)
    );

    square_amp sa0 (
        .in(_sw0_out),
        .out(_sw0_amp)
    );

    square_amp sa1 (
        .in(_sw1_out),
        .out(_sw1_amp)
    );

    triangle_wave_gen twg (
        .clk(slow_clk),
        .reset(reset),
        .period(_tg1_per),
        .value(_triangle_wave_out)
    );

    noise_gen ng (
        .clk(slow_clk),
        .reset(reset),
        .period(_tg3_per),
        .value(_noise_wave_out)
    );

    mix4 mixer (
        .samp0(_sw0_amp),
        .samp1(_sw1_amp),
        .samp2(_triangle_wave_out),
        .samp3(_noise_wave_out),
        .samp_out(_samp_out)
    );

    i2c_fsm i2fsm (
        .clk(slow_clk),
        .reset(reset),
        .sda(sda),
        .scl(scl),
        .read_byte(i2c_byte_out),
        .state_info(i2c_state_info),
        .debug(debug),
        .one_shot(1'b1)
    );

    i2s_controller is (
        .clk(slow_clk),
        .reset(reset),
        .sample_left(_samp_out),
        .sample_right(_samp_out),
        .frame_clk(frame_clk),
        .bit_clk(bit_clk),
        .data(data)
    );

endmodule