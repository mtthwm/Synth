module tflipflop (
    input wire T, reset,
    output reg Q
);

always @(posedge T, posedge reset) begin
    if (reset) begin
        Q = 1'd0;
    end else begin
        Q = ~Q;
    end
end

endmodule