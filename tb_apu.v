module tb_apu ();

    reg clk, reset;
    reg [9:0] start_addr, end_addr;
    wire note_clk;
    wire [3:0] t0, t1, t2, t3;
    wire [9:0] debug;

    apu #(.MAIN_CLK_SPEED(32'd8), .SLOW_CLK_SPEED(32'd4)) apu0 (
        .clk(clk),
        .reset(reset),
        .start_addr(start_addr),
        .end_addr(end_addr),
        .note_clk(note_clk),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3),
        .debug(debug)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        start_addr = 10'd0;
        end_addr = 10'd16;
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;
    end
endmodule