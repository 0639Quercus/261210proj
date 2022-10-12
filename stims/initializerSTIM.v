`timescale 100ns / 1ns
module initializerSTIM;
    // Inputs
    reg in;
    reg clk;
    // Outputs
    wire out;
    // Instantiate the debouncing Verilog code
    initializer init( out, in, clk);
    initial begin
        in <= 1'b0;
        clk <= 1'b0;
        $dumpfile("initializer.vcd");
        $dumpvars(0,initializerSTIM);
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

endmodule   