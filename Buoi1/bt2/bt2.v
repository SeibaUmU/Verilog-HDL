module bt2(SW,LEDR);
input [1:0]SW;
output reg [7:0]LEDR;
always @(SW)
begin
	case(SW)
		2'b00: LEDR = 7'b1010101;
		2'b01: LEDR = 7'b0101010;
		2'b10: LEDR = 7'b1111111;
		2'b11: LEDR = 7'b0000000;
	endcase
end
endmodule