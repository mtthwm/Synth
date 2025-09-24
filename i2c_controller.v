module i2c_controller (
    input wire clk, reset, enable, mode,
    input wire [6:0] periph_addr,
    input wire [7:0] byte,
    output wire sdc,
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

    reg [2:0] state;
    reg counter8Reset;
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
                    if (counter8Out === 8'd7) begin
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
            endcase
        end
    end

    always @(*) begin
    
    end
    

endmodule