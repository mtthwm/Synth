module tb_i2c_controller ();

    reg clk, reset, enable, mode;
    reg [6:0] periph_addr;
    reg [7:0] transmit_byte;
    wire [7:0] read_byte;
    wire ready;
    wire scl;
    wire sda;
    wire [3:0] state;
    wire [7:0] debug;

    parameter READ              = 1'b0;
    parameter WRITE             = 1'b1;

    i2c_controller i2c (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .transmit_byte(transmit_byte),
        .read_byte(read_byte),
        .ready(ready),
        .periph_addr(periph_addr),
        .state(state),
        .scl(scl),
        .sda(sda),
        .debug(debug)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        transmit_byte = 8'd7;
        mode = WRITE;
        periph_addr = 7'd5;
        enable = 1'b0;
        reset = 0; #1; reset = 1; #1; reset = 0;
        enable = 1'b1;
        #2;
        
    end

endmodule