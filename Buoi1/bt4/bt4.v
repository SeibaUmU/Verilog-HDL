module bt4(
input [7:5]SW,
output [2:1]LEDR
);
assign 
	LEDR[2]=(SW[7] ^ SW[6]) ^ SW[5]; //output sn led 2
assign
	LEDR[1]=(SW[5]&SW[6])|(SW[7] & SW[6])|(SW[5]&SW[7]); //output cn led 1
endmodule