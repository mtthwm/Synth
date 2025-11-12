module square_wave_gen (
	input wire clk, reset,
	input wire [31:0] period,
	input wire [31:0] duty_cycle,
	output reg value
);

	reg [31:0] t;

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			t = 32'd0;
			value <= 1'b0;
		end else begin
			if (t === period) begin
				t <= 32'b0;
			end else begin
				t <= t + 32'b1;
				if (t < duty_cycle) begin
					value <= 1'b1;
				end else begin
					value <= 1'b0;
				end
			end
		end
	end

endmodule