module i2c_fsm (
    input wire clk, reset,
    inout wire sda,
    output wire scl,
    output wire [7:0] read_byte,
    output wire [3:0] state_info
);

    parameter WM8731_PERIPH_ADDR = 8'b0011010; // IF CSB = 0: 0011010 ELSE 0011011
    parameter WM8731_RESET_ADDR = 8'b0001111;
    parameter WM8731_AUDIO_INTERFACE_ADDR = 8'b0000111;
    parameter WM8731_SAMP_CTRL_ADDR = 8'b0001000;

    parameter S_IDLE = 4'd0;
    parameter S_WRITE_RESET_ADDR = 4'd1;
    parameter S_WRITE_RESET_VAL = 4'd2;
    parameter S_PAUSE_0 = 4'd3;
    parameter S_WRITE_AUDIO_INTERFACE_ADDR = 4'd4;
    parameter S_WRITE_AUDIO_INTERFACE_VAL = 4'd5;
    parameter S_FINISHED = 4'd15;

    reg mode;
    reg [7:0] input_byte;
    reg [6:0] addr;
    reg [3:0] state;

    assign state_info = state;

    wire ready; 
    wire write_in_progress;
    reg prev_write_in_progress;
    reg enable;

    i2c_controller i2c_ctl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(addr),
        .ready(ready),
        .write_in_progress(write_in_progress),
        .byte_reg(read_byte),
        .input_byte(input_byte),
        .scl(scl),
        .sda(sda)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            prev_write_in_progress <= 1'b0;
        end else begin
            case (state)
                S_IDLE: state <= S_WRITE_RESET_ADDR;
                S_WRITE_RESET_ADDR: begin
                    if (write_in_progress && prev_write_in_progress == 1'b0) begin
                        state <= S_WRITE_RESET_VAL;
                    end
                end
                S_WRITE_RESET_VAL: begin
                    if (write_in_progress && prev_write_in_progress == 1'b0) begin
                        state <= S_PAUSE_0;
                    end
                end
                S_PAUSE_0: begin
                    if (ready) begin
                        state <= S_WRITE_AUDIO_INTERFACE_ADDR;
                    end
                end
                S_WRITE_AUDIO_INTERFACE_ADDR: begin
                    if (write_in_progress && prev_write_in_progress == 1'b0) begin
                        state <= S_WRITE_AUDIO_INTERFACE_VAL;
                    end
                end
                S_WRITE_AUDIO_INTERFACE_VAL: begin
                    if (write_in_progress && prev_write_in_progress == 1'b0) begin
                        state <= S_FINISHED;
                    end
                end
                S_FINISHED: state <= S_FINISHED;
            endcase
            prev_write_in_progress <= write_in_progress;
        end
    end

    always @(*) begin
        addr = WM8731_PERIPH_ADDR;
        mode = 1'b1;
        case (state)
            S_IDLE: begin
                input_byte = 8'b0;
                enable = 1'b0;
            end
            S_WRITE_RESET_ADDR: begin
                input_byte = WM8731_RESET_ADDR;
                enable = 1'b1;
            end
            S_WRITE_RESET_VAL: begin
                input_byte = 8'b0;
                enable = 1'b1;
            end
            S_PAUSE_0: begin
                input_byte = 8'b0;
                enable = 1'b0;
            end
            S_WRITE_AUDIO_INTERFACE_ADDR: begin
                input_byte = WM8731_AUDIO_INTERFACE_ADDR;
                enable = 1'b1;
            end
            S_WRITE_AUDIO_INTERFACE_VAL: begin
                input_byte = 8'b10000000;
                enable = 1'b1;
            end
            S_FINISHED: begin
                input_byte = 8'b0;
                enable = 1'b0;
            end
        endcase

    end

endmodule