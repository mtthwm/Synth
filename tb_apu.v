module tb_apu ();

    reg clk, reset, send_oneshot;
    reg [9:0] start_addr, end_addr;
    wire note_clk;
    reg acknowledge_lookahead;
    wire lookahead_ready;
    wire [3:0] t0, t1, t2, t3;
    wire [9:0] debug, timestamp;
    wire [3:0] lookahead_tone;

    apu #(.MAIN_CLK_SPEED(32'd40), .SLOW_CLK_SPEED(32'd20)) apu0 (
        .clk(clk),
        .reset(reset),
        .start_addr(start_addr),
        .end_addr(end_addr),
        .send_oneshot(send_oneshot),
        .timestamp(timestamp),
        .lookahead_offset(10'd2),
        .lookahead_tone(lookahead_tone),
        .lookahead_ready(lookahead_ready),
        .acknowledge_lookahead(acknowledge_lookahead),
        .note_clk(note_clk),
        .t0_me(t0),
        .t1_me(t1),
        .t2_me(t2),
        .t3_me(t3),
        .debug(debug)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        start_addr = 10'd0;
        end_addr = 10'd16;
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;

        #32;
        send_oneshot = 1'b0; #1; send_oneshot = 1'b1; #1; send_oneshot = 1'b0;
        acknowledge_lookahead = 1'b0; #1; acknowledge_lookahead = 1'b1; #1; acknowledge_lookahead = 1'b0;
        #512;
        acknowledge_lookahead = 1'b0; #1; acknowledge_lookahead = 1'b1; #1; acknowledge_lookahead = 1'b0;
        

    end
endmodule