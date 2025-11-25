module song_fsm (
    input wire clk, reset,
    output wire [3:0] tone0, tone1, tone2, tone3,
    output wire [7:0] note_index_out
);
    reg [7:0] state;
    reg [15:0] beat;

    assign tone0 = beat[15:12];
    assign tone1 = beat[11:8];
    assign tone2 = beat[7:4];
    assign tone3 = beat[3:0];
    assign note_index_out = state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 8'd0;
        end else begin
            state <= state + 8'd1;
        end
    end

    always @(*) begin
        case (state)
            0:   beat = 16'h0000;
            1:   beat = 16'h1000;
            2:   beat = 16'h0200;
            3:   beat = 16'h0030;
            4:   beat = 16'h0001;
            5:   beat = 16'h4000;
            6:   beat = 16'h0500;
            7:   beat = 16'h0060;
            8:   beat = 16'h0001;
            9:   beat = 16'h7000;
            10:   beat = 16'h0800;
            11:  beat = 16'h0090;
            12:  beat = 16'h0001;
            13:  beat = 16'ha000;
            14:  beat = 16'h0b00;
            15:  beat = 16'h00c0;
            16:  beat = 16'h0001;
            17:  beat = 16'hd000;
            18:  beat = 16'h0e00;
            19:  beat = 16'h00f0;
            default: beat = 16'd0;
        endcase
    end

endmodule