module bt10(SW, HEX0, HEX1,LEDR,LEDG, CLOCK_50);
input [2:0]SW;
output reg [17:0]LEDR;
output reg [3:0]LEDG;
input CLOCK_50;
output reg [6:0]HEX0, HEX1;
parameter s0 = 5'b00000;
parameter s1 = 5'b00001;
parameter s2 = 5'b00010;
parameter s3 = 5'b00011;
parameter s4 = 5'b00100;
parameter s5 = 5'b00101;
parameter s6 = 5'b00110;
parameter s7 = 5'b00111;
parameter s8 = 5'b01000;
parameter s9  = 5'b01001;
parameter s10 = 5'b01010;
parameter s11 = 5'b01011;
parameter s12 = 5'b01100;
parameter s13 = 5'b01101;
parameter s14 = 5'b01110;
parameter s15 = 5'b01111;
parameter s16 = 5'b10000;
parameter s17 = 5'b10001;
parameter s18 = 5'b10010;
parameter s19 = 5'b10011;
parameter s20 = 5'b10100;
parameter s21 = 5'b10101;
parameter s22 = 5'b10110;
parameter s23 = 5'b10111;
parameter s24 = 5'b11000;
parameter s25 = 5'b11001;
parameter s26 = 5'b11010;
parameter s27 = 5'b11011;
parameter s28 = 5'b11100;
parameter s29 = 5'b11101;
parameter s30 = 5'b11110;
parameter s31 = 5'b11111;
reg [4:0]cs, ns;
integer q = 0;
reg clock_1s = 0;
reg [3:0]bcd1, bcd0;
reg y;
	always @(posedge CLOCK_50) 
		begin
        if (q == 24999999) 
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
	 s0 : ns = s1;
    s1 : ns = s2;
    s2 : ns = s3;
    s3 : ns = s4;
    s4 : ns = s5;
    s5 : ns = s6;
    s6 : ns = s7;
    s7 : ns = s8;
    s8 : ns = s9;
    s9 : ns = s10;
    s10: ns = s11;
    s11: ns = s12;
    s12: ns = s13;
    s13: ns = s14;
    s14: ns = s15;
    s15: ns = s16;
    s16: ns = s17;
    s17: ns = s18;
    s18: ns = s19;
    s19: ns = s20;
    s20: ns = s21;
    s21: ns = s22;
    s22: ns = s23;
    s23: ns = s24;
    s24: ns = s25;
	 s25: ns = s26;
    s26: ns = s27;
    s27: ns = s28;
    s28: ns = s29;
    s29: ns = s30;
    s30: ns = s0;

    
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
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd6;
					end
				s1:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd5;
					end
				s2:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd4;
					end
				s3:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd3;
					end
				s4:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd2;
					end
				s5:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd1;
					end
				s6:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd1;
						bcd0 = 4'd0;
					end
				s7:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd9;
						end
				s8:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd8;
					end
					
				s9:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd7;
					end
				s10:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd6;
					end
				s11:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd5;
					end
				s12:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd4;
					end
				s13:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd3;
					end
				s14:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd2;
					end
				s15:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd1;
					end
				s16:
					begin
						LEDG[0]=1'b1;
						LEDR[0]=1'b0;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd0;
					end
				s17:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b0;
						LEDR[17]=1'b1;
						bcd1 = 4'd0;
						bcd0 = 4'd5;
					end
				s18:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b0;
						LEDR[17]=1'b1;
						bcd1 = 4'd0;
						bcd0 = 4'd4;
					end																															
				s19:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b0;
						LEDR[17]=1'b1;
						bcd1 = 4'd0;
						bcd0 = 4'd3;
					end
				s20:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b0;
						LEDR[17]=1'b1;
						bcd1 = 4'd0;
						bcd0 = 4'd2;
					end
				s21:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b0;
						LEDR[17]=1'b1;
						bcd1 = 4'd0;
						bcd0 = 4'd1;
					end
					
				s22:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd9;
					end
				s23:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd8;
					end
							
				s24:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd7;
					end
				s25:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd6;
					end
				s26:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd5;
					end
				s27:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd4;
					end
				s28:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd3;
					end
				s29:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd2;
					end
				s30:
					begin
						LEDG[0]=1'b0;
						LEDR[0]=1'b1;
						LEDR[17]=1'b0;
						bcd1 = 4'd0;
						bcd0 = 4'd1;
					end
					default:
					begin
						
						bcd1 = 4'd0;
						bcd0 = 4'd0;
					end
			endcase
		end
		
	function [6:0] bcd_to_7seg(input [3:0] bcd);
        case (bcd)
            4'd0: bcd_to_7seg = 7'b1000000;
            4'd1: bcd_to_7seg = 7'b1111001;
            4'd2: bcd_to_7seg = 7'b0100100;
            4'd3: bcd_to_7seg = 7'b0110000;
            4'd4: bcd_to_7seg = 7'b0011001;
            4'd5: bcd_to_7seg = 7'b0010010;
            4'd6: bcd_to_7seg = 7'b0000010;
            4'd7: bcd_to_7seg = 7'b1111000;
            4'd8: bcd_to_7seg = 7'b0000000;
            4'd9: bcd_to_7seg = 7'b0010000;
            default: bcd_to_7seg = 7'b1111111;
        endcase
   endfunction
	always @(*)
		begin

			HEX1 = bcd_to_7seg(bcd1);
			HEX0 = bcd_to_7seg(bcd0);
		end
endmodule