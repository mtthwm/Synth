module i2c_fsm (
    input wire clk, reset,
    inout wire sda,
    output wire scl,
    output wire [7:0] read_byte,
    output wire [3:0] state_info
);

    parameter WM8731_PERIPH_ADDR = 7'b0011010; // IF CSB = 0: 0011010 ELSE 0011011
    parameter WM8731_RESET_ADDR = 7'b0001111;
    parameter WM8731_SAMP_CTRL_ADDR = 7'b0001000;

    parameter S_START = 4'd0;
    parameter S_SEND_ENABLE = 4'd1;
    parameter S_SEND_RESET_REG = 4'd2;
    parameter S_SEND_RESET_VAL = 4'd3;
    parameter S_SEND_SAMP_MODE_REG_0 = 4'd4;
    parameter S_SEND_SAMP_MODE_VAL = 4'd5;
    parameter S_SEND_SAMP_MODE_REG_1 = 4'd6;
    parameter S_READ_SAMP_MODE_REG = 4'd7;

    reg mode;
    reg [7:0] transmit_byte;
    reg [6:0] addr;
    reg [3:0] state;

    wire ready; 
    reg enable;

    i2c_controller i2c_ctl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(addr),
        .ready(ready),
        .read_byte(read_byte),
        .transmit_byte(transmit_byte),
        .state(state_info),
        .scl(scl),
        .sda(sda)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= S_START;
        end else begin
            case (state)
                S_START: begin
                    state <= S_SEND_ENABLE;
                end
                S_SEND_ENABLE: begin
                    state <= S_SEND_RESET_REG;
                end
                S_SEND_RESET_REG: begin
                    if (ready) begin
                        state <= S_SEND_RESET_VAL;
                    end
                end
                S_SEND_RESET_VAL: begin
                    if (ready) begin
                        state <= S_SEND_SAMP_MODE_REG_0;
                    end
                end
                S_SEND_SAMP_MODE_REG_0: begin
                    if (ready) begin
                        state <= S_SEND_SAMP_MODE_VAL;
                    end
                end
                S_SEND_SAMP_MODE_VAL: begin
                    if (ready) begin
                        state <= S_SEND_SAMP_MODE_REG_1;
                    end
                end
                S_SEND_SAMP_MODE_REG_1: begin
                    if (ready) begin
                        state <= S_READ_SAMP_MODE_REG;
                    end
                end
                S_READ_SAMP_MODE_REG: begin
                    state <= S_READ_SAMP_MODE_REG;
                end
                default: begin
                    state <= S_SEND_RESET_REG;
                end
        endcase
        end
    end

    always @(*) begin
        addr = WM8731_PERIPH_ADDR;
        case (state)
            S_START: begin
                enable = 1'b0;
                mode = 1'b0;
                transmit_byte = 8'b0;
            end
            S_SEND_ENABLE: begin
                enable = 1'b1;
                mode = 1'b0;
                transmit_byte = 8'b0;
            end
            S_SEND_RESET_REG: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = WM8731_RESET_ADDR;
            end
            S_SEND_RESET_VAL: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = 8'b0;
            end
            S_SEND_SAMP_MODE_REG_0: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = WM8731_SAMP_CTRL_ADDR;
            end
            S_SEND_SAMP_MODE_VAL: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = 8'b00100000;
            end
            S_SEND_SAMP_MODE_REG_1: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = WM8731_SAMP_CTRL_ADDR;
            end
            S_READ_SAMP_MODE_REG: begin
                enable = 1'b1;
                mode = 1'b0;
                transmit_byte = WM8731_RESET_ADDR;
            end
            default: begin
                enable = 1'b0;
                mode = 1'b0;
                transmit_byte = 8'd0;
            end
        endcase

    end

endmodule