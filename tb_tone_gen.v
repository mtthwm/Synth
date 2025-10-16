
module tb_tone_gen ();

    reg clk, reset, send;
    reg [3:0] tone;
    wire frame_clk, bit_clk, sound_data;

    wire [15:0] _samp_out, _tg1_per;
    wire _sw1_out;

    tone_gen #(.CLOCK_SPEED(32'd128)) tg1 (
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

    i2s_controller is (
        .clk(clk),
        .reset(reset),
        .send(send),
        .sample_left(_samp_out),
        .sample_right(_samp_out),
        .frame_clk(frame_clk),
        .bit_clk(bit_clk),
        .data(sound_data)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        reset = 1'b0; #1; reset = 1'b1; #1; reset = 1'b0;
        tone = 4'd0;
        send = 1'b0; #1; send = 1'b1;
    end


endmodule