module tb_i2c_controller ();

    reg clk, reset, enable, mode;
    reg [6:0] periph_addr;
    reg [7:0] byte;
    wire [3:0] state;
    wire sdc;
    wire sda;

    i2c_controller i2c (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mode(mode),
        .periph_addr(periph_addr),
        .state(state),
        .sdc(sdc),
        .sda(sda)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        byte = 8'd7;
        mode = 1'b1;
        periph_addr = 7'd3;
        enable = 1'b0;
        reset = 0; #1; reset = 1; #1; reset = 0;
        enable = 1'b1;
        #32;
    end

endmodule