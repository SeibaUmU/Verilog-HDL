module decoder4to16(LEDR, SW);
input [4:1]SW;

output [16:1]LEDR;
wire note;
not n(note,SW[4]);

decoder3to8(SW[3:1],LEDR[8:1],SW[4]);

decoder3to8(SW[3:1],LEDR[16:9],note);

endmodule

module decoder3to8(x,y,e);
input [3:1]x;
input e;
output [8:1]y;
reg [8:1]y;
always @(*) begin
if(e==1'b0)
begin
case (x[3:1])
3'b000:y[8:1]=8'b11111110;
3'b001:y[8:1]=8'b11111101;
3'b010:y[8:1]=8'b11111011;
3'b011:y[8:1]=8'b11110111;
3'b100:y[8:1]=8'b11101111;
3'b101:y[8:1]=8'b11011111;
3'b110:y[8:1]=8'b10111111;
3'b111:y[8:1]=8'b01111111;
endcase
end
else
y[8:1]=8'b11111111;
end
endmodule