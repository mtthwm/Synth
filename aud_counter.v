module aud_counter (
    input wire clk, reset, enable,
    input wire[7:0] max,
    output reg [7:0] value
);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            value <= 8'd0;
        end else begin
            if (enable) begin
                if (value === max-1) begin
                    value <= 8'd0;
                end else begin
                    value <= value + 8'd1;
                end
            end
        end
    end

endmodule