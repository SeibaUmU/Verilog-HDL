module bt4(
input [1:0] KEY,
output reg [3:0] LEDR
);

always @(posedge KEY[0] or negedge KEY[1]) //key0 ck, key1 rs
begin
	if (!KEY[1]) LEDR <= 4'd0;
	else
		begin
			if (LEDR == 4'd11) LEDR <= 4'd0;
			else LEDR <= LEDR + 1'b1;
		end
end
endmodule


	
	

