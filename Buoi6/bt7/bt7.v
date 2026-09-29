module bt7(
	input [1:0] SW,
	input [2:1] KEY,
	output reg [7:0] LEDR
);
always @(posedge KEY[2]) //key2 ck, sw1 rs, ledr3:0 bcd1, ledr7:4 bcd2
begin
	if(SW[1]==1'b1)
	begin
		LEDR[3:0]<=4'd0;
		LEDR[7:4]<=4'd0;
	end
	else
		begin
			if (LEDR[7:4] == 4'd1 && LEDR[3:0] == 4'd8)
			begin
				LEDR[7:4]<=4'd0;
				LEDR[3:0]<=4'd0;
			end
			else if (LEDR[3:0] == 4'd9)
			begin
				LEDR[7:4]<=LEDR[7:4]+1'b1;
				LEDR[3:0]<=1'd0;
			end
			else
				LEDR[3:0] <= LEDR[3:0] + 1'b1;
		end
end
endmodule
