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