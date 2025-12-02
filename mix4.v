module mix4 (
    input wire [7:0] samp0, samp1, samp2, samp3,
    output reg [15:0] samp_out
);
    always @(*) begin
        samp_out = {8'd0, samp0} + {8'd0, samp1} + {8'd0, samp2} + {8'd0, samp3};
    end

endmodule