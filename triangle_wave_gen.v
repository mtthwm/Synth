module triangle_wave_gen (
	input wire clk, reset,
	input wire [31:0] period,
	output reg [7:0] value
);

    reg [31:0] sixteenth_period;

    reg [3:0] step_index;
	reg [31:0] t;

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			t <= 32'd0;
            step_index <= 4'd0;
		end else begin
			if (t >= sixteenth_period) begin
				t <= 32'd0;
                step_index <= step_index + 4'd1;
			end else begin
				t <= t + 32'd1;
			end
		end
	end

    always @(*) begin
        sixteenth_period = period >> 4;
        case (step_index)
            0: value <= 8'd30;
            1: value <= 8'd60;
            2: value <= 8'd90;
            3: value <= 8'd120;
            4: value <= 8'd150;
            5: value <= 8'd180;
            6: value <= 8'd210;
            7: value <= 8'd240;
            8: value <= 8'd210;
            9: value <= 8'd180;
            10: value <= 8'd150;
            11: value <= 8'd120;
            12: value <= 8'd90;
            13: value <= 8'd60;
            14: value <= 8'd30;
            15: value <= 8'd0;
            default: value <= 8'd0;
        endcase
    end

endmodule