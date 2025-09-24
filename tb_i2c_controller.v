module tb_i2c_controller ();

    reg clk, reset, enable, mode;
    reg [6:0] periph_addr;
    reg [7:0] byte;
    wire [7:0] read_byte;
    wire ready;
    wire sdc;
    wire sda;
    reg sda_mode;
    reg sda_driver;

    parameter READ              = 1'b0;
    parameter WRITE             = 1'b1;

    assign sda = sda_mode === READ ? 1'bz : sda_driver;

    i2c_controller i2c (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .byte(byte),
        .read_byte(read_byte),
        .ready(ready),
        .periph_addr(periph_addr),
        .sdc(sdc),
        .sda(sda)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        sda_mode = READ;
        byte = 8'd7;
        mode = READ;
        periph_addr = 7'd5;
        enable = 1'b0;
        reset = 0; #1; reset = 1; #1; reset = 0;
        enable = 1'b1;
        #11;
        enable = 1'b0;
        #72;

        sda_mode = WRITE;
        sda_driver = 1'b0;
        #8;
        sda_driver = 1'd1;
        #8;
        sda_driver = 1'd1;
        #8;
        sda_driver = 1'd0;
        #8;
        sda_driver = 1'd1;
        #8;
        sda_driver = 1'd0;
        #8;
        sda_driver = 1'd1;
        #8;
        sda_driver = 1'd1;
        #8;
        sda_mode = READ;
        $display("READ BYTE: %h", read_byte);
    end

endmodule