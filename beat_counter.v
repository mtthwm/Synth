module beat_counter #(
    parameter MAIN_CLK_SPEED = 32'd12_288_000,
        parameter NOTE_CLK_SPEED = 32'd1
            ) (

    input clk, reset,
    input wire [9:0] start_addr, end_addr,
    output wire note_clk_out,
    output wire [9:0] beat_addr
);


    wire note_clk;

    square_wave_gen note_clk_div (
        .clk(clk),
        .reset(reset),
        .period(MAIN_CLK_SPEED/NOTE_CLK_SPEED),
        .duty_cycle((MAIN_CLK_SPEED/NOTE_CLK_SPEED)/2),
        .value(note_clk)
    );

    reg [9:0] counter;
    reg began;

    assign beat_addr = counter;
    assign note_clk_out = note_clk;

    always @(posedge note_clk, posedge reset) begin
        if (reset) begin
            counter <= start_addr;
            began <= 1'b0;
        end else begin
            if (!began || counter === end_addr-1) begin
                counter <= start_addr;
                began <= 1'b1;
            end else begin
                counter <= counter + 10'd1;
            end
        end
    end

endmodule