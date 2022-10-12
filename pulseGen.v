module pulseGen(q, in, clk);
    output q;
    input in, clk;
    wire nin, QN1;
    wire [1:0] Q;

    not not0(nin, in);
    not not1(QN1, Q[1]);
    and and0(q, QN1, Q[0]);

    D_FF d0(Q[0], in, clk, 1'b0, nin);
    D_FF d1(Q[1], Q[0], clk, 1'b0, nin);
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