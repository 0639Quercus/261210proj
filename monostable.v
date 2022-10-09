module monostable(q, in, clk); // maximum of 1 second for 1MHz clock
    output q;
    input in, clk;
    wire slowClk, nin, QN1;
    wire [1:0] Q;

    not not0(nin, in);
    not not1(QN1, Q[1]);
    and and0(q, QN1, Q[0]);

    D_FF d0(Q[0], in, slowClk, 1'b0, nin);
    D_FF d1(Q[1], Q[0], slowClk, 1'b0, nin);
    clk_div clkd(slowClk, clk, nin);
endmodule

module clk_div(q, clk, reset); //1us to 250ms
    output q;
    wire [17:0] Q;
    input clk, reset;
    wire [18:0] T;

    assign T[0] = 1'b1;
    assign T[1] = Q[0];
    and and2(T[2], Q[1], T[1]);
    and and3(T[3], Q[2], T[2]);
    and and4(T[4], Q[3], T[3]);
    and and5(T[5], Q[4], T[4]);
    and and6(T[6], Q[5], T[5]);
    and and7(T[7], Q[6], T[6]);
    and and8(T[8], Q[7], T[7]);
    and and9(T[9], Q[8], T[8]);
    and and10(T[10], Q[9], T[9]);
    and and11(T[11], Q[10], T[10]);
    and and12(T[12], Q[11], T[11]);
    and and13(T[13], Q[12], T[12]);
    and and14(T[14], Q[13], T[13]);
    and and15(T[15], Q[14], T[14]);
    and and16(T[16], Q[15], T[15]);
    and and17(T[17], Q[16], T[16]);
    and and18(T[18], Q[17], T[17]);

    T_FF tff0(Q[0], T[0], clk ,reset);
    T_FF tff1(Q[1], T[1], clk ,reset);
    T_FF tff2(Q[2], T[2], clk ,reset);
    T_FF tff3(Q[3], T[3], clk ,reset);
    T_FF tff4(Q[4], T[4], clk ,reset);
    T_FF tff5(Q[5], T[5], clk ,reset);
    T_FF tff6(Q[6], T[6], clk ,reset);
    T_FF tff7(Q[7], T[7], clk ,reset);
    T_FF tff8(Q[8], T[8], clk ,reset);
    T_FF tff9(Q[9], T[9], clk ,reset);
    T_FF tff10(Q[10], T[10], clk ,reset);
    T_FF tff11(Q[11], T[11], clk ,reset);
    T_FF tff12(Q[12], T[12], clk ,reset);
    T_FF tff13(Q[13], T[13], clk ,reset);
    T_FF tff14(Q[14], T[14], clk ,reset);
    T_FF tff15(Q[15], T[15], clk ,reset);
    T_FF tff16(Q[16], T[16], clk ,reset);
    T_FF tff17(Q[17], T[17], clk ,reset);
    T_FF tff18(q, T[18], clk ,reset);
endmodule

module T_FF(q, t, clk, reset);
    output q;
    input t, clk ,reset;
    reg q;

    always @(posedge clk or posedge reset)
    if(reset)
        q <= 1'b0;
    else if(t)
        q <= ~q;
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