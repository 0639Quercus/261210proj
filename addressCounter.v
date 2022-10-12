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