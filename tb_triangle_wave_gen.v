module tb_triangle_wave_gen ();

    reg [32:0] period;
    reg reset, clk;

    wire [7:0] gen_out;

    always #1 clk <= ~clk;
    initial clk <= 1'h0;

    triangle_wave_gen tg (
        .clk(clk),
        .reset(reset),
        .period(period),
        .value(gen_out)
    );

    initial begin 
        reset = 0; #1; reset = 1; #1; reset = 0;
        
        period = 32'd64;
    
        #32;

        $display("GEN: %b", gen_out);
    end

endmodule