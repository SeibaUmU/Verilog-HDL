module bt5(
    input CLOCK_50,
    input [17:0] SW,
    output reg [6:0] HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output reg [0:0] LEDR
);
    integer q = 0;
    reg clock_1s = 0;
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

    reg [3:0] s0, s1, m0, m1, h0, h1;
    always @(posedge clock_1s or negedge SW[0]) 
		begin
        if (!SW[0]) 
			begin
            {s0, s1, m0, m1, h0, h1} <= 24'b0;
			end 
		  else 
			begin
            if (s0 == 9) 
					begin
                s0 <= 0;
                if (s1 == 5) 
						begin
                    s1 <= 0;
                    if (m0 == 9) 
							begin
                        m0 <= 0;
                        if (m1 == 5) 
									begin
                            m1 <= 0;
                            if (h1 == 2 && h0 == 3) 
										begin 
											h0 <= 0; h1 <= 0; 
										end
                            else if (h0 == 9) 
										begin 
											h0 <= 0; 
											h1 <= h1 + 1'b1; 
										end
                            else 
										h0 <= h0 + 1'b1;
									end 
								else 
									m1 <= m1 + 1'b1;
							end 
						  else 
							m0 <= m0 + 1'b1;
						end 
					 else 
						s1 <= s1 + 1'b1;
					end 
				else 
					s0 <= s0 + 1'b1;
        end
    end

    wire [3:0] al_h1 = SW[17:14];
    wire [3:0] al_h0 = SW[13:10];
    wire [3:0] al_m1 = SW[9:6];
    wire [3:0] al_m0 = SW[5:2];

    always @(*) 
		begin
        if (h1 == al_h1 && h0 == al_h0 && m1 == al_m1 && m0 == al_m0 && SW[1] == 0)
            LEDR[0] = 1'b1;
        else
            LEDR[0] = 1'b0;
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

    always @(*) begin
        if (SW[1]) 
			begin
            HEX2 = 7'b1111111;
            HEX3 = 7'b1111111;
            HEX4 = bcd_to_7seg(al_m0);
            HEX5 = bcd_to_7seg(al_m1);
            HEX6 = bcd_to_7seg(al_h0);
            HEX7 = bcd_to_7seg(al_h1);
			end 
		  else 
			begin
            HEX2 = bcd_to_7seg(s0);
            HEX3 = bcd_to_7seg(s1);
            HEX4 = bcd_to_7seg(m0);
            HEX5 = bcd_to_7seg(m1);
            HEX6 = bcd_to_7seg(h0);
            HEX7 = bcd_to_7seg(h1);
			end
    end
endmodule