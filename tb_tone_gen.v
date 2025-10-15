
module tb_tone_gen ();

    reg clk, reset;
    reg [3:0] tone;
    wire frame_clk, bit_clk, sound_data;

    wire [15:0] _samp_out, _tg1_per;
    wire _sw1_out;

    tone_gen #(.CLOCK_SPEED(32'd20)) tg1 (
        .tone(tone),
        .period(_tg1_per)
    );

    square_wave_gen sw (
        .clk(clk),
        .reset(reset),
        .period(_tg1_per),
        .duty_cycle(_tg1_per >> 1),
        .value(_sw1_out)
    );

    square_amp sa (
        .in(_sw1_out),
        .out(_samp_out)
    );

    i2s is (
        .clk(clk),
        .reset(reset),
        .word_length(8'd16),
        .send_queue_left(_samp_out),
        .send_queue_right(_samp_out),
        .frame_clk(frame_clk),
        .bit_clk(bit_clk),
        .data(sound_data)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;
        tone = 4'd0;

    end


endmodule