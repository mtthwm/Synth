module triangle_wave_gen (
	input wire clk, reset,
	input wire [31:0] period,
	output reg [7:0] value
);

    reg [31:0] eighth_period;

    reg [2:0] step_index;
	reg [31:0] t;

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			t <= 32'd0;
            step_index <= 4'd0;
		end else begin
			if (t >= eighth_period) begin
				t <= 32'd0;
                step_index <= step_index + 4'd1;
			end else begin
				t <= t + 32'd1;
			end
		end
	end

    always @(*) begin
        eighth_period = period >> 4;
        case (step_index)
            0: value = 8'd64;
            1: value = 8'd128;
            2: value = 8'd192;
            3: value = 8'd255;
            4: value = 8'd255;
            5: value = 8'd192;
            6: value = 8'd128;
            7: value = 8'd64;
            default: value = 8'd0;
        endcase
    end

endmodule