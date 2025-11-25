module square_wave_top (
    input wire clk, reset,
    inout wire sda,
    input wire [3:0] tone,
    output wire scl,
    output wire [2:0] gpio_debug,
    output wire bit_clk, data, frame_clk, chip_clk,
    output wire [6:0] ss0, ss1, ss2, ss3
);

    parameter MAIN_CLK_SPEED = 32'd50_000_000;
    parameter SLOW_CLK_SPEED = 32'd12_288_000;

    wire [15:0] _samp_out, _tg1_per;
    wire [7:0] debug;
    wire _sw1_out;
    wire slow_clk;
    wire i2c_state_info;
    wire i2c_byte_out;

    assign gpio_debug[0] = _sw1_out;
    assign gpio_debug[1] = bit_clk;
    assign gpio_debug[2] = data;

    assign chip_clk = slow_clk;

    tone_gen #(.CLOCK_SPEED(SLOW_CLK_SPEED)) tg1 (
        .tone(tone),
        .period(_tg1_per)
    );

    square_wave_gen clock_div (
        .clk(clk),
        .reset(reset),
        .period(MAIN_CLK_SPEED/SLOW_CLK_SPEED),
        .duty_cycle((MAIN_CLK_SPEED/SLOW_CLK_SPEED)/2),
        .value(slow_clk)
    );

    noise_gen ng (
        .clk(slow_clk),
        .reset(reset),
        // .period(_tg1_per),
        .value(_samp_out)

    );

    sevenseg ssm0 (
      .bcd(i2c_state_info),
      .seven_seg(ss0)  
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