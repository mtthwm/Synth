module tb_i2s ();

    reg clk, reset, send;
    reg [7:0] word_length;
    reg [15:0] send_queue_left, send_queue_right;
    
    wire ready, bit_clk, frame_clk, data;

    reg [15:0] target;
    reg [7:0] i;

    i2s bus (
        .clk(clk),
        .reset(reset),
        .send(send),
        .word_length(word_length),
        .send_queue_left(send_queue_left),
        .send_queue_right(send_queue_right),
        .bit_clk(bit_clk),
        .frame_clk(frame_clk),
        .data(data),
        .ready(ready)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        send = 1'b0;
        word_length = 8'd4;
        target = 16'd0;
        send_queue_left = 16'd7;
        send_queue_right = 16'd13;

        reset = 0; #1; reset = 1; #1; reset = 0;

        #4;

        send = 0; #1; send = 1; #1; send = 0;
    end

endmodule