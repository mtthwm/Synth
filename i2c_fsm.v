module i2c_fsm (
    input wire clk, reset,
    inout wire sda,
    output wire scl,
    output wire [7:0] read_byte,
    output wire [3:0] state_info,
    output wire [7:0] debug
);

    parameter WM8731_PERIPH_ADDR = 8'b0001_1010; // IF CSB = 0: 0011010 ELSE 0011011
    parameter WM8731_RESET_ADDR = 8'b0000_1111;
    parameter WM8731_AUDIO_INTERFACE_ADDR = 8'b0000_0111;
    parameter WM8731_AUDIO_INTERFACE_VAL = 8'b1000_0000;
    parameter WM8731_SAMP_CTRL_ADDR = 8'b0000_1000;

    parameter S_WRITE_RESET_ADDR = 0;
    parameter S_WRITE_RESET_VAL = 1;
    parameter S_PAUSE_0 = 2;
    parameter S_WRITE_AUDIO_INTERFACE_ADDR = 3;
    parameter S_WRITE_AUDIO_INTERFACE_VAL = 4;
    parameter S_FINISHED = 5;
    parameter S_WAIT_FOR_WRITE_FINISH_0 = 6;
    parameter S_WAIT_FOR_WRITE_FINISH_1 = 7;
    parameter S_WAIT_FOR_WRITE_FINISH_2 = 8;


    reg mode;
    reg [7:0] input_byte;
    reg [6:0] addr;
    reg [3:0] state;

    // assign state_info = state;

    wire ready; 
    wire write_in_progress;
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
        .sda(sda),
        .state(state_info),
        .debug(debug)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= S_WRITE_RESET_ADDR;
        end else begin
            case (state)
                S_WRITE_RESET_ADDR: begin
                    if (write_in_progress) begin
                        state <= S_WAIT_FOR_WRITE_FINISH_0;
                    end
                end
                S_WAIT_FOR_WRITE_FINISH_0: begin
                    if (!write_in_progress) begin
                        state <= S_WRITE_RESET_VAL;
                    end
                end
                S_WRITE_RESET_VAL: begin
                    if (write_in_progress) begin
                        state <= S_WAIT_FOR_WRITE_FINISH_1;
                    end
                end
                S_WAIT_FOR_WRITE_FINISH_1: begin
                    if (!write_in_progress) begin
                        state <= S_PAUSE_0;
                    end
                end
                S_PAUSE_0: begin
                    if (ready) begin
                        state <= S_WRITE_AUDIO_INTERFACE_ADDR;
                    end
                end
                S_WRITE_AUDIO_INTERFACE_ADDR: begin
                    if (write_in_progress) begin
                        state <= S_WAIT_FOR_WRITE_FINISH_2;
                    end
                end
                S_WAIT_FOR_WRITE_FINISH_2: begin
                    if (!write_in_progress) begin
                        state <= S_WRITE_AUDIO_INTERFACE_VAL;
                    end
                end
                S_WRITE_AUDIO_INTERFACE_VAL: begin
                    if (write_in_progress) begin
                        state <= S_FINISHED;
                    end
                end
                S_FINISHED: state <= S_FINISHED;
                default: state <= S_WRITE_RESET_ADDR;
            endcase
        end
    end

    always @(*) begin
        addr = WM8731_PERIPH_ADDR[6:0];
        mode = 1'b1;
        case (state)
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
                input_byte = WM8731_AUDIO_INTERFACE_VAL;
                enable = 1'b1;
            end
            S_FINISHED: begin
                input_byte = 8'b0;
                enable = 1'b0;
            end
            default: begin
                input_byte = 8'b0;
                enable = 1'b0;
            end
        endcase

    end

endmodule