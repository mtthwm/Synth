module i2c_fsm (
    input wire clk, reset,
    output wire sda, scl,
    output reg [1:0] state
);

    reg enable, mode;
    reg [7:0] transmit_byte;
    reg [6:0] addr;

    wire ready;

    i2c_controller i2c_ctl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(addr),
        .ready(ready),
        .transmit_byte(transmit_byte),
        .scl(scl),
        .sda(sda)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 2'd0;
        end else begin
            case (state)
                0: begin
                    state <= 2'b1;
                end
                1: begin
                    if (ready) begin
                        state <= 2'd2;
                    end else begin
                        state <= 2'd1;
                    end
                end
                2: begin
                    state <= 0;
                end
        endcase
        end
    end

    always @(*) begin
        transmit_byte = 8'd234;
        addr = 7'd5;
        mode = 1'b1;
        
        case (state)
            0: begin
                enable = 1'b1;
            end
            1: begin
                enable = 1'b1;
            end
            2: begin
                enable =1'b0;
            end
        endcase
    end

endmodule