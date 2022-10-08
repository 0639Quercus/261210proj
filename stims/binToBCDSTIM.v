module binToBCDSTIM;
    reg [5:0]L;
    wire [3:0]BCD0;
    wire [3:0]BCD1;

    binToBCD converter(BCD1,BCD0, L);

    initial begin
        L = 6'd0;
        $dumpfile("binToBCD.vcd");
        $dumpvars(0,binToBCDSTIM); //vvp 
        #96 $finish;
    end

    always
        #1 L <= L+1;

endmodule