module apu #(parameter MAIN_CLK_SPEED = 32'd50_000_000, parameter SLOW_CLK_SPEED = 32'd12_288_000, parameter NOTE_CLK_SPEED = 32'd1) (
    input wire clk, reset, restart, enable, send_oneshot,
    input wire [9:0] start_addr, end_addr, lookahead_offset,
    input wire acknowledge_lookahead,
    inout wire sda,
    output wire frame_clk, bit_clk, sdata, scl, note_clk, chip_clk,
    output wire [3:0] t0_me, t1_me, t2_me, t3_me,
    output wire [3:0] t3_lookahead,
    output reg lookahead_ready,
    output wire [9:0] debug,
    output reg [9:0] timestamp
);

wire slow_clk;
wire [3:0] t0, t1, t2, t3;
wire [3:0] t0_os, t1_os, t2_os, t3_os;
wire [7:0] chan_out0, chan_out1, chan_out2, chan_out3;
wire [9:0] beat_addr_out;
wire [15:0] beat_out, beat_lookahead;
wire [31:0] tg_per0, tg_per1, tg_per2, tg_per3;

wire [15:0] samp_out;

assign t0_me = beat_out[15:12];
assign t1_me = beat_out[11:8];
assign t2_me = beat_out[7:4];
assign t3_me = beat_out[3:0];
assign debug = {t0_os, t1_os, t2_os, t3_os};
assign chip_clk = slow_clk;

assign t0 = t0_os ? t0_os : t0_me;
assign t1 = t1_os ? t1_os : t1_me;
assign t2 = t2_os ? t2_os : t2_me;
assign t3 = t3_os ? t3_os : t3_me;

assign t3_lookahead = beat_lookahead[3:0];

always @(posedge acknowledge_lookahead, posedge note_clk, posedge reset) begin
    if (reset) begin
        lookahead_ready = 1'b0;
        timestamp <= 10'd0;
    end else begin
        if (note_clk) begin
            lookahead_ready <= 1'b1;
            timestamp <= timestamp + 10'd1;
        end else begin
            lookahead_ready <= 1'b0;
        end
    end
end

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

beat_counter #(.MAIN_CLK_SPEED(SLOW_CLK_SPEED), .NOTE_CLK_SPEED(NOTE_CLK_SPEED)) bc0 (
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
    .q_b(beat_lookahead),
    .addr_b(beat_addr_out + lookahead_offset),
    .we_a(1'b0),
    .we_b(1'b0)
);

oneshot os0 (
    .clk(slow_clk),
    .send(send_oneshot),
    .sfx(16'h0001),
    .t0(t0_os),
    .t1(t1_os),
    .t2(t2_os),
    .t3(t3_os)
);

// Wave Generators
pulse_wave_gen pwg0 (
    .clk(slow_clk),
    .reset(reset),
    .period(tg_per0),
    .duty_div(1),
    .value(chan_out0)
);

pulse_wave_gen pwg1 (
    .clk(slow_clk),
    .reset(reset),
    .period(tg_per1),
    .duty_div(2),
    .value(chan_out1)
);

triangle_wave_gen twg0 (
    .clk(slow_clk),
    .reset(reset),
    .period(tg_per2),
    .value(chan_out2)
);

noise_gen nwg0 (
    .clk(slow_clk),
    .reset(reset),
    .period(tg_per3),
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
    .data(sdata)
);

endmodule