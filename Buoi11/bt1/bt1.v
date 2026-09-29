module bt1(
    input  CLOCK_50,
    output LCD_ON,
    output LCD_BLON,
    output LCD_EN,
    output LCD_RS,
    output LCD_RW,
    inout  [7:0] LCD_DATA,
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output reg [7:0] LEDG,
    output reg [17:0] LEDR
);
parameter hex_s0 = 2'b00; // Trạng thái TẮT
parameter hex_s1 = 2'b01; // Trạng thái SÁNG

// ========================
// Khai báo biến LCD
// ========================
reg [8:0] data;
reg on, blon, en, rw;
reg [5:0] state;
reg [2:0] index;
reg flag;
reg [19:0] count_lcd;
reg [19:0] countend;

// Biến cho chức năng nhấp nháy 2Hz
reg [24:0] blink_count;
reg blink_en;
reg blink_prev;

// ========================
// Biến cho HEX, LEDG, LEDR
// ========================
integer q_hex = 0;
integer q_ledg = 0;
integer q_ledr = 0;

reg clock_hex  = 1'b0; // Clock cho HEX (4Hz)
reg clock_ledg = 1'b0; // Clock cho LEDG (100ms/trạng thái)
reg clock_ledr = 1'b0; // Clock cho LEDR (200ms/trạng thái)

reg [1:0] state_hex = 2'b00;
reg [1:0] next_state_hex; 
reg [3:0] code7, code6, code5, code4, code3, code2, code1, code0;

reg [4:0] state_ledg; // Máy trạng thái cho LED xanh
reg [5:0] state_ledr; // Máy trạng thái cho LED đỏ

// ========================
// Gán tín hiệu ngõ ra LCD
// ========================
assign LCD_ON   = on;
assign LCD_BLON = blon;
assign LCD_EN   = en;
assign LCD_RS   = data[8];
assign LCD_RW   = rw;
assign LCD_DATA = (!rw) ? data[7:0] : 8'hzz;

// ========================
// Khởi tạo giá trị ban đầu
// ========================
initial begin
    on          <= 1'b1;
    blon        <= 1'b1; 
    en          <= 1'b0;
    rw          <= 1'b0;
    data        <= 9'b0;
    state       <= 6'b0;
    index       <= 3'b0;
    flag        <= 1'b1;
    count_lcd   <= 20'b0;
    countend    <= 20'hFFFFF;
    blink_count <= 25'b0;
    blink_en    <= 1'b1;
    blink_prev  <= 1'b1;
    
    state_hex   <= 1'b0;
    state_ledg  <= 5'd0;
    state_ledr  <= 6'd0;
end

