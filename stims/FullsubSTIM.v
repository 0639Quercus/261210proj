module FullsubSTIM;
    reg [5:0]A,B;
    wire [5:0]D;
    wire Bout;
    subtractor6 sub(D,Bout,A,B);

    initial 
        begin
            $dumpfile("fullsubtractor.vcd");
            $dumpvars(0,FullsubSTIM);
            #256 $finish;
        end
    initial
    begin
        A = 6'b0;
        B = 6'd10;
    end

    always
        #1 A = A+1;

    initial
        $monitor($time, " output D = %d Bout = %d", D, Bout);
endmodule