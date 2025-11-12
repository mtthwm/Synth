module pullup_test (
    input wire in_pin,
    input wire btn,
    inout wire sda,
    output wire led
);


    always @(*) begin
        sda = btn ? 1'bz : 1'b0;
        led = in_pin;
    end

endmodule