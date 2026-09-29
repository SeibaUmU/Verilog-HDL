module test (
    input CLOCK_50,     
    input [1:0] SW,     // SW[1] dùng làm RS
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output reg [7:0] LEDG,
    output reg [17:0] LEDR
);
    
    wire Ck = CLOCK_50;
    wire RS = SW[1];
    
    parameter hex_s0 = 3'b000; // HEX
    parameter hex_s1 = 3'b001;
	 parameter hex_s2 = 3'b010;
	 parameter hex_s3 = 3'b011;
	 parameter hex_s4 = 3'b100;
	 parameter hex_s5 = 3'b101;
	 parameter hex_s6 = 3'b110;
	 parameter hex_s7 = 3'b111;
	 
    reg clock_2hz = 1'b0;  // Cho HEX
    reg clock_1hz = 1'b0;  // Cho LEDG 1hz
	 reg clock_200ms = 1'b0; // LEDG 200ms
    reg clock_3hz = 1'b0; // Cho LEDR 
    
    integer q_hex = 0;
    integer q_ledg = 0;
    integer q_ledr = 0;
	 integer q_ledg200ms = 0;
    
    reg [2:0] state_hex, next_state_hex;
    reg [2:0] code7, code6, code5, code4, code3, code2, code1, code0;
    
    reg [4:0] state_ledg;
    
    reg [1:0] state_ledr;
    
    
    
    always @(posedge Ck) begin
        
        q_hex = q_hex + 1;
        if (q_hex == 12500000) begin
            clock_2hz = ~clock_2hz;
            q_hex = 0;
        end
      
      /*  q_ledg = q_ledg + 1;
        if (q_ledg == 50000000) begin
            clock_1hz = ~clock_1hz;
            q_ledg = 0;
        end
        
		  q_ledg200ms = q_ledg200ms + 1;
		  if (q_ledg == 5000000) begin
            clock_200ms = ~clock_200ms;
            q_ledg200ms = 0;
        end*/
		  
        q_ledr = q_ledr + 1;
        if (q_ledr == 8300000) begin
            clock_3hz = ~clock_3hz;
            q_ledr = 0;
        end
    end
    
    
    // FSM 1: ĐIỀU KHIỂN HEX ("thang")
    
    always @(posedge clock_2hz) begin
        if (RS) state_hex <= hex_s0;
        else state_hex <= next_state_hex;
    end
    
    always @(*) begin
        case(state_hex)
            hex_s0: next_state_hex = hex_s1;
            hex_s1: next_state_hex = hex_s2;
				hex_s2: next_state_hex = hex_s3;
				hex_s3: next_state_hex = hex_s4;
				hex_s4: next_state_hex = hex_s5;
				hex_s5: next_state_hex = hex_s6;
				hex_s6: next_state_hex = hex_s7;
				hex_s7: next_state_hex = hex_s0;
            default: next_state_hex = hex_s0;
        endcase
    end
    
    always @(*) begin
        if (state_hex == hex_s0) begin
            code7 = 3'd0; code6 = 3'd1; code5 = 3'd1; code4 = 3'd2; 
            code3 = 3'd3; code2 = 3'd4; code1 = 3'd5; code0 = 3'd6; 
        end 
		  else if (state_hex == hex_s1) begin
            code7 = 3'd1; code6 = 3'd2; code5 = 3'd3; code4 = 3'd4; 
            code3 = 3'd5; code2 = 3'd6; code1 = 3'd7; code0 = 3'd0; 
			end
			else if (state_hex == hex_s2) begin
            code7 = 3'd2; code6 = 3'd3; code5 = 3'd4; code4 = 3'd5; 
            code3 = 3'd6; code2 = 3'd7; code1 = 3'd0; code0 = 3'd1; 
			end 
			else if (state_hex == hex_s3) begin
            code7 = 3'd3; code6 = 3'd4; code5 = 3'd5; code4 = 3'd6; 
            code3 = 3'd7; code2 = 3'd0; code1 = 3'd1; code0 = 3'd2; 
			end 
			else if (state_hex == hex_s4) begin
            code7 = 3'd4; code6 = 3'd5; code5 = 3'd6; code4 = 3'd7; 
            code3 = 3'd0; code2 = 3'd1; code1 = 3'd2; code0 = 3'd3; 
			end 
			else if (state_hex == hex_s5) begin
            code7 = 3'd5; code6 = 3'd6; code5 = 3'd7; code4 = 3'd0; 
            code3 = 3'd1; code2 = 3'd2; code1 = 3'd3; code0 = 3'd4; 
			end 
			else if (state_hex == hex_s6) begin
            code7 = 3'd6; code6 = 3'd7; code5 = 3'd0; code4 = 3'd1; 
            code3 = 3'd2; code2 = 3'd3; code1 = 3'd4; code0 = 3'd5; 
			end 
			else if (state_hex == hex_s7) begin
            code7 = 3'd7; code6 = 3'd0; code5 = 3'd1; code4 = 3'd2; 
            code3 = 3'd3; code2 = 3'd4; code1 = 3'd5; code0 = 3'd6; 
			end 
			
    end
    
    decoder_thang u7 (code7, HEX7);
    decoder_thang u6 (code6, HEX6);
    decoder_thang u5 (code5, HEX5);
    decoder_thang u4 (code4, HEX4);
    decoder_thang u3 (code3, HEX3);
    decoder_thang u2 (code2, HEX2);
    decoder_thang u1 (code1, HEX1);
    decoder_thang u0 (code0, HEX0);

    
    // FSM 2: ĐIỀU KHIỂN LEDG
   /*
    always @(posedge clock_1hz) begin
		if (RS) begin 
				state_ledg <= 5'd0;
            LEDG <= 8'b0;
		end else begin
        case(state_ledg)
                5'd0: begin LEDG = 8'b11111111; state_ledg <= 5'd1; end
				5'd1: begin LEDG = 8'b00000000; state_ledg <= 5'd2; end
				5'd2: begin LEDG = 8'b11111111; state_ledg <= 5'd3; end
				5'd3: begin LEDG = 8'b00000000; state_ledg <= 5'd4; end
				5'd4: begin LEDG = 8'b00000001; state_ledg <= 5'd5; end
				5'd5: begin LEDG = 8'b00000010; state_ledg <= 5'd6; end
				5'd6: begin LEDG = 8'b00000100; state_ledg <= 5'd7; end
				5'd7: begin LEDG = 8'b00001000; state_ledg <= 5'd8; end
				5'd8: begin LEDG = 8'b00010000; state_ledg <= 5'd9; end
				5'd9: begin LEDG = 8'b00100000; state_ledg <= 5'd10; end
				5'd10: begin LEDG = 8'b01000000; state_ledg <= 5'd11; end
				5'd11: begin LEDG = 8'b10000000; state_ledg <= 5'd12; end
				5'd12: begin LEDG = 8'b00000000; state_ledg <= 5'd0; end
        endcase
    end
    end 
    */

    // FSM 2: ĐIỀU KHIỂN LEDG
    // Thay vì dùng xung clock chia sẵn, ta dùng luôn Ck 50MHz và bộ đếm delay
    always @(posedge Ck) begin
        if (RS) begin 
            state_ledg <= 5'd0;
            LEDG <= 8'b0;
            delay_ledg <= 0;
        end else begin
            // Nếu bộ đếm delay vẫn lớn hơn 0, tiếp tục trừ dần (đứng chờ)
            if (delay_ledg > 0) begin
                delay_ledg <= delay_ledg - 1;
            end else begin
                // Khi delay đếm về 0, chuyển sang trạng thái mới
                case(state_ledg)
                    // --- GIAI ĐOẠN 1: Chớp tắt 1Hz (2 lần) ---
                    // 1Hz = 1 giây 1 chu kỳ -> 0.5s sáng, 0.5s tắt
                    //
                    5'd0: begin LEDG <= 8'b11111111; delay_ledg <= 50000000; state_ledg <= 5'd1; end // Sáng lần 1
                    5'd1: begin LEDG <= 8'b00000000; delay_ledg <= 50000000; state_ledg <= 5'd2; end // Tắt lần 1
                    5'd2: begin LEDG <= 8'b11111111; delay_ledg <= 50000000; state_ledg <= 5'd3; end // Sáng lần 2
                    5'd3: begin LEDG <= 8'b00000000; delay_ledg <= 50000000; state_ledg <= 5'd4; end // Tắt lần 2
                    
                    // --- GIAI ĐOẠN 2: Sáng đuổi (mỗi trạng thái 200ms) ---
                    // 
                    5'd4:  begin LEDG <= 8'b00000001; delay_ledg <= 5000000; state_ledg <= 5'd5; end
                    5'd5:  begin LEDG <= 8'b00000010; delay_ledg <= 5000000; state_ledg <= 5'd6; end
                    5'd6:  begin LEDG <= 8'b00000100; delay_ledg <= 5000000; state_ledg <= 5'd7; end
                    5'd7:  begin LEDG <= 8'b00001000; delay_ledg <= 5000000; state_ledg <= 5'd8; end
                    5'd8:  begin LEDG <= 8'b00010000; delay_ledg <= 5000000; state_ledg <= 5'd9; end
                    5'd9:  begin LEDG <= 8'b00100000; delay_ledg <= 5000000; state_ledg <= 5'd10; end
                    5'd10: begin LEDG <= 8'b01000000; delay_ledg <= 5000000; state_ledg <= 5'd11; end
                    5'd11: begin LEDG <= 8'b10000000; delay_ledg <= 5000000; state_ledg <= 5'd12; end
                    
                    // --- GIAI ĐOẠN 3: Tắt hết và lặp lại ---
                    // Tắt trong 200ms rồi quay lại trạng thái chớp đầu tiên
                    5'd12: begin LEDG <= 8'b00000000; delay_ledg <= 5000000; state_ledg <= 5'd0; end
                    
                    default: begin LEDG <= 8'b00000000; state_ledg <= 5'd0; end
                endcase
            end
        end
    end

    
    // FSM 3: ĐIỀU KHIỂN LEDR
    
    always @(posedge clock_3hz) begin
        if (RS) begin
            state_ledr <= 2'd0;
            LEDR <= 18'b0;
        end 
		  else begin
            case (state_ledr)
                // --- GIAI ĐOẠN 1: chop ---
                2'd0: begin LEDR <= 18'b111111111111111111; state_ledr <= 2'd1;  end
                // --- GIAI ĐOẠN 2: Tắt ---
                2'd1: begin LEDR <= 18'b000000000000000000; state_ledr <= 2'd2; end

                // --- GIAI ĐOẠN 3: chop ---
                2'd2: begin LEDR <= 18'b111111111111111111; state_ledr <= 2'd3; end
					 
					 2'd3: begin LEDR <= 18'b000000000000000000; state_ledr <= 2'd0; end

                default: begin LEDR <= 18'b0; state_ledr <= 2'd0; end
            endcase
        end
    end

endmodule


module decoder_thang(
    input  [2:0] char_code,
    output reg [6:0] seg
);
    always @(*) begin
        case(char_code)
            3'd0: seg = 7'b1111000; // T
            3'd1: seg = 7'b0001001; // H
            3'd2: seg = 7'b0001000; // A
            3'd3: seg = 7'b1001000; // N
            3'd4: seg = 7'b0000010; // G
            default: seg = 7'b1111111; 
        endcase
    end
endmodule