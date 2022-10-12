module main(binScore, LEDg, LEDr, BTN, sst, r, clk);
    output [8:0] LEDg, LEDr;
    output [5:0] binScore;
    input [8:0] BTN;
    input sst, r, clk;

    wire speed_toggle, reset;
    monostable mnstbSST(speed_toggle, sst, clk);
    monostable mnstbR(reset, r, clk);

    wire moleClk_pre;
    wire moleClk, allower;
    speedSet sstm(moleClk_pre, speed_toggle, clk);
    and andmole(moleClk, moleClk_pre, allower);

    wire [7:0] address;
    wire act_reset;
    addressCounter act(address, moleClk, reset); // need to update reset port and clock port
    equal8 eql8(act_reset, address, 8'd6); //put last address here

    wire [17:0] data;
    wire toReset, toReset_pulse;
    memory mem(data, address);
    all1s a1s(toReset, data[17:9]);
    pulseGen pgr(toReset_pulse, toReset, clk);
    SR srallow(allower, reset, toReset_pulse);

    wire [8:0] toCountg, toCountg_pre;
    wire [8:0] toCountr, toCountr_pre;
    BTN_regArr btnrg(toCountg_pre, LEDg, BTN, data[17:9]);
    BTN_regArr btnrr(toCountr_pre, LEDr, BTN, data[8:0]);
    pulseGenArr pgarg(toCountg, toCountg_pre, clk);
    pulseGenArr pgarr(toCountr, toCountr_pre, clk);

    wire countg;
    wire countr;
    byteImploder bipg(countg, toCountg);
    byteImploder bipr(countr, toCountr);

    wire [5:0] countUp, countDown, score;
    wire borrow_out;
    counter6 ctr6up(countUp, countg, borrow_out);
    counter6 ctr6dn(countDown, countr, borrow_out);
    subtractor6 sbt(score, borrow_out, countUp, countDown);

    wire [1:0] ten;
    wire [3:0] one;
    binToBCD btb(ten, one, score);
    assign binScore = {ten,one};

endmodule

//----counter6----------------------------------------------------------

module counter6(add, clk, reset);
    output [5:0] add;
    input clk,reset;
    reg init;

    wire ctreset;
    or or0(ctreset, reset, init);

    wire [5:0] T;
    assign T[0] = 1'b1;
    assign T[1] = add[0];
    and and2(T[2], add[1], T[1]);
    and and3(T[3], add[2], T[2]);
    and and4(T[4], add[3], T[3]);
    and and5(T[5], add[4], T[4]);

    T_FF tff0(add[0], T[0], clk, ctreset);
    T_FF tff1(add[1], T[1], clk, ctreset);
    T_FF tff2(add[2], T[2], clk, ctreset);
    T_FF tff3(add[3], T[3], clk, ctreset);
    T_FF tff4(add[4], T[4], clk, ctreset);
    T_FF tff5(add[5], T[5], clk, ctreset);

    initial 
        init <= 1'b1;
    always @(negedge clk)
        init <= 1'b0;

endmodule

//----subtractor--------------------------------------------------------

module subtractor6(D,Bout,A,B);
    input [5:0]A,B;
    output [5:0]D;
    output Bout;
    wire [4:0]Br;
    fullsubtractor f0(D[0],Br[0],A[0],B[0],1'd0);
    fullsubtractor f1(D[1],Br[1],A[1],B[1],Br[0]);
    fullsubtractor f2(D[2],Br[2],A[2],B[2],Br[1]);
    fullsubtractor f3(D[3],Br[3],A[3],B[3],Br[2]);
    fullsubtractor f4(D[4],Br[4],A[4],B[4],Br[3]);
    fullsubtractor f5(D[5],Bout,A[5],B[5],Br[4]);

endmodule

module fullsubtractor(D,Br,A,B,C);
    input A,B,C;
    output D,Br;
    wire AxorB,An,AnandB,AxorBn,CandAxorBn;

    xor x1(AxorB,A,B);
    not n1(An,A);
    and a1(AnandB,An,B);
    not n2(AxorBn,AxorB);
    xor x2(D,AxorB,C);
    and a2(CandAxorBn,C,AxorBn);
    or  o1(Br,CandAxorBn,AnandB);    
endmodule

//----addressCounter----------------------------------------------------

module addressCounter(add, clk, reset);
    output [7:0] add;
    input clk,reset;
    reg init;

    wire ctreset;
    or or0(ctreset, reset, init);

    wire [7:0] T;
    assign T[0] = 1'b1;
    assign T[1] = add[0];
    and and2(T[2], add[1], T[1]);
    and and3(T[3], add[2], T[2]);
    and and4(T[4], add[3], T[3]);
    and and5(T[5], add[4], T[4]);
    and and6(T[6], add[5], T[5]);
    and and7(T[7], add[6], T[6]);

    T_FF tff0(add[0], T[0], clk, ctreset);
    T_FF tff1(add[1], T[1], clk, ctreset);
    T_FF tff2(add[2], T[2], clk, ctreset);
    T_FF tff3(add[3], T[3], clk, ctreset);
    T_FF tff4(add[4], T[4], clk, ctreset);
    T_FF tff5(add[5], T[5], clk, ctreset);
    T_FF tff6(add[6], T[6], clk, ctreset);
    T_FF tff7(add[7], T[7], clk, ctreset);

    initial 
        init <= 1'b1;
    always @(negedge clk)
        init <= 1'b0;

endmodule

//----button register---------------------------------------------------

module BTN_regArr(out, LED, BTN, mem);
    output [8:0] out, LED;
    input [8:0] mem;
    input [8:0] BTN;

    BTN_reg BTNR0(out[0], LED[0], BTN[0], mem[0]);
    BTN_reg BTNR1(out[1], LED[1], BTN[1], mem[1]);
    BTN_reg BTNR2(out[2], LED[2], BTN[2], mem[2]);
    BTN_reg BTNR3(out[3], LED[3], BTN[3], mem[3]);
    BTN_reg BTNR4(out[4], LED[4], BTN[4], mem[4]);
    BTN_reg BTNR5(out[5], LED[5], BTN[5], mem[5]);
    BTN_reg BTNR6(out[6], LED[6], BTN[6], mem[6]);
    BTN_reg BTNR7(out[7], LED[7], BTN[7], mem[7]);
    BTN_reg BTNR8(out[8], LED[8], BTN[8], mem[8]);
endmodule

module BTN_reg(out, LED, BTN, mem);
    output out, LED;
    input mem, BTN;

    wire set, reset, qn;
    and and0(set, mem, BTN);
    not not0(reset, mem);
    nor Q(out, qn, reset);
    nor QN(qn, out, set);
    and LEDand(LED, qn, mem);
endmodule

//----speedSet----------------------------------------------------------

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

//----monostable---------------------------------------------------------

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

//----pulse generator---------------------------------------------------

module pulseGenArr(Q, in, clk);
    output [8:0] Q;
    input [8:0] in;
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

//----flipflops----------------------------------------------------------

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

module SR (q, set, reset);
    output q;
    input set, reset;
    
    wire qn;
    nor s(q, qn ,reset);
    nor r(qn, q ,set);
endmodule

//----data---------------------------------------------------------------

module memory(out, address);
    output [17:0] out;
    input [7:0] address;
    reg [17:0] out;

    always @(address)
    begin
        case(address)
            8'd0: out <= 1'b010000100001000000;
            8'd1: out <= 1'b000010000001001001;
            8'd2: out <= 1'b000000100100100000;
            8'd3: out <= 1'b000000000011001100;
            8'd4: out <= 1'b010001000000000000;
            8'd5: out <= 1'b010000000001000100;
            default: out <= 1'b000000000111111111;
        endcase
    end
endmodule

//----BCD converter------------------------------------------------------

module binToBCD(TEN, ONE, bin);
    input [5:0] bin;
    output [3:0] ONE ,TEN;

    wire [3:0] c, d, e;

    assign ONE[0] = bin[0];

    cadd3 a1(c, {1'b0, bin[5:3]});
    cadd3 a2(d, {c[2:0],bin[2]});
    cadd3 a3(e, {d[2:0],bin[1]});

	assign TEN[0] = e[3];
	assign ONE[3:1] = e[2:0];

    assign TEN[1] = d[3];
    assign TEN[2] = c[3];
    assign TEN[3] = 1'b0;
    
endmodule

module cadd3(out,in);
	input [3:0] in;
	output [3:0] out;
	reg [3:0] out;

	always @ (in)
		case (in)
		4'b0000: out <= 4'b0000;
		4'b0001: out <= 4'b0001;
		4'b0010: out <= 4'b0010;
		4'b0011: out <= 4'b0011;
		4'b0100: out <= 4'b0100;
		4'b0101: out <= 4'b1000;
		4'b0110: out <= 4'b1001;
		4'b0111: out <= 4'b1010;
		4'b1000: out <= 4'b1011;
		4'b1001: out <= 4'b1100;
		default: out <= 4'b0000;
		endcase
endmodule

//----misc---------------------------------------------------------------

module byteImploder(q, in);
    output q;
    input [8:0] in;

    assign q = in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7] | in[8];
endmodule

module all1s(q, in[8:0]);
    input [8:0] in;
    output q;

    assign q = in[0] & in[1] & in[2] & in[3] & in[4] & in[5] &in[6] & in[7] & in[8];
endmodule

module equal8(q, a, b);
    output q;
    input [7:0] a, b;

    wire [7:0] eql;
    xnor xnor0(eql[0],a[0],b[0]);
    xnor xnor1(eql[1],a[1],b[1]);
    xnor xnor2(eql[2],a[2],b[2]);
    xnor xnor3(eql[3],a[3],b[3]);
    xnor xnor4(eql[4],a[4],b[4]);
    xnor xnor5(eql[5],a[5],b[5]);
    xnor xnor6(eql[6],a[6],b[6]);
    xnor xnor7(eql[7],a[7],b[7]);

    assign q = eql[0] & eql[1] & eql[2] & eql[3] & eql[4] & eql[5] & eql[6] & eql[7];
endmodule