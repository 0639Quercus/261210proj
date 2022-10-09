`timescale 100ns / 1ns
module speedSetSTIM;
    reg speed_toggle, clk, reset;
    wire clk_out;
    
    speedSet sst( clk_out, speed_toggle, clk, reset);
    initial begin
        clk <= 1'b0;
        reset <= 1'b0;
        speed_toggle <= 1'b0;
        $dumpfile("speedSet.vcd");
        $dumpvars(0,speedSetSTIM);
    end

    always
        #5 clk <= ~clk;

    initial begin
        //#500000 in <= 1'b0;
        #1 reset <= 1'b1;
        #1 reset <= 1'b0;

        #3000 speed_toggle <= 1'b1;
        #100 speed_toggle <= 1'b0;
        #1000 speed_toggle <= 1'b1;
        #100 speed_toggle <= 1'b0;

        // #500000 in <= 1'b1;
        // #1000000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #1500000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #2000000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #1500000 in <= 1'b0;
        // #500000 in <= 1'b1; 
        // #10000000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #1000000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #1500000 in <= 1'b0;
        // #500000 in <= 1'b1;
        // #2000000 in <= 1'b0; 
        #100000 $finish;
    end 

    // initial
    // $monitor($time, " output out = %d in = %d, clk = %d", out, in, clk);

endmodule