module mux4_1 (
input [6:1] SW,    // SW[2:1] là S1-0, SW[6:3] là D3-0
output reg [1:0] LEDR     
);

always @(*)
begin
    LEDR[1] = 1'b0;
    case (SW[2:1])      
        2'b00: LEDR[1] = SW[3]; 
        2'b01: LEDR[1] = SW[4]; 
        2'b10: LEDR[1] = SW[5]; 
        2'b11: LEDR[1] = SW[6]; 
        default: LEDR[1] = 1'b0;
    endcase
end

endmodule