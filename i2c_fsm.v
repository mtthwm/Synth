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


    parameter S_SEND_RESET_REG = 0;
    parameter S_SEND_RESET_VAL = 1;
    parameter S_SEND_SAMP_MODE_REG_0 = 2;
    parameter S_SEND_SAMP_MODE_VAL = 3;
    parameter S_SEND_SAMP_MODE_REG_1 = 4;
    parameter S_READ_SAMP_MODE_REG = 5;
    parameter S_SEND_ENABLE_0 = 6;
    parameter S_SEND_ENABLE_1 = 7;
    parameter S_SEND_ENABLE_2 = 8;
    parameter S_SEND_ENABLE_3 = 9;
    parameter S_SEND_ENABLE_4 = 10;

    reg pulse_ctrl, mode;
    reg [7:0] transmit_byte;
    reg [6:0] addr;
    reg [3:0] state;

    assign state_info = state;

    wire ready, enable;

    pulse_sender ps (
        .clk(clk),
        .reset(reset),
        .ctrl(pulse_ctrl),
        .pulse(enable)
    );

    i2c_controller i2c_ctl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(addr),
        .ready(ready),
        .read_byte(read_byte),
        .transmit_byte(transmit_byte),
        .scl(scl),
        .sda(sda)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 4'd0;
            pulse_ctrl <= 1'b0;
        end else begin
            case (state)
                S_SEND_RESET_REG: begin
                    state <= S_SEND_ENABLE_0;
                end
                S_SEND_ENABLE_0: begin
                    if (ready) begin
                        state <= S_SEND_RESET_VAL
                    end
                end
                S_SEND_RESET_VAL: begin
                    state <= S_SEND_ENABLE_1;
                end
                S_SEND_ENABLE_1: begin
                    if (ready) begin
                        state <= S_SEND_SAMP_MODE_REG_0;
                    end
                end
                S_SEND_SAMP_MODE_REG_0: begin
                    state <= S_SEND_ENABLE_2;
                end
                S_SEND_ENABLE_2: begin
                    if (ready) begin
                        state <= S_SEND_RESET_REG;
                    end
                end
                S_SEND_RESET_REG: begin
                    state <= S_SEND_ENABLE_3;
                end
                S_SEND_ENABLE_3: begin
                    if (ready) begin
                        state <= S_SEND_SAMP_MODE_REG_1;
                    end
                end
                S_SEND_SAMP_MODE_REG_1: begin
                    state <= S_SEND_ENABLE_4;
                end
                S_SEND_ENABLE_4: begin
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
            S_SEND_RESET_REG: begin
                mode = 1'b1;
                transmit_byte = WM8731_RESET_ADDR;
            end
            S_SEND_RESET_VAL: begin
                mode = 1'b1;
                transmit_byte = 8'b0;
            end
            S_SEND_SAMP_MODE_REG_0: begin
                mode = 1'b1;
                transmit_byte = WM8731_SAMP_CTRL_ADDR;
            end
            S_SEND_SAMP_MODE_VAL: begin
                mode = 1'b1;
                transmit_byte = 8'b00100000;
            end
            S_SEND_SAMP_MODE_REG_1: begin
                mode = 1'b1;
                transmit_byte = WM8731_SAMP_CTRL_ADDR;
            end
            S_READ_SAMP_MODE_REG: begin
                mode = 1'b0;
                transmit_byte = WM8731_RESET_ADDR;
            end
            default: begin
                mode = 1'b0;
                transmit_byte = WM8731_RESET_ADDR;
            end
        endcase

    end

endmodule