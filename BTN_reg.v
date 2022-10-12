module BTN_regArr(out, LED, BTN, mem);
    output [17:0] out, LED;
    input [17:0] mem;
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
    BTN_reg BTNR9(out[9], LED[9], BTN[0], mem[9]);
    BTN_reg BTNR10(out[10], LED[10], BTN[1], mem[10]);
    BTN_reg BTNR11(out[11], LED[11], BTN[2], mem[11]);
    BTN_reg BTNR12(out[12], LED[12], BTN[3], mem[12]);
    BTN_reg BTNR13(out[13], LED[13], BTN[4], mem[13]);
    BTN_reg BTNR14(out[14], LED[14], BTN[5], mem[14]);
    BTN_reg BTNR15(out[15], LED[15], BTN[6], mem[15]);
    BTN_reg BTNR16(out[16], LED[16], BTN[7], mem[16]);
    BTN_reg BTNR17(out[17], LED[17], BTN[8], mem[17]);
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