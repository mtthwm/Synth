module square_amp (
    input wire in,
    output wire [7:0] out
);

    parameter GAIN = 10'd255;

    assign out = in ? GAIN : 10'd0;

endmodule