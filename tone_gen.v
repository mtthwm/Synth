module tone_gen #(parameter CLOCK_SPEED = 32'd25_000_000) (
    input wire [3:0] tone0, tone1, tone2, tone3,
    output reg [31:0] period0, period1, period2, period3
);
    parameter SILENT = 4'd0;
    parameter A3 = 4'd1;
    parameter B3 = 4'd2;
    parameter C4 = 4'd3;
    parameter D4 = 4'd4;
    parameter E4 = 4'd5;
    parameter F4 = 4'd6;
    parameter G4 = 4'd7;
    parameter A4 = 4'd8;
    parameter B4 = 4'd9;
    parameter C5 = 4'd10;
    parameter D5 = 4'd11;
    parameter E5 = 4'd12;
    parameter F5 = 4'd13;
    parameter G5 = 4'd14;
    parameter A5 = 4'd15;

    parameter A3_period = 32'd41844;
    parameter B3_period = 32'd37278;
    parameter C4_period = 32'd35186;
    parameter D4_period = 32'd31347;
    parameter E4_period = 32'd27927;
    parameter F4_period = 32'd26360;
    parameter G4_period = 32'd23484;
    parameter A4_period = 32'd20922;
    parameter B4_period = 32'd18639;
    parameter C5_period = 32'd17593;
    parameter D5_period = 32'd15674;
    parameter E5_period = 32'd13964;
    parameter F5_period = 32'd13180;
    parameter G5_period = 32'd11742;
    parameter A5_period = 32'd10461;

    always @(*) begin
        case (tone0)
            SILENT: period0 = 32'd0;
            A3: period0 = A3_period;
            B3: period0 = B3_period;
            C4: period0 = C4_period;
            D4: period0 = D4_period;
            E4: period0 = E4_period;
            F4: period0 = F4_period;
            G4: period0 = G4_period;
            A4: period0 = A4_period;
            B4: period0 = B4_period;
            C5: period0 = C5_period;
            D5: period0 = D5_period;
            E5: period0 = E5_period;
            F5: period0 = F5_period;
            G5: period0 = G5_period;
            A5: period0 = A5_period;
            default: period0 = C4_period;
        endcase
        case (tone1)
            SILENT: period1 = 32'd0;
            A3: period1 = A3_period;
            B3: period1 = B3_period;
            C4: period1 = C4_period;
            D4: period1 = D4_period;
            E4: period1 = E4_period;
            F4: period1 = F4_period;
            G4: period1 = G4_period;
            A4: period1 = A4_period;
            B4: period1 = B4_period;
            C5: period1 = C5_period;
            D5: period1 = D5_period;
            E5: period1 = E5_period;
            F5: period1 = F5_period;
            G5: period1 = G5_period;
            A5: period1 = A5_period;
            default: period1 = C4_period;
        endcase
        case (tone2)
            SILENT: period2 = 32'd0;
            A3: period2 = A3_period;
            B3: period2 = B3_period;
            C4: period2 = C4_period;
            D4: period2 = D4_period;
            E4: period2 = E4_period;
            F4: period2 = F4_period;
            G4: period2 = G4_period;
            A4: period2 = A4_period;
            B4: period2 = B4_period;
            C5: period2 = C5_period;
            D5: period2 = D5_period;
            E5: period2 = E5_period;
            F5: period2 = F5_period;
            G5: period2 = G5_period;
            A5: period2 = A5_period;
            default: period2 = C4_period;
        endcase
        case (tone3)
            SILENT: period3 = 32'd0;
            A3: period3 = A3_period;
            B3: period3 = B3_period;
            C4: period3 = C4_period;
            D4: period3 = D4_period;
            E4: period3 = E4_period;
            F4: period3 = F4_period;
            G4: period3 = G4_period;
            A4: period3 = A4_period;
            B4: period3 = B4_period;
            C5: period3 = C5_period;
            D5: period3 = D5_period;
            E5: period3 = E5_period;
            F5: period3 = F5_period;
            G5: period3 = G5_period;
            A5: period3 = A5_period;
            default: period3 = C4_period;
        endcase
    end


endmodule