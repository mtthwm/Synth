module apu #(parameter MAIN_CLK_SPEED = 32'd50_000_000, parameter SLOW_CLK_SPEED = 32'd12_288_000) (
    input wire clk, reset, restart, enable,
    input wire [9:0] start_addr, end_addr,
    inout wire sda,
    output wire frame_clk, bit_clk, sdata, scl, note_clk,
    output wire [3:0] t0, t1, t2, t3,
    output wire [9:0] debug
);

wire [9:0] beat_addr_out;
wire [15:0] beat_out;
wire [31:0] tg_per0, tg_per1, tg_per2, tg_per3;

wire [15:0] samp_out;

assign t0 = beat_out[15:12];
assign t1 = beat_out[11:8];
assign t2 = beat_out[7:4];
assign t3 = beat_out[3:0];
assign debug = beat_addr_out;

square_wave_gen clock_div (
    .clk(clk),
    .reset(reset),
    .period(MAIN_CLK_SPEED/SLOW_CLK_SPEED),
    .duty_cycle((MAIN_CLK_SPEED/SLOW_CLK_SPEED)/2),
    .value(slow_clk)
);

tone_gen #(.CLOCK_SPEED(SLOW_CLK_SPEED)) tg1 (
    .tone0(t0),
    .tone1(t1),
    .tone2(t2),
    .tone3(t3),
    .period0(tg_per0),
    .period1(tg_per1),
    .period2(tg_per2),
    .period3(tg_per3)
);

beat_counter #(.MAIN_CLK_SPEED(SLOW_CLK_SPEED), .NOTE_CLK_SPEED(32'b1)) bc0 (
    .clk(slow_clk),
    .reset(reset),
    .start_addr(start_addr),
    .end_addr(end_addr),
    .beat_addr(beat_addr_out),
    .note_clk_out(note_clk)
);

bram bram0 (
    .clk(slow_clk),
    .addr_a(beat_addr_out),
    .q_a(beat_out),
    .addr_b(0),
    .we_a(1'b0),
    .we_b(1'b0)
);

i2c_fsm i2fsm (
    .clk(slow_clk),
    .reset(reset),
    .sda(sda),
    .scl(scl),
    .one_shot(1'b1)
);

i2s_controller is (
    .clk(slow_clk),
    .reset(reset),
    .sample_left(samp_out),
    .sample_right(samp_out),
    .frame_clk(frame_clk),
    .bit_clk(bit_clk),
    .data(data)
);

endmodule