module i2c_test_top (
    input wire clk, reset,
    inout wire sda,
    output wire scl, sda_indicator, clk_indicator,
    output wire [6:0] ss0, ss1, ss2
);

    assign sda_indicator = sda == 1'b1;
    assign clk_indicator = scl;

    wire slow_clk;
    wire [7:0] read_byte;
    wire [3:0] state_out;

    square_wave_gen sg (
        .clk(clk),
        .reset(reset),
        .period(32'd12_500_000),
        .duty_cycle(32'd6_250_000),
        .value(slow_clk)
    );

    sevenseg d0 (
        .bcd(read_byte[3:0]),
        .seven_seg(ss0)
    );
    sevenseg d1 (
        .bcd(read_byte[7:4]),
        .seven_seg(ss1)
    );
    sevenseg d2 (
        .bcd(state_out),
        .seven_seg(ss2)
    );

    i2c_fsm test_fsm (
        .clk(slow_clk),
        .reset(reset),
        .read_byte(read_byte),
        .sda(sda),
        .scl(scl),
        .state_info(state_out)
    );

endmodule