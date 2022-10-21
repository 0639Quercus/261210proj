module main1(count_pulse, LED, BTN, slowClk, clk);
    output count_pulse;
    output [4:0] LED;
    input [4:0] BTN;
    input clk;
    input slowClk;

    output [4:0] data;
    rand1 rd(data, slowClk, clk);

    wire [4:0] toCount;
    BTN_reg BTNR0(toCount[0], LED[0], BTN[0], data[0], slowClk);
    BTN_reg BTNR1(toCount[1], LED[1], BTN[1], data[1], slowClk);
    BTN_reg BTNR2(toCount[2], LED[2], BTN[2], data[2], slowClk);
    BTN_reg BTNR3(toCount[3], LED[3], BTN[3], data[3], slowClk);
    BTN_reg BTNR4(toCount[4], LED[4], BTN[4], data[4], slowClk);

    wire [4:0] toCountPulse;
    pulseGen pg0(toCountPulse[0], toCount[0], clk);
    pulseGen pg1(toCountPulse[1], toCount[1], clk);
    pulseGen pg2(toCountPulse[2], toCount[2], clk);
    pulseGen pg3(toCountPulse[3], toCount[3], clk);
    pulseGen pg4(toCountPulse[4], toCount[4], clk);

    or bimp(count_pulse, toCountPulse[0], toCountPulse[1], toCountPulse[2], toCountPulse[3], toCountPulse[4]);
endmodule

module main2(count_pulse, LED, BTN, slowClk, clk);
    output count_pulse;
    output [3:0] LED;
    input [3:0] BTN;
    input clk;
    input slowClk;

    wire [3:0] data;
    rand2 rd(data, slowClk, clk);

    wire [3:0] toCount;
    BTN_reg BTNR0(toCount[0], LED[0], BTN[0], data[0], slowClk);
    BTN_reg BTNR1(toCount[1], LED[1], BTN[1], data[1], slowClk);
    BTN_reg BTNR2(toCount[2], LED[2], BTN[2], data[2], slowClk);
    BTN_reg BTNR3(toCount[3], LED[3], BTN[3], data[3], slowClk);

    wire [3:0] toCountPulse;
    pulseGen pg0(toCountPulse[0], toCount[0], clk);
    pulseGen pg1(toCountPulse[1], toCount[1], clk);
    pulseGen pg2(toCountPulse[2], toCount[2], clk);
    pulseGen pg3(toCountPulse[3], toCount[3], clk);
    
    or bimp(count_pulse, toCountPulse[0], toCountPulse[1], toCountPulse[2], toCountPulse[3]);
endmodule

//----button register---------------------------------------------------

module BTN_reg(out, LED, BTN, mem, clk);
    output out, LED;
    input mem, BTN;
    input clk;

    wire set, reset, qn;
    and and0(set, mem, BTN);
    not not0(reset, mem);
    //SR srbtn(out, set, reset);
    nor Q(out, qn, reset);
    nor QN(qn, out, set);
    and LEDand(LED, qn, mem, clk);
endmodule

//----random number generator--------------------------------------------

module rand1(mem, moleClk, clk);
    output [4:0] mem;
    input moleClk, clk;
    reg [4:0] data0, data1;
    wire [2:0] count0, count1;

    wire dclk, rest0, rest1;
    assign rest0 = count0[2] & count0[1] & ~count0[0];
    assign rest1 = count1[2] & count1[1] & count1[0];
    T_FF tffdclk(dclk, 1'b1, clk, 1'b0);
    counter3 ct30(count0, clk, rest0);
    counter3 ct31(count1, dclk, rest1);

    always @ (count0) begin    
    case (count0)
        3'd0: data0 <= 5'b00001;
        3'd1: data0 <= 5'b00010;
        3'd2: data0 <= 5'b00100;
        3'd3: data0 <= 5'b01000;
        3'd4: data0 <= 5'b10000;
        default: data0 <= 5'b00000;
    endcase

    case (count1)
        3'd0: data1 <= 5'b00001;
        3'd1: data1 <= 5'b00010;
        3'd2: data1 <= 5'b00100;
        3'd3: data1 <= 5'b01000;
        3'd4: data1 <= 5'b10000;
        default: data1 <= 5'b00000;
    endcase
    end

    wire [4:0] data;
    or ordata0(data[0], data0[0], data1[0]);
    or ordata1(data[1], data0[1], data1[1]);
    or ordata2(data[2], data0[2], data1[2]);
    or ordata3(data[3], data0[3], data1[3]);
    or ordata4(data[4], data0[4], data1[4]);
    //assign data = data0;

    wire [4:0] pre_mem;
    D_FF dff0(pre_mem[0], data[0], moleClk, 1'b0, 1'b0);
    D_FF dff1(pre_mem[1], data[1], moleClk, 1'b0, 1'b0);
    D_FF dff2(pre_mem[2], data[2], moleClk, 1'b0, 1'b0);
    D_FF dff3(pre_mem[3], data[3], moleClk, 1'b0, 1'b0);
    D_FF dff4(pre_mem[4], data[4], moleClk, 1'b0, 1'b0);

    and and0(mem[0], pre_mem[0], moleClk);
    and and1(mem[1], pre_mem[1], moleClk);
    and and2(mem[2], pre_mem[2], moleClk);
    and and3(mem[3], pre_mem[3], moleClk);
    and and4(mem[4], pre_mem[4], moleClk);
