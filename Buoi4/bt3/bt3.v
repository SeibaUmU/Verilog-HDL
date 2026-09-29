module bt3(SW, HEX0, HEX1, HEX2, HEX3, HEX4);
input [17:0]SW;
output [6:0]HEX0, HEX1, HEX2, HEX3, HEX4;
wire [2:0]M;
	mux5_1 u1(SW[17:15], SW[14:12], SW[11:9], SW[8:6], SW[5:3], SW[2:0], M);
	display_7_seg u2(M,HEX4, HEX3, HEX2, HEX1, HEX0);
endmodule

module mux5_1(S, A, B, C, D, E, M);
input [2:0]S, A, B, C, D, E;
output [2:0]M;
reg [2:0]M;
	always @(*)
		begin
			case (S)
				3'd0: M = A;
				3'd1: M = B;
				3'd2: M = C;
				3'd3: M = D;
				3'd4: M = E;
				default: M = 3'd0;
			endcase
		end
endmodule

module display_7_seg(data, display4, display3, display2, display1, display0);
	input [2:0]data;
	output [6:0]display4, display3, display2, display1, display0;
	reg [6:0]display4, display3, display2, display1, display0;
	always @(data)
		begin
			case (data)
				3'd0: begin
					display4 = 7'b0001001;
					display3 = 7'b0000110;
					display2 = 7'b1000111;
					display1 = 7'b1000111;
					display0 = 7'b1000000;
				end
				3'd1: begin
					display0 = 7'b0001001;
					display4 = 7'b0000110;
					display3 = 7'b1000111;
					display2 = 7'b1000111;
					display1 = 7'b1000000;
				end
				3'd2: begin
					display1 = 7'b0001001;
					display0 = 7'b0000110;
					display4 = 7'b1000111;
					display3 = 7'b1000111;
					display2 = 7'b1000000;
				end
				3'd3: begin
					display2 = 7'b0001001;
					display1 = 7'b0000110;
					display0 = 7'b1000111;
					display4 = 7'b1000111;
					display3 = 7'b1000000;
				end
				3'd4: begin
					display3 = 7'b0001001;
					display2 = 7'b0000110;
					display1 = 7'b1000111;
					display0 = 7'b1000111;
					display4 = 7'b1000000;
				end	
				default: begin
					display4 = 7'b1111111;
					display3 = 7'b1111111;
					display2 = 7'b1111111;
					display1 = 7'b1111111;
					display0 = 7'b1111111;
				end
			endcase
		end
endmodule