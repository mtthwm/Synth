module i2s (
	input wire reset, clk,
	input wire [7:0] word_length,
	input wire [15:0] send_queue_left,	
	input wire [15:0] send_queue_right,
	output wire frame_clk, 
	output reg bit_clk, data,
	output wire [7:0] counter_out
);

	reg counter_at_max;

	counter cnt (
		.reset(reset),
		.clk(clk),
		.max(word_length),
		.value(counter_out)
	);

	tflipflop ff (
		.reset(reset),
		.T(counter_at_max),
		.Q(frame_clk)
	);
	
	always @(*) begin
		counter_at_max = counter_out === 8'd0;
		data = frame_clk ? send_queue_left[counter_out] : send_queue_right[counter_out];
		bit_clk = clk;
	end

endmodule