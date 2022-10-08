module ninthCounter(q, clk, reset);
    input clk, reset;
    output [8:0]q;
    wire [8:0]p;

    D_FF dff1(p[0], p[8], clk, reset , 1'b0);
    D_FF dff2(p[1], p[0], clk, 1'b0 , reset);
    D_FF dff3(p[2], p[1], clk, 1'b0 , reset);
    D_FF dff4(p[3], p[2], clk, 1'b0 , reset);
    D_FF dff5(p[4], p[3], clk, 1'b0 , reset);
    D_FF dff6(p[5], p[4], clk, 1'b0 , reset);
    D_FF dff7(p[6], p[5], clk, 1'b0 , reset);
    D_FF dff8(p[7], p[6], clk, 1'b0 , reset);
    D_FF dff9(p[8], p[7], clk, 1'b0 , reset);

    and and1(q[0], p[0] ,clk);
    and and2(q[1], p[1] ,clk);
    and and3(q[2], p[2] ,clk);
    and and4(q[3], p[3] ,clk);
    and and5(q[4], p[4] ,clk);
    and and6(q[5], p[5] ,clk);
    and and7(q[6], p[6] ,clk);
    and and8(q[7], p[7] ,clk);
    and and9(q[8], p[8] ,clk);
endmodule

module D_FF (q, d, clk, preset, reset);
	input d, clk, preset, reset;
	output q;
	reg q;

	always @(posedge reset or posedge preset or posedge clk)
        if(reset)
            q <= 1'b0;
        else if(preset)
            q <= 1'b1;
        else
            q <= d;
endmodule
