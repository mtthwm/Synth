// This module is an implementation of a linear feedback shift register (LFSR): https://en.wikipedia.org/wiki/Linear-feedback_shift_register
module lsfr (
    input wire clk, reset,
    output reg [15:0] data
);
    parameter INITIAL = 16'b10001011001010010;

    reg [3:0] index;
    reg [15:0] sreg;
    reg [15:0] composite;
    reg [15:0] buff;
    reg xored;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            sreg <= INITIAL;
            data <= INITIAL;
            index <= 4'd0;
        end else begin
            index <= index + 4'd1;
            sreg[15] <= sreg[0] ^ sreg[2] ^ sreg[3] ^ sreg[5];
            sreg[14] <= sreg[15]; 
            sreg[13] <= sreg[14]; 
            sreg[12] <= sreg[13]; 
            sreg[11] <= sreg[12]; 
            sreg[10] <= sreg[11]; 
            sreg[9] <= sreg[10]; 
            sreg[8] <= sreg[9]; 
            sreg[7] <= sreg[8]; 
            sreg[6] <= sreg[7]; 
            sreg[5] <= sreg[6];
            sreg[4] <= sreg[5]; 
            sreg[3] <= sreg[4]; 
            sreg[2] <= sreg[3]; 
            sreg[1] <= sreg[2]; 
            sreg[0] <= sreg[1];  
            buff[index] = sreg[0];
            if (index == 4'd15) begin
                data <= buff;
            end
        end
    end

endmodule