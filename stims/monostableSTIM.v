`timescale 100ns / 1ns
module monostableSTIM;
    // Inputs
    reg in;
    reg clk;
    // Outputs
    wire out;
    // Instantiate the debouncing Verilog code
    monostable c20( out, in, clk);
    initial begin
    clk <= 1'b0;
        $dumpfile("monostable.vcd");
        $dumpvars(0,monostableSTIM);
    end

    always
        #5 clk <= ~clk;

    initial begin
        //#500000 in <= 1'b0;
        #500000 in <= 1'b1;
        #1000000 in <= 1'b0;
        #500000 in <= 1'b1;
        #1500000 in <= 1'b0;
        #500000 in <= 1'b1;
        #2000000 in <= 1'b0;
        #500000 in <= 1'b1;
        #1500000 in <= 1'b0;
        #500000 in <= 1'b1; 
        #10000000 in <= 1'b0;
        #500000 in <= 1'b1;
        #1000000 in <= 1'b0;
        #500000 in <= 1'b1;
        #1500000 in <= 1'b0;
        #500000 in <= 1'b1;
        #2000000 in <= 1'b0; 
        #10000000 $finish;
    end 

    // initial
    // $monitor($time, " output out = %d in = %d, clk = %d", out, in, clk);

endmodule