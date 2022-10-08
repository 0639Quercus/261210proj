module ninthCounterSTIM;
    reg clk;
    reg reset;
    wire [8:0]q;
    ninthCounter nctr(q,clk,reset);

	initial
		begin
			$dumpfile("ninthCounter.vcd");
			$dumpvars(0,ninthCounterSTIM);
			clk = 1'b0;  // set clk to 0
			reset = 1'b0;  // set reset to 0
		end

    initial 
        clk = 1'b0;
    always
        #4 clk = ~clk;

    initial
        begin
            #1 reset = 1'b1;
            #3 reset = 1'b0;
            #40 reset = 1'b1;
            #42 reset = 1'b0;
            #100 $finish;
        end    

    initial
        $monitor($time, " output q = %d reset = %d, clk = %d", q[0], reset, clk);
    
endmodule