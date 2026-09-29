module bt3 (
    input  [1:0] SW,
    output reg [6:0] HEX3, 
    output reg [6:0] HEX2, 
    output reg [6:0] HEX1, 
    output reg [6:0] HEX0
);
	 localparam CHU_A = 7'b0001000, CHU_B = 7'b0000000, CHU_C = 7'b1000110, CHU_D = 7'b0100001;
	 localparam CHU_E = 7'b0000110, CHU_F = 7'b0001110, CHU_G = 7'b1000010, CHU_H = 7'b0001001;
	 localparam CHU_I = 7'b1111001, CHU_J = 7'b1110001, CHU_K = 7'b0001010, CHU_L = 7'b1000111;
	 localparam CHU_M = 7'b1001000, CHU_N = 7'b0101011, CHU_O = 7'b1000000, CHU_P = 7'b0001100;
	 localparam CHU_Q = 7'b0011000, CHU_R = 7'b0101111, CHU_S = 7'b0010010, CHU_T = 7'b0000111;
	 localparam CHU_U = 7'b1000001, CHU_V = 7'b1100011, CHU_W = 7'b1000100, CHU_X = 7'b0001001; // X dùng chung mã H hoặc K tùy biến
	 localparam CHU_Y = 7'b0010001, CHU_Z = 7'b0100100, TAT   = 7'b1111111;
	 
    always @(*) begin
		case (SW)
			2'b00 : begin
				HEX3 = CHU_F;
				HEX2 = CHU_P;
				HEX1 = CHU_G;
				HEX0 = CHU_A;
			end
			2'b01 : begin
				HEX3 = CHU_B;
				HEX2 = CHU_A;
				HEX1 = CHU_B;
				HEX0 = CHU_Y;
			end
			2'b10 : begin
				HEX3 = CHU_F;
				HEX2 = CHU_L;
				HEX1 = CHU_A;
				HEX0 = CHU_G;
			end
			default : begin
				HEX3 = TAT;
				HEX2 = TAT;
				HEX1 = TAT;
				HEX0 = TAT;
			end
		endcase
	  end
endmodule