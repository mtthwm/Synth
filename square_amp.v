module square_amp (
    input wire in,
    output wire [15:0] out
);

    parameter GAIN = 16'd32768;

    assign out = in ? GAIN : 16'd0;

endmodule