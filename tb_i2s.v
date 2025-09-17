module tb_i2s ();

    reg clk, reset;
    reg [7:0] word_length;
    reg [15:0] send_queue_left, send_queue_right;
    
    wire ready, bit_clk, frame_clk, data;
    wire [7:0] counter;

    reg [15:0] target;
    reg [7:0] i;

    i2s bus (
        .clk(clk),
        .reset(reset),
        .word_length(word_length),
        .send_queue_left(send_queue_left),
        .send_queue_right(send_queue_right),
        .bit_clk(bit_clk),
        .frame_clk(frame_clk),
        .data(data),
        .counter_out(counter)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        word_length = 8'd4;
        target = 16'd0;
        send_queue_left = 16'd7;
        send_queue_right = 16'd13;
        reset = 0; #1; reset = 1; #1 reset = 0;
    end

endmodule