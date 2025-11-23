module tb_i2c_fsm ();

    reg clk, reset;
    wire scl;
    wire sda;
    wire [3:0] state;
    wire [7:0] debug;

    i2c_fsm i2fsm (
        .clk(clk),
        .reset(reset),
        .sda(sda),
        .scl(scl),
        .read_byte(read_byte),
        .state_info(state),
        .debug(debug)
    );

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    initial begin
        reset = 0; #1; reset = 1; #1; reset = 0;
    end

endmodule