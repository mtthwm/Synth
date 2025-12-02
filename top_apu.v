module top_apu (
    input wire clk, reset, btn,
    inout wire sda,
    output wire frame_clk, bit_clk, sdata, scl, chip_clk,
    output wire [9:0] debug,
    output wire [6:0] ss0, ss1, ss2, ss3, ss4, ss5, ss6
);

    assign debug[0] = frame_clk;
    assign debug[1] = bit_clk;
    assign debug[2] = sdata;

    wire [3:0] t0, t1, t2, t3;

    sevenseg ssm0 (
      .bcd(t0),
      .seven_seg(ss0)  
    );
    sevenseg ssm1 (
      .bcd(t1),
      .seven_seg(ss1)  
    );
    sevenseg ssm2 (
      .bcd(t2),
      .seven_seg(ss2)  
    );
    sevenseg ssm3 (
      .bcd(t3),
      .seven_seg(ss3)  
    );

    apu #(.MAIN_CLK_SPEED(32'd50_000_000), .SLOW_CLK_SPEED(32'd12_288_000), .NOTE_CLK_SPEED(32'd16)) apu0  (
    .clk(clk), 
    .reset(reset),
    .start_addr(10'd0), 
    .end_addr(10'd128),
    .sda(sda),
    .send_oneshot(~btn),
    .frame_clk(frame_clk), 
    .bit_clk(bit_clk), 
    .chip_clk(chip_clk),
    .sdata(sdata), 
    .scl(scl),
    .t0_me(t0),
    .t1_me(t1),
    .t2_me(t2),
    .t3_me(t3)
);

endmodule