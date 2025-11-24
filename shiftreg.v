module shiftreg (
    input wire reset, clk, data, enable,
    output reg [7:0] value
);
    reg [2:0] index;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            index <= 3'd0;
            value <= 8'd0;
        end else begin
            if (enable) begin
                value[index] <= data; 
                index <= index + 3'd1;
            end
        end
    end

endmodule