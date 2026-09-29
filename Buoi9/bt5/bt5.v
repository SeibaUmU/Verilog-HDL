module bt5(SW, HEX0, HEX1, HEX2, HEX3, CLOCK_50);
input [2:0]SW;
input CLOCK_50;
output reg [6:0]HEX0, HEX1, HEX2, HEX3;
parameter s0 = 4'b0000;
parameter s1 = 4'b0001;
parameter s2 = 4'b0010;
parameter s3 = 4'b0011;
parameter s4 = 4'b0100;
parameter s5 = 4'b0101;
parameter s6 = 4'b0110;
parameter s7 = 4'b0111;
parameter s8 = 4'b1000;
reg [3:0]cs, ns;
integer q = 0;
reg clock_1s = 0;
reg [3:0] bcd3, bcd2, bcd1, bcd0;
reg y;
	always @(posedge CLOCK_50) 
		begin
        if (q == 49999999) 
			begin
            q <= 0;
            clock_1s <= ~clock_1s;
			end 
		  else 
			q <= q + 1;
		end
	always @(*)
		begin
			case (cs)
				s0: ns = s1;
				s1: ns = s2;
				s2: ns = s3;
				s3: ns = s4;
				s4: ns = s5;
				s5: ns = s6;
				s6: ns = s7;
				s7: ns = s8;
				s8: ns = s0;
				default: ns = s0;
			endcase
		end
	always @(posedge clock_1s)
		begin
			if (SW[1]) cs <= s0;
			else cs <= ns;
		end
	always @(*)
		begin
			case (cs)
				s0:
					begin
						bcd3 = 4'd3;
						bcd2 = 4'd3;
						bcd1 = 4'd3;
						bcd0 = 4'd3;
					end
				s1:
					begin
						bcd3 = 4'd2;
						bcd2 = 4'd3;
						bcd1 = 4'd3;
						bcd0 = 4'd3;
					end
				s2:
					begin
						bcd3 = 4'd1;
						bcd2 = 4'd2;
						bcd1 = 4'd3;
						bcd0 = 4'd3;
					end
				s3:
					begin
						bcd3 = 4'd1;
						bcd2 = 4'd1;
						bcd1 = 4'd2;
						bcd0 = 4'd3;
					end
				s4:
					begin
						bcd3 = 4'd0;
						bcd2 = 4'd1;
						bcd1 = 4'd1;
						bcd0 = 4'd2;
					end
				s5:
					begin
						bcd3 = 4'd0;
						bcd2 = 4'd1;
						bcd1 = 4'd1;
						bcd0 = 4'd2;
					end
				s6:
					begin
						bcd3 = 4'd3;
						bcd2 = 4'd0;
						bcd1 = 4'd1;
						bcd0 = 4'd1;
					end
				s7:
					begin
						bcd3 = 4'd3;
						bcd2 = 4'd3;
						bcd1 = 4'd0;
						bcd0 = 4'd1;
					end
				s8:
					begin
						bcd3 = 4'd3;
						bcd2 = 4'd3;
						bcd1 = 4'd3;
						bcd0 = 4'd0;
					end
				default:
					begin
						bcd3 = 4'd3;
						bcd2 = 4'd3;
						bcd1 = 4'd3;
						bcd0 = 4'd3;
					end
			endcase
		end
	function [6:0] bcd_to_7seg(input [3:0] bcd);
        case (bcd)
            4'd0: bcd_to_7seg = 7'b1000010;
            4'd1: bcd_to_7seg = 7'b0100011;
            4'd2: bcd_to_7seg = 7'b0100001;
            default: bcd_to_7seg = 7'b1111111;
        endcase
   endfunction
	always @(*)
		begin
			HEX3 = bcd_to_7seg(bcd3);
			HEX2 = bcd_to_7seg(bcd2);
			HEX1 = bcd_to_7seg(bcd1);
			HEX0 = bcd_to_7seg(bcd0);
		end
endmodule