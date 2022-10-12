module BTN_regSTIM;
    reg mem, BTN;
    wire LED, out;

    BTN_reg BTNR(out, LED, BTN, mem);

    initial begin
        mem <= 1'b0;
        BTN <= 1'b0;
        $dumpfile("BTN_reg.vcd");
        $dumpvars(0,BTN_regSTIM);
    end

    initial begin
        #5 mem <= 1'b1;
        #5 mem <= 1'b0;
        #5 BTN <= 1'b1;
        #5 BTN <= 1'b0;

        #5 mem <= 1'b1;
        #5 BTN <= 1'b1;
        #5 BTN <= 1'b0;
        #5 mem <= 1'b0;

        #5 BTN <= 1'b1;
        #5 mem <= 1'b1;
        #5 mem <= 1'b0;
        #5 BTN <= 1'b0;

        #10 $finish;
    end
endmodule