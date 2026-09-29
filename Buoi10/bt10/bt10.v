module bt10(LEDR, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, CLOCK_50);
    input [0:0] SW;
    input CLOCK_50;
    output reg [17:0] LEDR;
    output reg [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    parameter s0=4'd0, s1=4'd1, s2=4'd2, s3=4'd3, s4=4'd4, s5=4'd5, s6=4'd6, s7=4'd7, s8=4'd8;
    parameter t0=2'b00, t1=2'b01, t2 = 2'b10,  t3 = 2'b11;

    reg [3:0] ledcs, ledns;
    reg [1:0] hexcs, hexns;
    integer count_1hz, count_200ms;
    reg clk1hz, clk5hz;

    always @(posedge CLOCK_50 or posedge SW[0]) 
	 begin
        if (SW[0]) 
			begin
            count_1hz <= 0; count_200ms <= 0;
            clk1hz <= 0;    clk5hz <= 0;
			end 
		  else 
			begin
            if (count_1hz >= 24999999) 
					begin 
						count_1hz <= 0; 
						clk1hz <= ~clk1hz; 
					end
            else count_1hz <= count_1hz + 1;

            if (count_200ms >= 9999999) 
					begin 
						count_200ms <= 0; 
						clk5hz <= ~clk5hz; 
					end
            else count_200ms <= count_200ms + 1;
        end
    end

    always @(*) 
	 begin
        case (ledcs)
            s0: ledns = s1; 
				s1: ledns = s2; 
				s2: ledns = s3;
            s3: ledns = s4; 
				s4: ledns = s5; 
				s5: ledns = s6;
            s6: ledns = s7; 
				s7: ledns = s8; 
				s8: ledns = s0;
            default: ledns = s0;
        endcase
        case (hexcs)
            t0: hexns = t1;
            t1: hexns = t2;
				t2: hexns = t3;
				t3: hexns = t0;
            default: hexns = t0;
        endcase
    end

    always @(posedge clk1hz or posedge SW[0]) 
	 begin
        if (SW[0]) hexcs <= t0;
        else hexcs <= hexns;
    end

    always @(posedge clk5hz or posedge SW[0]) 
	 begin
        if (SW[0]) ledcs <= s0;
        else ledcs <= ledns;
    end

    always @(*) 
	 begin
        if (SW[0]) 
			begin
            LEDR = 18'b0;
            {HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
			end 
		  else 
			begin
				case (hexcs)
					t0: 
						begin
							HEX7 = 7'b0100001; 
							HEX6 = 7'b0000110; 
							HEX5 = 7'b0100100; 
							HEX4 = 7'b0111111;
							HEX3 = 7'b0001110; 
							HEX2 = 7'b0001100; 
							HEX1 = 7'b0010000; 
							HEX0 = 7'b0001000;
						end
					t1:
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
					t2:
						begin
							HEX7 = 7'b0100001; 
							HEX6 = 7'b0000110; 
							HEX5 = 7'b0100100; 
							HEX4 = 7'b0111111;
							HEX3 = 7'b0001110; 
							HEX2 = 7'b0001100; 
							HEX1 = 7'b0010000; 
							HEX0 = 7'b0001000;
						end
					t3:
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
					default: 
						begin
							{HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {8{7'b1111111}};
						end
				endcase
            case (ledcs)
                s0: LEDR = 18'b100000000000000001;
                s1: LEDR = 18'b010000000000000010;
                s2: LEDR = 18'b001000000000000100;
				s3: LEDR = 18'b000100000000001000;
                s4: LEDR = 18'b000010000000010000;
                s5: LEDR = 18'b000001000000100000;
                s6: LEDR = 18'b000000100001000000;
                s7: LEDR = 18'b000000010010000000;
                s8: LEDR = 18'b000000001100000000;
                default: LEDR = 18'b0;
            endcase
			end
    end
endmodule