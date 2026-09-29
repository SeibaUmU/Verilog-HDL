module bt9 (
    input CLOCK_50,     
    input [1:0] SW,     // SW[1] dùng làm RS
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output reg [7:0] LEDG,
    output reg [17:0] LEDR
);
    
    wire Ck = CLOCK_50;
    wire RS = SW[1];
    
    parameter hex_s0 = 2'b00; // HEX
    parameter hex_s1 = 2'b01;
	 parameter hex_s2 = 2'b10;
	 
	 parameter ledg_s0 = 2'b00; // LEDG
    parameter ledg_s1 = 2'b01;
	 parameter ledg_s2 = 2'b10;
    
    parameter ledr_s0 = 2'b00; // LEDR: Trái -> Phải
    parameter ledr_s1 = 2'b01; // Tắt 
    parameter ledr_s2 = 2'b10; // Phải -> Trái
    parameter ledr_s3 = 2'b11; // Tắt 
    
    
    reg clock_2hz = 1'b0;  // Cho HEX
    reg clock_4hz = 1'b0;  // Cho LEDG
    reg clock_10hz = 1'b0; // Cho LEDR (100ms/trạng thái = 10Hz)
    
    integer q_hex = 0;
    integer q_ledg = 0;
    integer q_ledr = 0;
    
    reg [1:0] state_hex, next_state_hex;
    reg [2:0] code7, code6, code5, code4, code3, code2, code1, code0;
    
    reg [1:0] state_ledg, next_state_ledg;
    
    reg [5:0] state_ledr, next_state_ledr;
    
    
    
    always @(negedge Ck) begin
        
        q_hex = q_hex + 1;
        if (q_hex == 12500000) begin
            clock_2hz = ~clock_2hz;
            q_hex = 0;
        end
        
        
        q_ledg = q_ledg + 1;
        if (q_ledg == 6250000) begin
            clock_4hz = ~clock_4hz;
            q_ledg = 0;
        end
        
		  
        q_ledr = q_ledr + 1;
        if (q_ledr == 2500000) begin
            clock_10hz = ~clock_10hz;
            q_ledr = 0;
        end
    end
    
    
    // FSM 1: ĐIỀU KHIỂN HEX ("GOODBYE!")
    
    always @(negedge clock_2hz) begin
        if (RS) state_hex <= hex_s0;
        else state_hex <= next_state_hex;
    end
    
    always @(*) begin
        case(state_hex)
            hex_s0: next_state_hex = hex_s1;
            hex_s1: next_state_hex = hex_s2;
				hex_s2: next_state_hex = hex_s0;
            default: next_state_hex = hex_s0;
        endcase
    end
    
    always @(*) begin
        if (state_hex == hex_s1) begin
            code7 = 3'd0; code6 = 3'd1; code5 = 3'd1; code4 = 3'd2; 
            code3 = 3'd3; code2 = 3'd4; code1 = 3'd5; code0 = 3'd6; 
        end else begin
            code7 = 3'd7; code6 = 3'd7; code5 = 3'd7; code4 = 3'd7; 
            code3 = 3'd7; code2 = 3'd7; code1 = 3'd7; code0 = 3'd7; 
        end
    end
    
    decoder_goodbye u7 (code7, HEX7);
    decoder_goodbye u6 (code6, HEX6);
    decoder_goodbye u5 (code5, HEX5);
    decoder_goodbye u4 (code4, HEX4);
    decoder_goodbye u3 (code3, HEX3);
    decoder_goodbye u2 (code2, HEX2);
    decoder_goodbye u1 (code1, HEX1);
    decoder_goodbye u0 (code0, HEX0);

    
    // FSM 2: ĐIỀU KHIỂN LEDG
    
    always @(negedge clock_4hz) begin
        if (RS) state_ledg <= ledg_s0;
        else state_ledg <= next_state_ledg;
    end
    
    always @(*) begin
        case(state_ledg)
            ledg_s0: next_state_ledg = ledg_s1;
            ledg_s1: next_state_ledg = ledg_s2;
				ledg_s2: next_state_ledg = ledg_s0;
            default: next_state_ledg = ledg_s0;
        endcase
    end
    
    always @(*) begin
        if (state_ledg == ledg_s1) LEDG = 8'b11111111;
        else                  LEDG = 8'b00000000;
    end

    
    // FSM 3: ĐIỀU KHIỂN LEDR
    
    always @(negedge clock_10hz) begin
        if (RS) begin
            state_ledr <= 6'd0;
            LEDR <= 18'b0;
        end else begin
            case (state_ledr)
                // --- GIAI ĐOẠN 1: Sáng dần từ Trái sang Phải (LED 17 về 0) ---
                6'd0:  begin LEDR <= 18'b100000000000000000; state_ledr <= 6'd1;  end
                6'd1:  begin LEDR <= 18'b110000000000000000; state_ledr <= 6'd2;  end
                6'd2:  begin LEDR <= 18'b111000000000000000; state_ledr <= 6'd3;  end
                6'd3:  begin LEDR <= 18'b111100000000000000; state_ledr <= 6'd4;  end
                6'd4:  begin LEDR <= 18'b111110000000000000; state_ledr <= 6'd5;  end
                6'd5:  begin LEDR <= 18'b111111000000000000; state_ledr <= 6'd6;  end
                6'd6:  begin LEDR <= 18'b111111100000000000; state_ledr <= 6'd7;  end
                6'd7:  begin LEDR <= 18'b111111110000000000; state_ledr <= 6'd8;  end
                6'd8:  begin LEDR <= 18'b111111111000000000; state_ledr <= 6'd9;  end
                6'd9:  begin LEDR <= 18'b111111111100000000; state_ledr <= 6'd10; end
                6'd10: begin LEDR <= 18'b111111111110000000; state_ledr <= 6'd11; end
                6'd11: begin LEDR <= 18'b111111111111000000; state_ledr <= 6'd12; end
                6'd12: begin LEDR <= 18'b111111111111100000; state_ledr <= 6'd13; end
                6'd13: begin LEDR <= 18'b111111111111110000; state_ledr <= 6'd14; end
                6'd14: begin LEDR <= 18'b111111111111111000; state_ledr <= 6'd15; end
                6'd15: begin LEDR <= 18'b111111111111111100; state_ledr <= 6'd16; end
                6'd16: begin LEDR <= 18'b111111111111111110; state_ledr <= 6'd17; end
                6'd17: begin LEDR <= 18'b111111111111111111; state_ledr <= 6'd18; end

                // --- GIAI ĐOẠN 2: Tắt ---
                6'd18: begin LEDR <= 18'b000000000000000000; state_ledr <= 6'd19; end

                // --- GIAI ĐOẠN 3: Sáng dần từ Phải sang Trái (LED 0 lên 17) ---
                6'd19: begin LEDR <= 18'b000000000000000001; state_ledr <= 6'd20; end
                6'd20: begin LEDR <= 18'b000000000000000011; state_ledr <= 6'd21; end
                6'd21: begin LEDR <= 18'b000000000000000111; state_ledr <= 6'd22; end
                6'd22: begin LEDR <= 18'b000000000000001111; state_ledr <= 6'd23; end
                6'd23: begin LEDR <= 18'b000000000000011111; state_ledr <= 6'd24; end
                6'd24: begin LEDR <= 18'b000000000000111111; state_ledr <= 6'd25; end
                6'd25: begin LEDR <= 18'b000000000001111111; state_ledr <= 6'd26; end
                6'd26: begin LEDR <= 18'b000000000011111111; state_ledr <= 6'd27; end
                6'd27: begin LEDR <= 18'b000000000111111111; state_ledr <= 6'd28; end
                6'd28: begin LEDR <= 18'b000000001111111111; state_ledr <= 6'd29; end
                6'd29: begin LEDR <= 18'b000000011111111111; state_ledr <= 6'd30; end
                6'd30: begin LEDR <= 18'b000000111111111111; state_ledr <= 6'd31; end
                6'd31: begin LEDR <= 18'b000001111111111111; state_ledr <= 6'd32; end
                6'd32: begin LEDR <= 18'b000011111111111111; state_ledr <= 6'd33; end
                6'd33: begin LEDR <= 18'b000111111111111111; state_ledr <= 6'd34; end
                6'd34: begin LEDR <= 18'b001111111111111111; state_ledr <= 6'd35; end
                6'd35: begin LEDR <= 18'b011111111111111111; state_ledr <= 6'd36; end
                6'd36: begin LEDR <= 18'b111111111111111111; state_ledr <= 6'd37; end

                // --- GIAI ĐOẠN 4: Tắt ---
                6'd37: begin LEDR <= 18'b000000000000000000; state_ledr <= 6'd0;  end

                default: begin LEDR <= 18'b0; state_ledr <= 6'd0; end
            endcase
        end
    end

endmodule


module decoder_goodbye(
    input  [2:0] char_code,
    output reg [6:0] seg
);
    always @(*) begin
        case(char_code)
            3'd0: seg = 7'b1000010; // G
            3'd1: seg = 7'b1000000; // O
            3'd2: seg = 7'b0100001; // d
            3'd3: seg = 7'b0000011; // b
            3'd4: seg = 7'b0010001; // y
            3'd5: seg = 7'b0000110; // E
            3'd6: seg = 7'b1111001; // !
            3'd7: seg = 7'b1111111; // (OFF)
            default: seg = 7'b1111111; 
        endcase
    end
endmodule