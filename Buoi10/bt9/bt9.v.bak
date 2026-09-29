module bt4(
	input CLOCK_50,
	input [1:0] SW,
	output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
	
	parameter s0 = 2'b00; 
   parameter s1 = 2'b01;
	parameter s2 = 2'b10;
	parameter s3 = 2'b11;
   reg [1:0] current_state, next_state;
	reg clock_2hz = 1'b0;
	integer q;
	reg [2:0] code3, code2, code1, code0;
	wire rs = SW[1];
	
	always @(posedge CLOCK_50)
	begin
		q=q+1;
		if (q==12500000)
		begin
			clock_2hz = ~clock_2hz;
			q=0;
		end
	end
	
	always @(posedge clock_2hz or negedge rs)
	begin
		if(!rs) current_state <= s0;
		else current_state <= next_state;
	end
	
	
    always @(*) begin
        case(current_state)
            s0: next_state = s1;
            s1: next_state = s2;
				s2: next_state = s3;
				s3: next_state = s0;
            default: next_state = s0;
        endcase
    end
    
    
    always @(*) begin
        if (current_state == s1 | current_state == s3) begin
            code3 = 3'd0; // L
            code2 = 3'd1; // O
            code1 = 3'd2; // V
            code0 = 3'd3; // E
        end else begin
            code3 = 3'd4; 
            code2 = 3'd4; 
            code1 = 3'd4; 
            code0 = 3'd4;
        end
    end

    
    decoder_love u3 (code3, HEX3);
    decoder_love u2 (code2, HEX2);
    decoder_love u1 (code1, HEX1);
    decoder_love u0 (code0, HEX0);

    
    assign HEX7 = 7'b1111111;
    assign HEX6 = 7'b1111111;
    assign HEX5 = 7'b1111111;
    assign HEX4 = 7'b1111111;

endmodule

module decoder_love(
    input  [2:0] char_code,
    output reg [6:0] seg
);
    always @(*) begin
        case(char_code)
            3'd0: seg = 7'b1000111; // L
            3'd1: seg = 7'b1000000; // O
            3'd2: seg = 7'b1000001; // V
            3'd3: seg = 7'b0000110; // E
            3'd4: seg = 7'b1111111; // (OFF)
            default: seg = 7'b1111111; 
        endcase
    end
endmodule


