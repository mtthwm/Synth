module mix4 (
    input wire [7:0] samp0, samp1, samp2, samp3,
    output wire [15:0] samp_out
);

    assign samp_out = {8'd0, samp0} + {8'd0, samp1} + {8'd0, samp2} + {8'd0, samp3};

endmodule