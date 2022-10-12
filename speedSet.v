module speedSet(clk_out, speed_toggle, clk);
    input speed_toggle, clk;
    output clk_out;
    reg init;

    wire [21:0] count, durHigh, durLow;
    wire [2:0] mode;
    wire toggle, toggleLow, toggleHigh;
    wire ct21reset;
    tricounter tc3(mode, speed_toggle, init);
    permitter22_3 perm0(durLow, mode,  22'h1406f4, 22'h0d59f8, 22'h06acfc); // 1.3125 sec, 0.875 sec, 0.4375 sec
    permitter22_3 perm1(durHigh, mode, 22'h280de8, 22'h1ab3f0, 22'h0d59f8); // 2.625 sec,  1.75 sec,  0.875 sec
    equal22 eql0(toggleLow, count, durLow);
    equal22 eql1(toggleHigh, count, durHigh);

    assign toggle = (toggleLow & ~clk_out) | (toggleHigh & clk_out);
    assign ct21reset = init | toggle;
    counter22 ct22(count, clk, ct21reset);
    T_FF tff(clk_out, 1'b1, toggle, init);

    initial
        init <= 1'b1;
    always @ (negedge clk)
        init <= 1'b0;
endmodule

module counter22(Q, clk, reset); // maximum 4 seconds from 1MHz clock
    input clk, reset;
    output [21:0] Q;
    wire [21:0] T;

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
    T_FF tff18(Q[18], T[18], clk ,reset);
    T_FF tff19(Q[19], T[19], clk ,reset);
    T_FF tff20(Q[20], T[20], clk ,reset);
    T_FF tff21(Q[21], T[21], clk ,reset);

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
    and and19(T[19], Q[18], T[18]);
    and and20(T[20], Q[19], T[19]);
    and and21(T[21], Q[20], T[20]);
endmodule

module tricounter(Q, clk, reset); //starts at 3'b100
    input clk,reset;
    output [2:0] Q;

    D_FF dff1(Q[0], Q[2], clk, reset, 1'b0);
    D_FF dff2(Q[1], Q[0], clk, 1'b0, reset);
    D_FF dff3(Q[2], Q[1], clk, 1'b0, reset);
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

module permitter22_3(out, permit, a, b, c);
    input [21:0] a,b,c;
    input [2:0] permit;
    output [21:0] out;

    assign out[0] = (a[0] & permit[0]) | (b[0] & permit[1]) | (c[0] & permit[2]);
    assign out[1] = (a[1] & permit[0]) | (b[1] & permit[1]) | (c[1] & permit[2]);
    assign out[2] = (a[2] & permit[0]) | (b[2] & permit[1]) | (c[2] & permit[2]);
    assign out[3] = (a[3] & permit[0]) | (b[3] & permit[1]) | (c[3] & permit[2]);
    assign out[4] = (a[4] & permit[0]) | (b[4] & permit[1]) | (c[4] & permit[2]);
    assign out[5] = (a[5] & permit[0]) | (b[5] & permit[1]) | (c[5] & permit[2]);
    assign out[6] = (a[6] & permit[0]) | (b[6] & permit[1]) | (c[6] & permit[2]);
    assign out[7] = (a[7] & permit[0]) | (b[7] & permit[1]) | (c[7] & permit[2]);
    assign out[8] = (a[8] & permit[0]) | (b[8] & permit[1]) | (c[8] & permit[2]);
    assign out[9] = (a[9] & permit[0]) | (b[9] & permit[1]) | (c[9] & permit[2]);
    assign out[10] = (a[10] & permit[0]) | (b[10] & permit[1]) | (c[10] & permit[2]);
    assign out[11] = (a[11] & permit[0]) | (b[11] & permit[1]) | (c[11] & permit[2]);
    assign out[12] = (a[12] & permit[0]) | (b[12] & permit[1]) | (c[12] & permit[2]);
    assign out[13] = (a[13] & permit[0]) | (b[13] & permit[1]) | (c[13] & permit[2]);
    assign out[14] = (a[14] & permit[0]) | (b[14] & permit[1]) | (c[14] & permit[2]);
    assign out[15] = (a[15] & permit[0]) | (b[15] & permit[1]) | (c[15] & permit[2]);
    assign out[16] = (a[16] & permit[0]) | (b[16] & permit[1]) | (c[16] & permit[2]);
    assign out[17] = (a[17] & permit[0]) | (b[17] & permit[1]) | (c[17] & permit[2]);
    assign out[18] = (a[18] & permit[0]) | (b[18] & permit[1]) | (c[18] & permit[2]);
    assign out[19] = (a[19] & permit[0]) | (b[19] & permit[1]) | (c[19] & permit[2]);
    assign out[20] = (a[20] & permit[0]) | (b[20] & permit[1]) | (c[20] & permit[2]);
    assign out[21] = (a[21] & permit[0]) | (b[21] & permit[1]) | (c[21] & permit[2]);
endmodule

module equal22(q, a, b);
    input [21:0] a,b;
    output q;

    wire [21:0] eql;

    assign q = eql[0] & eql[1] & eql[2] & eql[3] & eql[4] & eql[5] & eql[6] & eql[7] 
                & eql[8] & eql[9] & eql[10] & eql[11] & eql[12] & eql[13] & eql[14] 
                & eql[15] & eql[16] & eql[17] & eql[18] & eql[19] & eql[20] & eql[21];

    xnor xnor0(eql[0],a[0],b[0]);
    xnor xnor1(eql[1],a[1],b[1]);
    xnor xnor2(eql[2],a[2],b[2]);
    xnor xnor3(eql[3],a[3],b[3]);
    xnor xnor4(eql[4],a[4],b[4]);
    xnor xnor5(eql[5],a[5],b[5]);
    xnor xnor6(eql[6],a[6],b[6]);
    xnor xnor7(eql[7],a[7],b[7]);
    xnor xnor8(eql[8],a[8],b[8]);
    xnor xnor9(eql[9],a[9],b[9]);
    xnor xnor10(eql[10],a[10],b[10]);
    xnor xnor11(eql[11],a[11],b[11]);
    xnor xnor12(eql[12],a[12],b[12]);
    xnor xnor13(eql[13],a[13],b[13]);
    xnor xnor14(eql[14],a[14],b[14]);
    xnor xnor15(eql[15],a[15],b[15]);
    xnor xnor16(eql[16],a[16],b[16]);
    xnor xnor17(eql[17],a[17],b[17]);
    xnor xnor18(eql[18],a[18],b[18]);
    xnor xnor19(eql[19],a[19],b[19]);
    xnor xnor20(eql[20],a[20],b[20]);
    xnor xnor21(eql[21],a[21],b[21]);

endmodule