module i2c_controller (
    input wire clk, reset, enable, mode,
    input wire [6:0] periph_addr,
    input wire [7:0] byte,
    output reg [3:0] state,
    output reg sdc,
    inout wire sda
);
    parameter READ              = 1'b0;
    parameter WRITE             = 1'b1;

    parameter IDLE              = 4'd0;
    parameter SENDING_ADDR      = 4'd1;
    parameter WAITING_ACK_0     = 4'd2;
    parameter SENDING_MODE      = 4'd3;
    parameter RECEIVING_BYTE    = 4'd4;
    parameter SENDING_START     = 4'd5;
    parameter SENDING_ACK       = 4'd6;
    parameter WRITING_BYTE      = 4'd7;
    parameter WAITING_ACK_1     = 4'd8;
    parameter SENDING_STOP      = 4'd9;

    reg counter8Reset;
    reg sda_driver;
    reg sda_mode;
    wire [7:0] counter8Out;

    counter count8 (
        .clk(clk),
        .reset(counter8Reset),
        .max(8'd8),
        .value(counter8Out)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter8Reset = 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        state <= SENDING_START;
                    end else begin
                        state <= IDLE;
                    end
                end
                SENDING_START: begin
                    state <= SENDING_ADDR;
                end
                SENDING_ADDR: begin
                    if (counter8Out === 8'd6) begin
                        state <= SENDING_MODE;
                    end else begin
                        state <= SENDING_ADDR;
                    end
                end
                SENDING_MODE: begin
                    state <= WAITING_ACK_0;
                end
                WAITING_ACK_0: begin
                    if (mode === READ) begin
                        state <= RECEIVING_BYTE;
                    end else begin
                        state <= WRITING_BYTE;
                    end
                end
                RECEIVING_BYTE: begin
                    if (counter8Out === 8'd7) begin
                        state <= SENDING_ACK;
                    end else begin
                        state <= RECEIVING_BYTE;
                    end
                end
                WRITING_BYTE: begin
                    if (counter8Out === 8'd7) begin
                        state <= WAITING_ACK_0;
                    end else begin
                        state <= RECEIVING_BYTE;
                    end
                end
                WAITING_ACK_1: begin
                    state <= SENDING_STOP;
                end
                SENDING_STOP: begin
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign sda = sda_mode === READ ? 1'bz : sda_driver;

    always @(*) begin
        case (state)
            IDLE: begin
                sda_driver = 1'b1;
                sda_mode = WRITE;
                sdc = 1'b1;
                counter8Reset = 1'b0;
            end
            SENDING_START: begin
                sda_driver =1'b0;
                sda_mode = WRITE;
                sdc = 1'b1;
                counter8Reset = 1'b1;
            end
            SENDING_ADDR: begin
                sda_driver = periph_addr[counter8Out[3:0]];
                sda_mode = WRITE;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            SENDING_MODE: begin
                sda_driver = mode;
                sda_mode = WRITE;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            WAITING_ACK_0: begin
                sda_driver = 1'b1;
                sda_mode = READ;
                sdc = clk;
                counter8Reset = 1'b1;
            end
            RECEIVING_BYTE: begin
                sda_driver = 1'b0;
                sda_mode = READ;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            WRITING_BYTE: begin
                sda_driver = byte[counter8Out[3:0]];
                sda_mode = WRITE;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            WAITING_ACK_1: begin
                sda_driver = 1'b0;
                sda_mode = READ;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            SENDING_STOP: begin
                sda_driver = 1'b1;
                sda_mode = WRITE;
                sdc = clk;
                counter8Reset = 1'b0;
            end
            default: begin
                sda_driver =1'b1;
                sda_mode = WRITE;
                sdc = 1'b1;
                counter8Reset = 1'b0;
            end
        endcase
    end
    

endmodule