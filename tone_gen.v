module tone_gen #(parameter CLOCK_SPEED = 32'd25_000_000) (
    input wire [3:0] tone,
    output reg [15:0] period
);
    parameter C4 = 0;
    parameter D4 = 1;
    parameter E4 = 2;
    parameter F4 = 3;

    parameter C4_FREQ = 1;//32'd262;
    parameter D4_FREQ = 2;//32'd294;
    parameter E4_FREQ = 4;//32'd330;
    parameter F4_FREQ = 5;//32'd349;

    parameter C4_period = CLOCK_SPEED / C4_FREQ;
    parameter D4_period = CLOCK_SPEED / D4_FREQ;
    parameter E4_period = CLOCK_SPEED / E4_FREQ;
    parameter F4_period = CLOCK_SPEED / F4_FREQ;

    always @(*) begin
        case (tone)
            C4: period = C4_period;
            D4: period = D4_period;
            E4: period = E4_period;
            F4: period = F4_period;
            default: period = CLOCK_SPEED;
        endcase
    end


endmodule