module addressCounterSTIM;
    reg clk;
    wire [7:0] address;

    addressCounter adct(address, clk, 1'b0);

    initial begin
        clk <= 1'b0;
        $dumpfile("addressCounter.vcd");
        $dumpvars(0,addressCounterSTIM);
        #1000 $finish;
    end

    always
        #5 clk <= ~clk;
endmodule