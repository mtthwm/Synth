module tone_gen #(parameter CLOCK_SPEED = 32'd25_000_000) (
    input wire [3:0] tone,
    output reg [31:0] period
);
    parameter SILENT = 4'd0;
    parameter A4 = 4'd1;
    parameter B4 = 4'd2;
    parameter C4 = 4'd3;
    parameter D4 = 4'd4;
    parameter E4 = 4'd5;
    parameter F4 = 4'd6;
    parameter G4 = 4'd7;
    parameter A5 = 4'd8;
    parameter B5 = 4'd9;
    parameter C5 = 4'd10;
    parameter D5 = 4'd11;
    parameter E5 = 4'd12;
    parameter F5 = 4'd13;
    parameter G5 = 4'd14;
    parameter A6 = 4'd15;

    parameter A4_FREQ = 220;
    parameter B4_FREQ = 247;
    parameter C4_FREQ = 262;
    parameter D4_FREQ = 294;
    parameter E4_FREQ = 330;
    parameter F4_FREQ = 349;
    parameter G4_FREQ = 392;
    parameter A5_FREQ = 440;
    parameter B5_FREQ = 494;
    parameter C5_FREQ = 523;
    parameter D5_FREQ = 587;
    parameter E5_FREQ = 659;
    parameter F5_FREQ = 698;
    parameter G5_FREQ = 784;
    parameter A6_FREQ = 880;

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
    parameter A6_period = CLOCK_SPEED / A6_FREQ;

    always @(*) begin
        case (tone)
            SILENT: period = 32'd0;
            A4: period = A4_period;
            B4: period = B4_period;
            C4: period = C4_period;
            D4: period = D4_period;
            E4: period = E4_period;
            F4: period = F4_period;
            G4: period = G4_period;
            A5: period = A5_period;
            B5: period = B5_period;
            C5: period = C5_period;
            D5: period = D5_period;
            E5: period = E5_period;
            F5: period = F5_period;
            G5: period = G5_period;
            A6: period = A6_period;
            default: period = C4_period;
        endcase
    end


endmodule