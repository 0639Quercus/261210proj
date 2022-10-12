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