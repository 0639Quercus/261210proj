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