// ========================
// Bộ đếm tạo xung nhịp (Clocks Generator)
// ========================
always @(posedge CLOCK_50) begin
    // 1. Tạo xung chớp tắt LCD 2Hz (Sáng 0.5s, Tắt 0.5s) => Đảo trạng thái sau mỗi 25000000 chu kỳ
    if (blink_count == 25'd24999999) begin
        blink_count <= 25'b0;
        blink_en    <= ~blink_en;
    end else begin
        blink_count <= blink_count + 1'b1;
    end

    // 2. Tạo xung chớp tắt HEX 4Hz (Chu kỳ 0.25s => Đảo sau mỗi 0.125s) => 6,250,000 chu kỳ
    if (q_hex == 6249999) begin
        clock_hex <= ~clock_hex;
        q_hex <= 0;
    end else q_hex <= q_hex + 1;

    // 3. Tạo xung cho LEDG 100ms/trạng thái (Cạnh lên sau mỗi 100ms => Đảo sau 50ms) => 2,500,000 chu kỳ
    if (q_ledg == 2499999) begin
        clock_ledg <= ~clock_ledg;
        q_ledg <= 0;
    end else q_ledg <= q_ledg + 1;
        
    // 4. Tạo xung cho LEDR 200ms/trạng thái (Cạnh lên sau mỗi 200ms => Đảo sau 100ms) => 5,000,000 chu kỳ
    if (q_ledr == 4999999) begin
        clock_ledr <= ~clock_ledr;
        q_ledr <= 0;
    end else q_ledr <= q_ledr + 1;
end

// ========================
// Bộ đếm tạo trễ LCD (Delay)
// ========================
always @(posedge CLOCK_50) begin
    if (flag == 1'b1) begin
        if (count_lcd < countend)
            count_lcd <= count_lcd + 1'b1;
        else
            count_lcd <= 20'b0;
    end
end

// ========================
// FSM 1: ĐIỀU KHIỂN HEX (12345678 nhấp nháy 4Hz)
// ========================
always @(posedge clock_hex) begin
    state_hex <= next_state_hex;
end

// 3. Khối Combinational: Logic trạng thái kế tiếp (Dùng CASE để tool build ra FSM)
always @(*) begin
    case(state_hex)
        hex_s0:  next_state_hex = hex_s1;
        hex_s1:  next_state_hex = hex_s0;
        default: next_state_hex = hex_s0;
    endcase
end

// 4. Khối Combinational: Logic ngõ ra
always @(*) begin
    if (state_hex == hex_s1) begin // Trạng thái SÁNG
        code7 = 4'd0; code6 = 4'd1; code5 = 4'd2; code4 = 4'd3; 
        code3 = 4'd4; code2 = 4'd5; code1 = 4'd6; code0 = 4'd7; 
    end else begin                 // Trạng thái TẮT
        code7 = 4'd8; code6 = 4'd8; code5 = 4'd8; code4 = 4'd8; 
        code3 = 4'd8; code2 = 4'd8; code1 = 4'd8; code0 = 4'd8; 
    end
end

decoder_so u7 (code7, HEX7);
decoder_so u6 (code6, HEX6);
decoder_so u5 (code5, HEX5);
decoder_so u4 (code4, HEX4);
decoder_so u3 (code3, HEX3);
decoder_so u2 (code2, HEX2);
decoder_so u1 (code1, HEX1);
decoder_so u0 (code0, HEX0);

// ========================
// FSM 2: ĐIỀU KHIỂN LEDR (18 LEDs Sáng dần L->R, rồi R->L)
// Viết tường minh toàn bộ 37 trạng thái (Không gộp logic)
// ========================
always @(posedge clock_ledr) begin
    case (state_ledr)
        // Giai đoạn 1: Sáng dần từ trái sang phải
        6'd0:  begin LEDR <= 18'b000000000000000000; state_ledr <= 6'd1;  end
        6'd1:  begin LEDR <= 18'b100000000000000000; state_ledr <= 6'd2;  end
        6'd2:  begin LEDR <= 18'b110000000000000000; state_ledr <= 6'd3;  end
        6'd3:  begin LEDR <= 18'b111000000000000000; state_ledr <= 6'd4;  end
        6'd4:  begin LEDR <= 18'b111100000000000000; state_ledr <= 6'd5;  end
        6'd5:  begin LEDR <= 18'b111110000000000000; state_ledr <= 6'd6;  end
        6'd6:  begin LEDR <= 18'b111111000000000000; state_ledr <= 6'd7;  end
        6'd7:  begin LEDR <= 18'b111111100000000000; state_ledr <= 6'd8;  end
        6'd8:  begin LEDR <= 18'b111111110000000000; state_ledr <= 6'd9;  end
        6'd9:  begin LEDR <= 18'b111111111000000000; state_ledr <= 6'd10; end
        6'd10: begin LEDR <= 18'b111111111100000000; state_ledr <= 6'd11; end
        6'd11: begin LEDR <= 18'b111111111110000000; state_ledr <= 6'd12; end
        6'd12: begin LEDR <= 18'b111111111111000000; state_ledr <= 6'd13; end
        6'd13: begin LEDR <= 18'b111111111111100000; state_ledr <= 6'd14; end
        6'd14: begin LEDR <= 18'b111111111111110000; state_ledr <= 6'd15; end
        6'd15: begin LEDR <= 18'b111111111111111000; state_ledr <= 6'd16; end
        6'd16: begin LEDR <= 18'b111111111111111100; state_ledr <= 6'd17; end
        6'd17: begin LEDR <= 18'b111111111111111110; state_ledr <= 6'd18; end
        6'd18: begin LEDR <= 18'b111111111111111111; state_ledr <= 6'd19; end

        // Giai đoạn 2: Sáng dần từ phải sang trái
        6'd19: begin LEDR <= 18'b000000000000000000; state_ledr <= 6'd20; end
        6'd20: begin LEDR <= 18'b000000000000000001; state_ledr <= 6'd21; end
        6'd21: begin LEDR <= 18'b000000000000000011; state_ledr <= 6'd22; end
        6'd22: begin LEDR <= 18'b000000000000000111; state_ledr <= 6'd23; end
        6'd23: begin LEDR <= 18'b000000000000001111; state_ledr <= 6'd24; end
        6'd24: begin LEDR <= 18'b000000000000011111; state_ledr <= 6'd25; end
        6'd25: begin LEDR <= 18'b000000000000111111; state_ledr <= 6'd26; end
        6'd26: begin LEDR <= 18'b000000000001111111; state_ledr <= 6'd27; end
        6'd27: begin LEDR <= 18'b000000000011111111; state_ledr <= 6'd28; end
        6'd28: begin LEDR <= 18'b000000000111111111; state_ledr <= 6'd29; end
        6'd29: begin LEDR <= 18'b000000001111111111; state_ledr <= 6'd30; end
        6'd30: begin LEDR <= 18'b000000011111111111; state_ledr <= 6'd31; end
        6'd31: begin LEDR <= 18'b000000111111111111; state_ledr <= 6'd32; end
        6'd32: begin LEDR <= 18'b000001111111111111; state_ledr <= 6'd33; end
        6'd33: begin LEDR <= 18'b000011111111111111; state_ledr <= 6'd34; end
        6'd34: begin LEDR <= 18'b000111111111111111; state_ledr <= 6'd35; end
        6'd35: begin LEDR <= 18'b001111111111111111; state_ledr <= 6'd36; end
        6'd36: begin LEDR <= 18'b011111111111111111; state_ledr <= 6'd37; end
        6'd37: begin LEDR <= 18'b111111111111111111; state_ledr <= 6'd0;  end
        
        default: begin LEDR <= 18'b0; state_ledr <= 6'd0; end
    endcase
end

// ========================
// FSM 3: ĐIỀU KHIỂN LEDG (8 LEDs Sáng đuổi L->R, rồi R->L)
// Viết tường minh từng trạng thái (Không gộp logic)
// ========================
always @(posedge clock_ledg) begin
    case (state_ledg)
        // Giai đoạn 1: Sáng đuổi từ trái sang phải
        5'd0:  begin LEDG <= 8'b10000000; state_ledg <= 5'd1;  end
        5'd1:  begin LEDG <= 8'b01000000; state_ledg <= 5'd2;  end
        5'd2:  begin LEDG <= 8'b00100000; state_ledg <= 5'd3;  end
        5'd3:  begin LEDG <= 8'b00010000; state_ledg <= 5'd4;  end
        5'd4:  begin LEDG <= 8'b00001000; state_ledg <= 5'd5;  end
        5'd5:  begin LEDG <= 8'b00000100; state_ledg <= 5'd6;  end
        5'd6:  begin LEDG <= 8'b00000010; state_ledg <= 5'd7;  end
        5'd7:  begin LEDG <= 8'b00000001; state_ledg <= 5'd8;  end
        
        // Giai đoạn 2: Sáng đuổi từ phải sang trái
        5'd8:  begin LEDG <= 8'b00000010; state_ledg <= 5'd9;  end
        5'd9:  begin LEDG <= 8'b00000100; state_ledg <= 5'd10; end
        5'd10: begin LEDG <= 8'b00001000; state_ledg <= 5'd11; end
        5'd11: begin LEDG <= 8'b00010000; state_ledg <= 5'd12; end
        5'd12: begin LEDG <= 8'b00100000; state_ledg <= 5'd13; end
        5'd13: begin LEDG <= 8'b01000000; state_ledg <= 5'd0;  end

        default: begin LEDG <= 8'b0; state_ledg <= 5'd0; end
    endcase
end


// ========================
// Máy trạng thái điều khiển LCD (Giữ nguyên form nạp data)
// ========================
always @(posedge CLOCK_50) begin
    blink_prev <= blink_en; 

    // --- PHASE 1: Khởi tạo và in nội dung ---
    if (state < 6'h28) begin
        case (index)
            3'h0: begin
                case (state)
                    // Khởi tạo LCD
                    6'h00: data <= 9'h030;
                    6'h01: data <= 9'h030;
                    6'h02: data <= 9'h030;
                    6'h03: data <= 9'h038;
                    6'h04: data <= 9'h00C; // Bật màn hình
                    6'h05: data <= 9'h001; 
                    6'h06: data <= 9'h006;
                    6'h07: data <= 9'h080;
                    
                    // Dòng 1: "Nguyen Manh Thang"
                    6'h08: data <= 9'h14E; //'N'
                    6'h09: data <= 9'h167; //'g'
                    6'h0a: data <= 9'h175; //'u'
                    6'h0b: data <= 9'h179; //'y'
                    6'h0c: data <= 9'h165; //'e'
                    6'h0d: data <= 9'h16E; //'n'
                    6'h0e: data <= 9'h120; //' '
                    6'h0f: data <= 9'h14D; //'M' 
                    6'h10: data <= 9'h161; //'a'
                    6'h11: data <= 9'h16E; //'n'
                    6'h12: data <= 9'h168; //'h'
                    6'h13: data <= 9'h120; //' '
                    6'h14: data <= 9'h154; //'T'
                    6'h15: data <= 9'h168; //'h'
                    6'h16: data <= 9'h161; //'a'
                    6'h17: data <= 9'h16E; //'n'
                    6'h18: data <= 9'h167; //'g'

                    // Chuyển xuống Dòng 2
                    6'h19: data <= 9'h0C0;

                    // Dòng 2: "MSSV: 23673811"
                    6'h1a: data <= 9'h14D; //'M'
                    6'h1b: data <= 9'h153; //'S'
                    6'h1c: data <= 9'h153; //'S'
                    6'h1d: data <= 9'h156; //'V'
                    6'h1e: data <= 9'h13A; //':'
                    6'h1f: data <= 9'h120; //' '
                    6'h20: data <= 9'h132; //'2'
                    6'h21: data <= 9'h133; //'3'
                    6'h22: data <= 9'h136; //'6'
                    6'h23: data <= 9'h137; //'7'
                    6'h24: data <= 9'h133; //'3'
                    6'h25: data <= 9'h138; //'8'
                    6'h26: data <= 9'h131; //'1'
                    6'h27: data <= 9'h131; //'1'
                    
                    default: data <= 9'h000;
                endcase

                if (count_lcd == countend) begin
                    flag  <= 1'b0;
                    index <= index + 1'b1;
                end
            end

            3'h1: begin
                en       <= 1'b1;
                flag     <= 1'b1;
                countend <= 20'h10;
                index    <= index + 1'b1;
            end

            3'h2: begin
                if (count_lcd == countend) begin
                    en       <= 1'b0;
                    flag     <= 1'b1;
                    countend <= 20'h40000;
                    state    <= state + 1'b1; 
                    index    <= 3'b0;
                end
            end

            default: index <= 3'b0;
        endcase
    end
    // --- PHASE 2: Hoàn tất in, chuyển sang chế độ Blink ---
    else begin
        if (blink_en != blink_prev) begin
            data     <= blink_en ? 9'h00C : 9'h008;
            index    <= 3'h1;  
            flag     <= 1'b1;
            countend <= 20'h10;
        end
        else begin
            case (index)
                3'h1: begin
                    en    <= 1'b1;
                    index <= 3'h2;
                end
                3'h2: begin
                    if (count_lcd == countend) begin
                        en       <= 1'b0;
                        flag     <= 1'b1;
                        countend <= 20'h40000;
                        index    <= 3'h0; 
                    end
                end
                default: ; 
            endcase
        end
    end
end

endmodule

// ========================
// MODULE GIẢI MÃ LED 7 ĐOẠN 
// (Đã cập nhật để dùng char_code 4 bit, hiển thị số 8 và trạng thái OFF)
// ========================
module decoder_so(
    input  [3:0] char_code,
    output reg [6:0] seg
);
    always @(*) begin
        case(char_code)
            4'd0: seg = 7'b1111001; // 1
            4'd1: seg = 7'b0100100; // 2
            4'd2: seg = 7'b0110000; // 3
            4'd3: seg = 7'b0011001; // 4
            4'd4: seg = 7'b0010010; // 5
            4'd5: seg = 7'b0000010; // 6
            4'd6: seg = 7'b1111000; // 7
            4'd7: seg = 7'b0000000; // 8
            4'd8: seg = 7'b1111111; // OFF
            default: seg = 7'b1111111; 
        endcase
    end
endmodule