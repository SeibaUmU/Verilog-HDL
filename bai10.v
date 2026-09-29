module bai10(LEDR, LEDG, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, CLOCK_50);
    input [0:0] SW;
    input CLOCK_50;
    output reg [17:0] LEDR;
	 output reg [7:0] LEDG;
    output reg [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    parameter s0=4'd0, s1=4'd1, s2=4'd2, s3=4'd3, s4=4'd4, s5=4'd5, s6=4'd6, s7=4'd7, s8=4'd8, s9=4'd9, s10=4'd10, s11=4'd11, s12=4'd12, s13=4'd13, s14=4'd14, s15=4'd15;
    parameter t0=4'd0, t1=4'd1, t2 = 4'd2,  t3 = 4'd3, t4 = 4'd4, t5 = 4'd5, t6 = 4'd6, t7 = 4'd7, t8 = 4'd8;
	 parameter u0=2'b00, u1=2'b01, u2=2'b10, u3=2'b11;

    reg [3:0] ledgcs, ledgns;
    reg [3:0] hexcs, hexns;
	 reg [1:0] ledrcs, ledrns;
    integer count_2hz, count_300ms, count_3hz;
    reg clk2hz, clk300ms, clk3hz;

    always @(posedge CLOCK_50 or posedge SW[0]) 
	 begin
        if (SW[0]) 
			begin
            count_2hz <= 0; count_300ms <= 0;
            clk2hz <= 0;    clk300ms <= 0;
				count_3hz <= 0; clk3hz <= 0;
			end 
		  else 
			begin
            if (count_2hz >= 12499999) 
					begin 
						count_2hz <= 0; 
						clk2hz <= ~clk2hz; 
					end
            else count_2hz <= count_2hz + 1;

            if (count_300ms >= 14999999) 
					begin 
						count_300ms <= 0; 
						clk300ms <= ~clk300ms; 
					end
            else count_300ms <= count_300ms + 1;
				
				if (count_3hz >= 8333332) 
					begin 
						count_3hz <= 0; 
						clk3hz <= ~clk3hz; 
					end
            else count_3hz <= count_3hz + 1;
        end
    end

    always @(*) 
	 begin
        case (ledgcs)
            s0: ledgns = s1; 
				s1: ledgns = s2; 
				s2: ledgns = s3;
            s3: ledgns = s4; 
				s4: ledgns = s5; 
				s5: ledgns = s6;
            s6: ledgns = s7; 
				s7: ledgns = s8; 
				s8: ledgns = s9;
				s9: ledgns = s10; 
				s10: ledgns = s11; 
				s11: ledgns = s12;
            s12: ledgns = s13; 
				s13: ledgns = s14; 
				s14: ledgns = s15;
            s15: ledgns = s0; 
            default: ledgns = s0;
        endcase
        case (hexcs)
            t0: hexns = t1;
            t1: hexns = t2;
				t2: hexns = t3;
				t3: hexns = t4;
				t4: hexns = t5;
            t5: hexns = t6;
				t6: hexns = t7;
				t7: hexns = t8;
				t8: hexns = t0;
            default: hexns = t0;
        endcase
		  case (ledrcs)
				u0: ledrns = u1;
				u1: ledrns = u2;
				u2: ledrns = u3;
				u3: ledrns = u0;
				default: ledrns = u0;
			endcase
    end

    always @(posedge clk2hz) 
	 begin
        if (SW[0]) hexcs <= t0;
        else hexcs <= hexns;
    end

    always @(posedge clk300ms) 
	 begin
        if (SW[0]) ledgcs <= 8'b0;
        else ledgcs <= ledgns;
    end
	 
	 always @(posedge clk3hz) 
	 begin
        if (SW[0]) ledrcs <= u0;
        else ledrcs <= ledrns;
    end

    always @(*) 
	 begin
        if (SW[0]) 
			begin
            LEDG = 8'b0;
            {HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
			LEDR = 18'b0;
			end 
		  else 
			begin
				case (hexcs)
					t0: 
						begin
							HEX7 = 7'b1111111; 
							HEX6 = 7'b1111111; 
							HEX5 = 7'b1111111; 
							HEX4 = 7'b0001001;
							HEX3 = 7'b0001011; 
							HEX2 = 7'b0100011; 
							HEX1 = 7'b0101011; 
							HEX0 = 7'b0010000;
						end
					t1:
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
					t2:
						begin
							HEX7 = 7'b1111111; 
							HEX6 = 7'b1111111; 
							HEX5 = 7'b1111111; 
							HEX4 = 7'b0001001;
							HEX3 = 7'b0001011; 
							HEX2 = 7'b0100011; 
							HEX1 = 7'b0101011; 
							HEX0 = 7'b0010000;
						end
					t3:
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
					t4:
						begin
							HEX6 = 7'b1111111; 
							HEX5 = 7'b1111111; 
							HEX4 = 7'b1111111; 
							HEX5 = 7'b0001001;
							HEX2 = 7'b0001011; 
							HEX1 = 7'b0100011; 
							HEX0 = 7'b0101011; 
							HEX7 = 7'b0010000;
						end
					t5:
						begin
							HEX5 = 7'b1111111; 
							HEX4 = 7'b1111111; 
							HEX3 = 7'b1111111; 
							HEX2 = 7'b0001001;
							HEX1 = 7'b0001011; 
							HEX0 = 7'b0100011; 
							HEX7 = 7'b0101011; 
							HEX6 = 7'b0010000;
						end
					t6:
						begin
							HEX4 = 7'b1111111; 
							HEX3 = 7'b1111111; 
							HEX2 = 7'b1111111; 
							HEX1 = 7'b0001001;
							HEX0 = 7'b0001011; 
							HEX7 = 7'b0100011; 
							HEX6 = 7'b0101011; 
							HEX5 = 7'b0010000;
						end
					t7:
						begin
							HEX3 = 7'b1111111; 
							HEX2 = 7'b1111111; 
							HEX1 = 7'b1111111; 
							HEX0 = 7'b0001001;
							HEX7 = 7'b0001011; 
							HEX6 = 7'b0100011; 
							HEX5 = 7'b0101011; 
							HEX4 = 7'b0010000;
						end
					t8:
						begin
							HEX2 = 7'b1111111; 
							HEX1 = 7'b1111111; 
							HEX0 = 7'b1111111; 
							HEX7 = 7'b0001001;
							HEX6 = 7'b0001011; 
							HEX5 = 7'b0100011; 
							HEX4 = 7'b0101011; 
							HEX3 = 7'b0010000;
						end
					default: 
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
				endcase
            case (ledgcs)
                s0: LEDG = 8'b00000001;
                s1: LEDG = 8'b00000011;
                s2: LEDG = 8'b00000111;
                s3: LEDG = 8'b00001111;
                s4: LEDG = 8'b00011111;
                s5: LEDG = 8'b00111111;
                s6: LEDG = 8'b01111111;
                s7: LEDG = 8'b11111111;
                s8: LEDG = 8'b10000000;
				s9: LEDG = 8'b01000000;
                s10: LEDG = 8'b00100000;
                s11: LEDG = 8'b00010000;
                s12: LEDG = 8'b00001000;
                s13: LEDG = 8'b00000100;
                s14: LEDG = 8'b00000010;
                s15: LEDG = 8'b00000001;
                default: LEDG = 8'b0;
            endcase
				case (ledrcs)
                u0: LEDR = 18'b111111111111111111;
                u1: LEDR = 18'b000000000000000000;
                u2: LEDR = 18'b111111111111111111;
                u3: LEDR = 18'b000000000000000000;
                default: LEDR = 18'b0;
            endcase
			end
    end
endmodule