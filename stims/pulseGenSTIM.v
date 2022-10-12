`timescale 100ns/10ns

module pulseGenSTIM;
    reg clk, in;
    wire q;

    pulseGen pg(q, in, clk);

    initial begin
        clk <= 1'b0;
        in <= 1'b0;
        $dumpfile("pulseGen.vcd");
        $dumpvars(0,pulseGenSTIM);        
    end

    initial begin
        #100 in <= 1'b1;
        #3000 in <= 1'b0;
        #2000 in <= 1'b1;
        #1000 in <= 1'b0;
        #100 $finish;
    end

    always
        #5 clk <= ~clk;
endmodule