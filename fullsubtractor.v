module subtractor6(A,B,D,Br,Bout)
    input [5:0]A,[5:0]B;
    output [5:0]D,[4:0]Br;
    fullsubtractor f0(D[0],Br[0],A[0],B[0],1'b0);
    fullsubtractor f1(D[1],Br[1],A[1],B[1],Br[0]);
    fullsubtractor f2(D[2],Br[2],A[2],B[2],Br[1]);
    fullsubtractor f3(D[3],Br[3],A[3],B[3],Br[2]);
    fullsubtractor f4(D[4],Br[4],A[4],B[4],Br[3]);
    fullsubtractor f5(D[5],Bout,A[5],B[5],Br[4]);

endmodule

module fullsubtractor(A,B,C,D,Br)
    input A,B,C;
    output D,Br;
    wire AxorB,A',A'andB,AxorB',CandAxorB';

    xor x1(AxorB,A,B);
    not n1(A',A);
    and a1(A'andB,A',B);
    not n2(AxorB',AxorB);
    xor x2(D,AxorB,C);
    and a2(CandAxorB',C,AxorB');
    or  o1(Br,CandAxor,A'andB);    
endmodule