endmodule

module rand2(mem, moleClk, clk);
    output [3:0] mem;
    input moleClk;
    input clk;
    reg [3:0] data0, data1;
    wire [2:0] count0, count1;

    wire dclk, rest0, rest1;
    assign rest0 = count0[2] & count0[1] & ~count0[0];
    assign rest1 = count1[2] & ~count1[1] & count1[0];
    T_FF tffdclk(dclk, 1'b1, clk, 1'b0);
    counter3 ct30(count0, clk, rest0);
    counter3 ct31(count1, dclk, rest1);

    always @ (count0) begin    
    case (count0)
        3'd0: data0 <= 4'b0001;
        3'd1: data0 <= 4'b0010;
        3'd2: data0 <= 4'b0100;
        3'd3: data0 <= 4'b1000;
        default: data0 <= 4'b0000;
    endcase

    case (count1)
        3'd0: data1 <= 4'b0001;
        3'd1: data1 <= 4'b0010;
        3'd2: data1 <= 4'b0100;
        3'd3: data1 <= 4'b1000;
        default: data1 <= 4'b0000;
    endcase
    end

    wire [3:0] data;
    or ordata0(data[0], data0[0], data1[0]);
    or ordata1(data[1], data0[1], data1[1]);
    or ordata2(data[2], data0[2], data1[2]);
    or ordata3(data[3], data0[3], data1[3]);

    wire [3:0] pre_mem;
    D_FF dff0(pre_mem[0], data[0], moleClk, 1'b0, 1'b0);
    D_FF dff1(pre_mem[1], data[1], moleClk, 1'b0, 1'b0);
    D_FF dff2(pre_mem[2], data[2], moleClk, 1'b0, 1'b0);
    D_FF dff3(pre_mem[3], data[3], moleClk, 1'b0, 1'b0);

    and and0(mem[0], pre_mem[0], moleClk);
    and and1(mem[1], pre_mem[1], moleClk);
    and and2(mem[2], pre_mem[2], moleClk);
    and and3(mem[3], pre_mem[3], moleClk);
endmodule

//----pulse generator---------------------------------------------------

module pulseGen(out, in, clk);
    output out;
    input in, clk;
    wire in_bar, QN1;
    wire [1:0] Q;

    not not0(in_bar, in);
    not not1(QN1, Q[1]);
    and and0(out, QN1, Q[0]);

    D_FF d0(Q[0], in, clk, 1'b0, in_bar);
    D_FF d1(Q[1], Q[0], clk, 1'b0, in_bar);
endmodule

//----counters-----------------------------------------------------------

module counter3(Q, clk, clear); // 3 bits counter
    input clk, clear;
    output [2:0] Q;
    wire [2:0] T;

    T_FF tff0(Q[0], T[0], clk, clear);
    T_FF tff1(Q[1], T[1], clk, clear);
    T_FF tff2(Q[2], T[2], clk, clear);

    assign T[0] = 1'b1;
    assign T[1] = Q[0];
    and and2(T[2], Q[1], T[1]);
endmodule

//----flipflops----------------------------------------------------------

module T_FF(q,t,clk,clear);
    output q;
    input t,clk,clear;
    wire d;
    xor x1(d,q,t);
    D_FF d1(q,d,clk,1'b0,clear);
endmodule

module D_FF (q, d, clk, preset, clear);
	input d, clk, preset, reset;
	output q;
	wire clk_bar;
    not clknot(clk_bar, clk);

    wire qm;
    DL dl_master(qm, d, clk_bar, preset, clear);
    DL dl_slave(q, qm, clk, preset, clear);
endmodule

module DL(q, d, en, preset, clear);
    output q;
    input d, en, preset, clear;

    wire set, reset;
    assign set = preset | (d & en);
    assign reset = clear | (~d & en);

    SR srd(q, set, reset);
endmodule

module SR (q, set, reset);
    output q;
    input set, reset;
    
    wire qn;
    nor s(q, qn ,reset);
    nor r(qn, q ,set);
endmodule
