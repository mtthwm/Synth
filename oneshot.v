module oneshot #(parameter MAIN_CLK_SPEED = 32'd12_288_000) (
    input wire clk, send, reset,
    input wire [15:0] sfx,
    output reg [3:0] t0, t1, t2, t3
);

    parameter S_IDLE = 2'd0;
    parameter S_PLAY = 2'd1;
    parameter S_WAIT_FOR_RELEASE = 2'd2;


    parameter T_TARG = MAIN_CLK_SPEED / 32'd10;

    reg [31:0] t_i;
    reg [1:0] state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state = S_IDLE;
            t_i <= 32'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (send) begin
                        t_i = 32'd0;
                        state <= S_PLAY;
                    end
                end
                S_PLAY: begin
                    if (t_i < T_TARG) begin
                        t_i <= t_i + 32'd1;
                    end else begin
                        state <= S_WAIT_FOR_RELEASE;
                    end
                end
                S_WAIT_FOR_RELEASE: begin
                    if (!send) begin
                        state <= S_IDLE;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    always @(*) begin
        if (state === S_PLAY) begin
            t0 = sfx[15:12];
            t1 = sfx[11:8];
            t2 = sfx[7:4];
            t3 = sfx[3:0];
        end else begin
            t0 = 4'd0;
            t1 = 4'd0;
            t2 = 4'd0;
            t3 = 4'd0;
        end
    end

endmodule