module mux4_1_2bit(
input [17:0] SW,
output [17:1] LEDR
);

reg [1:0] y;

always @(*) begin
case(SW[9:8])
2'b00: y = SW[1:0];
2'b01: y = SW[3:2];
2'b10: y = SW[5:4];
2'b11: y = SW[7:6];
default: y = 2'b00;
endcase
end

assign LEDR[2:1] = y;

endmodule