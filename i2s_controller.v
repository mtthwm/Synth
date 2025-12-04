module i2s_controller (
    input wire clk, reset,
    input wire [15:0] sample_left, sample_right,
    output wire bit_clk, data, 
    output reg frame_clk
);    

    function [15:0] reverse_bit_order (
        input [15:0] data
    );
    integer i;
    begin
        for (i=0; i < 16; i=i+1) begin : reverse
            reverse_bit_order[15-i] = data[i];
        end
    end
    endfunction

    reg slow_clk, oop_clk;
    reg [15:0] left_cache, right_cache;

    wire [31:0] all_data;
    wire [7:0] counter_out;

    aud_counter cnt (
        .clk(oop_clk),
        .reset(reset),
        .max(8'd32),
        .value(counter_out),
        .enable(1'b1)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            slow_clk <= 1'b0;
            oop_clk <= 1'b1;
        end else begin
            slow_clk <= ~slow_clk;
            oop_clk <= ~oop_clk;
        end
    end

    always @(posedge oop_clk, posedge reset) begin
        if (reset) begin
            frame_clk <= 1'b0;
        end else begin
            if (counter_out == 8'd14) begin
                frame_clk <= 1'b1;
            end
            if (counter_out == 8'd30) begin
                frame_clk <= 1'b0;
            end 
        end  
    end

    assign bit_clk = slow_clk;
    assign all_data = {left_cache, right_cache};
    assign data = all_data[counter_out[4:0]];

    always @(posedge frame_clk, posedge reset) begin
        left_cache <= reverse_bit_order(sample_left);
        right_cache <= reverse_bit_order(sample_right);
    end

endmodule