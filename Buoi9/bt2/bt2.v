module bt2 (SW, LEDR, KEY);
    parameter start = 3'd0;
    parameter s0    = 3'd1;
    parameter s00   = 3'd2;
    parameter s001  = 3'd3;
    parameter s1    = 3'd4;
    parameter s11   = 3'd5;
    parameter s110  = 3'd6;

    input [2:1] SW;   // SW[1]: Reset, SW[2]: Data Input
    input [2:2] KEY;  // KEY[2]: Clock (cạnh xuống)
    output reg [1:0] LEDR;
    reg [2:0] current_state, next_state;
    always @ (*) begin
        case(current_state)
            start: if(SW[2]) next_state = s1;
                   else next_state = s0;
            s0:    if(SW[2]) next_state = s1;
                   else next_state = s00;
            s00:   if(SW[2]) next_state = s001;
                   else next_state = s00;
            s001:  if(SW[2]) next_state = s1;
                   else next_state = s0;
            s1:    if(SW[2]) next_state = s11;
                   else next_state = s0;
            s11:   if(SW[2]) next_state = s11;
                   else next_state = s110;
            s110:  if(SW[2]) next_state = s1;
                   else next_state = s0;
            default: next_state = start;
        endcase
    end 
    always @ (negedge KEY[2]) begin
        if (SW[1]) 
            current_state <= start;
        else 
            current_state <= next_state;
    end

    always @ (*) begin
        if (current_state == s001) 
            LEDR[0] = 1'b1;  
        else 
            LEDR[0] = 1'b0;
    end
    always @ (*) begin
        if (current_state == s110) 
            LEDR[1] = 1'b1;  
        else 
            LEDR[1] = 1'b0;
    end

endmodule