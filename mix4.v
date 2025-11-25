module mix4 (
    input wire [7:0] samp0, samp1, samp2, samp3,
    output wire [15:0] samp_out
);

    assign samp_out = samp0 + samp1 + samp2 + samp3;

endmodule