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

    parameter S_IDLE = 0;
    parameter S_TARGET_CONTROL_REG_0 = 1;
    parameter S_SENDING_CONTROL_REG_ADDR = 2;
    parameter S_PREPARING_CONTROL_VAL = 3;
    parameter S_SENDING_CONTROL_VAL = 4;
    parameter S_TARGET_CONTROL_REG_2 = 5;
    parameter S_READING_CONTROL_REG = 6;

    reg mode;
    reg [7:0] transmit_byte;
    reg [6:0] addr;
    reg [3:0] state, cached_state;

    assign state_info = state;

    wire ready; 
    reg enable;

    i2c_controller i2c_ctl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(addr),
        .ready(ready),
        .byte_reg(read_byte),
        .transmit_byte(transmit_byte),
        .scl(scl),
        .sda(sda)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    state <= S_TARGET_CONTROL_REG_0;
                end
                S_TARGET_CONTROL_REG_0: begin
                    state <= S_SENDING_CONTROL_REG_ADDR;
                end
                S_SENDING_CONTROL_REG_ADDR: begin
                    if (ready) begin
                        state <= S_PREPARING_CONTROL_VAL;
                    end
                end
                S_PREPARING_CONTROL_VAL: begin
                    state <= S_SENDING_CONTROL_VAL;
                end
                S_SENDING_CONTROL_VAL: begin
                    if (ready) begin
                        state <= S_TARGET_CONTROL_REG_2;
                    end
                end
                S_TARGET_CONTROL_REG_2: begin
                    state <= S_READING_CONTROL_REG;
                end
                S_READING_CONTROL_REG: begin
                    state <= S_READING_CONTROL_REG;
                end
        endcase
        end
    end

    always @(*) begin
        addr = WM8731_PERIPH_ADDR;
        case (state)
            S_IDLE: begin
                enable = 1'b0;
                mode = 1'b0;
                transmit_byte = 8'b0;
            end
            S_TARGET_CONTROL_REG_0: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = WM8731_RESET_ADDR;
            end
            S_SENDING_CONTROL_REG_ADDR: begin
                enable = 1'b0;
                mode = 1'b1;
                transmit_byte = WM8731_RESET_ADDR;
            end
            S_PREPARING_CONTROL_VAL: begin
                enable = 1'b1;
                mode = 1'b1;
                transmit_byte = 8'b10101011;
            end
            S_SENDING_CONTROL_VAL: begin
                enable = 1'b0;
                mode = 1'b1;
                transmit_byte = 8'b10101011;
            end
            S_TARGET_CONTROL_REG_2: begin
                enable = 1'b1;
                mode = 1'b0;
                transmit_byte = WM8731_RESET_ADDR;
            end
            S_READING_CONTROL_REG: begin
                enable = 1'b0;
                mode = 1'b0;
                transmit_byte = 8'b0;
            end
        endcase

    end

endmodule