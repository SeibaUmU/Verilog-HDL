module bt1(KEY,LEDR,SW);
input [10:9]SW;
input [2:1]KEY;
output [3:0]LEDR;


wire clk;
assign clk = KEY[2];

wire rs;
assign rs = SW[10];


wire a1,a2,a3;

assign a1 = SW[9] & LEDR[0];
assign a2 = a1 & LEDR[1];
assign a3 = a2 & LEDR[2];

tf t1(KEY[2],SW[9],SW[10],LEDR[0]);
tf t2(KEY[2],a1,SW[10],LEDR[1]);
tf t3(KEY[2],a2,SW[10],LEDR[2]);
tf t4(KEY[2],a3,SW[10],LEDR[3]);


endmodule

module tf(clk,e,rs,q);
	input clk,e,rs;
	output q;
	reg q;
	always @(posedge clk or negedge rs)
		begin
		if(rs==1'b0)
			q<=1'b0;
		else
			if(e==1'b0)
				q<=q;
			else
				q=!q;
		end
endmodule