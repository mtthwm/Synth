module i2c_controller (
    input wire clk, reset, enable, mode,
    input wire [6:0] periph_addr,
    input wire [7:0] transmit_byte,
    output reg [3:0] state,
    output reg scl, ready,
    output wire [7:0] read_byte,
    inout wire sda
);
    parameter READ              = 1'b0;
    parameter WRITE             = 1'b1;

    parameter IDLE              = 4'd0;
    parameter SENDING_ADDR      = 4'd1;
    parameter WAITING_ACK_0     = 4'd2;
    parameter RECEIVING_BYTE    = 4'd4;
    parameter SENDING_START     = 4'd5;
    parameter SENDING_ACK       = 4'd6;
    parameter WRITING_BYTE      = 4'd7;
    parameter WAITING_ACK_1     = 4'd8;
    parameter SENDING_STOP      = 4'd9;

    reg counter_reset;
    reg sda_driver;
    reg sda_mode;
    reg slow_clk;
    reg oop_clk;
    reg clock_div;
    reg enable_shiftreg;

    wire [7:0] counter_8_out;
    counter count8 (
        .clk(oop_clk),
        .reset(counter_reset),
        .max(8'd9),
        .value(counter_8_out)
    );

    wire [7:0] shiftreg_out;
    shiftreg sr (
        .clk(oop_clk),
        .reset(counter_reset),
        .data(sda === 1'bz ? 1'b0 : sda),
        .enable(enable_shiftreg),
        .value(shiftreg_out)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            slow_clk <= 1'b0;
            oop_clk <= 1'b0;
            clock_div <= 1'b0;
        end else begin
            if (clock_div) begin
                slow_clk <= ~slow_clk;
            end else begin
                oop_clk <= ~oop_clk;
            end
            clock_div <= ~clock_div;

            if (oop_clk && clock_div) begin
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
                        if (counter_8_out === 8'd8) begin
                            state <= WAITING_ACK_0;
                        end else begin
                            state <= SENDING_ADDR;
                        end
                    end
                    WAITING_ACK_0: begin
                        if (mode === READ) begin
                            state <= RECEIVING_BYTE;
                        end else begin
                            state <= WRITING_BYTE;
                        end
                    end
                    RECEIVING_BYTE: begin
                        if (counter_8_out === 8'd8) begin
                            state <= SENDING_ACK;
                        end else begin
                            state <= RECEIVING_BYTE;
                        end
                    end
                    WRITING_BYTE: begin
                        if (counter_8_out === 8'd8) begin
                            state <= WAITING_ACK_1;
                        end else begin
                            state <= WRITING_BYTE;
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
            end else begin
                state <= state;
            end
        end
    end

    assign sda = sda_mode === READ ? 1'bz : sda_driver;
    assign read_byte = {shiftreg_out[0], shiftreg_out[1], shiftreg_out[2], shiftreg_out[3], shiftreg_out[4], shiftreg_out[5], shiftreg_out[6], shiftreg_out[7]};

    always @(*) begin
        case (state)
            IDLE: begin
                ready = 1'b1;
                sda_driver = 1'b1;
                sda_mode = WRITE;
                scl = 1'b1;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
            SENDING_START: begin
                ready = 1'b0;
                sda_driver =1'b0;
                sda_mode = WRITE;
                scl = slow_clk;
                counter_reset = 1'b1;
                enable_shiftreg = 1'b0;
            end
            SENDING_ADDR: begin
                ready = 1'b0;
                case (counter_8_out[2:0])
                    0: sda_driver = periph_addr[6];
                    1: sda_driver = periph_addr[5];
                    2: sda_driver = periph_addr[4];
                    3: sda_driver = periph_addr[3];
                    4: sda_driver = periph_addr[2];
                    5: sda_driver = periph_addr[1];
                    6: sda_driver = periph_addr[0];
                    7: sda_driver = mode;
                endcase
                sda_mode = WRITE;
                scl = slow_clk;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
            WAITING_ACK_0: begin
                ready = 1'b0;
                sda_driver = 1'b1;
                sda_mode = READ;
                scl = slow_clk;
                counter_reset = 1'b1;
                enable_shiftreg = 1'b0;
            end
            RECEIVING_BYTE: begin
                ready = 1'b0;
                sda_driver = 1'b0;
                sda_mode = READ;
                scl = slow_clk;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b1;
            end
            WRITING_BYTE: begin
                ready = 1'b0;
                case (counter_8_out[2:0])
                    0: sda_driver = transmit_byte[7];
                    1: sda_driver = transmit_byte[6];
                    2: sda_driver = transmit_byte[5];
                    3: sda_driver = transmit_byte[4];
                    4: sda_driver = transmit_byte[3];
                    5: sda_driver = transmit_byte[2];
                    6: sda_driver = transmit_byte[1];
                    7: sda_driver = transmit_byte[0];
                endcase
                sda_mode = WRITE;
                scl = slow_clk;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
            WAITING_ACK_1: begin
                ready = 1'b0;
                sda_driver = 1'b0;
                sda_mode = READ;
                scl = slow_clk;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
            SENDING_STOP: begin
                ready = 1'b1;
                sda_driver = 1'b1;
                sda_mode = WRITE;
                scl = 1'b1;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
            default: begin
                ready = 1'b1;
                sda_driver =1'b1;
                sda_mode = WRITE;
                scl = 1'b1;
                counter_reset = 1'b0;
                enable_shiftreg = 1'b0;
            end
        endcase
    end
    

endmodule