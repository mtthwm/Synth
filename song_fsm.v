module song_fsm (
    input wire clk, reset,
    output wire [3:0] tone0, tone1, tone2, tone3,
    output wire [7:0] note_index_out
);

    assign note_index_out = state;

    reg [15:0] beat;

    assign tone0 = beat[15:12];
    assign tone1 = beat[11:8];
    assign tone2 = beat[7:4];
    assign tone3 = beat[3:0];

    reg [7:0] state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 8'd0;
        end else begin
            state <= state + 8'd1;
        end
    end

    always @(*) begin
        case (state)
            0:   beat = 16'h33a1;
            1:   beat = 16'h0000;
            2:   beat = 16'h33a0;
            3:   beat = 16'h0000;
            4:   beat = 16'h70c1;
            5:   beat = 16'h0000;
            6:   beat = 16'h70c0;
            7:   beat = 16'h0000;
            8:   beat = 16'h11d1;
            9:   beat = 16'h0000;
            10:  beat = 16'h11d0;
            11:  beat = 16'h0000;
            12:  beat = 16'h77c1;
            13:  beat = 16'h0000;
            14:  beat = 16'h0000;
            15:  beat = 16'h0000;
            16:  beat = 16'h66b1;
            17:  beat = 16'h0000;
            18:  beat = 16'h66b0;
            19:  beat = 16'h0000;
            20:  beat = 16'h50a1;
            21:  beat = 16'h0000;
            22:  beat = 16'h50a0;
            23:  beat = 16'h0000;
            24:  beat = 16'h4491;
            25:  beat = 16'h0000;
            26:  beat = 16'h4490;
            27:  beat = 16'h0000;
            28:  beat = 16'h33a1;
            29:  beat = 16'h0000;
            30:  beat = 16'h0030;
            31:  beat = 16'h0000;
            default: beat = 16'd0;
        endcase
    end

endmodule