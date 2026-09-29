module bt5(
    input [3:0] SW,
    output [6:0] HEX1, HEX0
);
    wire [3:0] chuc;
    wire [3:0] donvi;

    assign chuc  = SW / 4'd10; 
    assign donvi = SW % 4'd10; 

    bin_to_7seg seg1 (chuc, HEX1);
    bin_to_7seg seg0 (donvi, HEX0);

endmodule

module bin_to_7seg(
    input [3:0] bin,
    output reg [6:0] seg
);
    always @(*) begin
        case (bin)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; 
        endcase
    end
endmodule