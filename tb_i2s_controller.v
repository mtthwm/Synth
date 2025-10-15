module tb_i2s_controller ();

    reg clk, reset, send;
    reg [15:0] sample_left, sample_right;

    wire bit_clk, data;

    i2s_controller ctl (
        .clk(clk),
        .reset(reset),
        .send(send),
        .bit_clk(bit_clk),
        .frame_clk(frame_clk),
        .data(data),
        .sample_left(sample_left),
        .sample_right(sample_right)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;
        sample_left = 16'd17;
        sample_right = 16'd17;


        send = 1'b0; #1; send = 1'b1; #1; send = 1'b0;
    end

endmodule