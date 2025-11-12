module pulse_sender (
    input wire clk, reset, ctrl,
    output reg pulse
);
    reg prev;

    always @(posedge reset, posedge clk) begin
        if (reset) begin
            prev <= ctrl;
            pulse <= 1'b0;
        end else begin
            if (ctrl != prev) begin
                pulse <= ~pulse;
                prev <= ctrl;
            end
        end
    end

endmodule