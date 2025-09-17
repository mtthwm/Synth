module tb_square_wave_gen ();

    reg [15:0] period, duty_cycle;
    reg reset, clk;

    wire gen_out;
    wire [15:0] t;

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    square_wave_gen sg (
        .clk(clk),
        .reset(reset),
        .period(period),
        .duty_cycle(duty_cycle),
        .value(gen_out),
        .t(t)
    );

    initial begin 
        reset = 0; #1; reset = 1; #1; reset = 0;
        
        period = 16'd8;
        duty_cycle = 16'd6;
    
        #32;

        $display("GEN: %b", gen_out);
    end

endmodule