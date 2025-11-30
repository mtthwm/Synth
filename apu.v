module apu (
    input clk, reset, restart, enable,
    input [9:0] start_addr, end_addr
);

wire [9:0] beat_addr_out;
wire [15:0] beat_out;

tone_gen #(.CLOCK_SPEED(SLOW_CLK_SPEED)) tg1 (
    .tone0(beat_out[15:12]),
    .tone1(beat_out[11:8]),
    .tone2(beat_out[7:4]),
    .tone3(beat_out[3:0]),
    .period0(_tg0_per),
    .period1(_tg1_per),
    .period2(_tg2_per),
    .period3(_tg3_per)
);

beat_counter bc0 (
    .clk(clk),
    .reset(reset),
    .start_addr(start_addr)
    .end_addr(end_addr),
    .beat_addr_out(beat_addr_out)
);

bram bram0 (
    .clk(clk),
    .reset(reset),
    .addr_a(beat_addr_out),
    .q_a(beat_out),
    .addr_b(0),
    .we_a(1'b0),
    .we_b(1'b0),
);

endmodule