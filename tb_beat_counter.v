module tb_beat_counter ();

    reg clk, reset;
    reg [9:0] start_addr, end_addr;
    
    wire [9:0] beat_addr_out;


    beat_counter #(.MAIN_CLK_SPEED(32'd8), .NOTE_CLK_SPEED(32'd1)) bc (
        .clk(clk),
        .reset(reset),
        .start_addr(start_addr),
        .end_addr(end_addr),
        .beat_addr(beat_addr_out)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        start_addr = 10'd0;
        end_addr = 10'd8;
        reset = 1'b1; #1; reset = 1'b0; #1; reset = 1'b0;
    end
endmodule