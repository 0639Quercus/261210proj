module pulseGenArr(Q, in, clk);
    output [17:0] Q;
    input [17:0] in;
    input clk;

    pulseGen pg0(Q[0], in[0], clk);
    pulseGen pg1(Q[1], in[1], clk);
    pulseGen pg2(Q[2], in[2], clk);
    pulseGen pg3(Q[3], in[3], clk);
    pulseGen pg4(Q[4], in[4], clk);
    pulseGen pg5(Q[5], in[5], clk);
    pulseGen pg6(Q[6], in[6], clk);
    pulseGen pg7(Q[7], in[7], clk);
    pulseGen pg8(Q[8], in[8], clk);
    pulseGen pg9(Q[9], in[9], clk);
    pulseGen pg10(Q[10], in[10], clk);
    pulseGen pg11(Q[11], in[11], clk);
    pulseGen pg12(Q[12], in[12], clk);
    pulseGen pg13(Q[13], in[13], clk);
    pulseGen pg14(Q[14], in[14], clk);
    pulseGen pg15(Q[15], in[15], clk);
    pulseGen pg16(Q[16], in[16], clk);
    pulseGen pg17(Q[17], in[17], clk);
endmodule

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