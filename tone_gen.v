module tone_gen #(parameter CLOCK_SPEED = 32'd25_000_000) (
    input wire [3:0] tone,
    output reg [31:0] period
);
    parameter A4 = 4'd0;
    parameter B4 = 4'd1;
    parameter C4 = 4'd2;
    parameter D4 = 4'd3;
    parameter E4 = 4'd4;
    parameter F4 = 4'd5;
    parameter G4 = 4'd6;
    parameter A5 = 4'd7;
    parameter B5 = 4'd8;
    parameter C5 = 4'd9;
    parameter D5 = 4'd10;
    parameter E5 = 4'd11;
    parameter F5 = 4'd12;
    parameter G5 = 4'd13;

    parameter A4_FREQ = 32'd233;
    parameter B4_FREQ = 32'd247;
    parameter C4_FREQ = 32'd262;
    parameter D4_FREQ = 32'd294;
    parameter E4_FREQ = 32'd330;
    parameter F4_FREQ = 32'd349;
    parameter G4_FREQ = 32'd392;
    parameter A5_FREQ = 32'd440;
    parameter B5_FREQ = 32'd523;
    parameter C5_FREQ = 32'd587;
    parameter D5_FREQ = 32'd587;
    parameter E5_FREQ = 32'd659;
    parameter F5_FREQ = 32'd698;
    parameter G5_FREQ = 32'd784;

    parameter A4_period = CLOCK_SPEED / A4_FREQ;
    parameter B4_period = CLOCK_SPEED / B4_FREQ;
    parameter C4_period = CLOCK_SPEED / C4_FREQ;
    parameter D4_period = CLOCK_SPEED / D4_FREQ;
    parameter E4_period = CLOCK_SPEED / E4_FREQ;
    parameter F4_period = CLOCK_SPEED / F4_FREQ;
    parameter G4_period = CLOCK_SPEED / G4_FREQ;
    parameter A5_period = CLOCK_SPEED / A5_FREQ;
    parameter B5_period = CLOCK_SPEED / B5_FREQ;
    parameter C5_period = CLOCK_SPEED / C5_FREQ;
    parameter D5_period = CLOCK_SPEED / D5_FREQ;
    parameter E5_period = CLOCK_SPEED / E5_FREQ;
    parameter F5_period = CLOCK_SPEED / F5_FREQ;
    parameter G5_period = CLOCK_SPEED / G5_FREQ;

    always @(*) begin
        case (tone)
            A4: period = A4_period;
            B4: period = B4_period;
            C4: period = C4_period;
            D4: period = D4_period;
            E4: period = E4_period;
            F4: period = F4_period;
            G4: period = G4_period;
            A4: period = A4_period;
            B4: period = B4_period;
            C4: period = C4_period;
            D4: period = D4_period;
            E4: period = E4_period;
            F4: period = F4_period;
            G4: period = G4_period;
            default: period = C4_period;
        endcase
    end


endmodule