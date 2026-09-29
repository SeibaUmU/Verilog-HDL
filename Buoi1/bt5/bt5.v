/*module bt5(SW,LEDR);
input [3:0]SW;
output reg [1:0]LEDR;
//assign LEDR[1] = (~SW[3] & ~SW[2] &  SW[1] &  SW[0]) | ( SW[3] & ~SW[2] & ~SW[1] &  SW[0]) | ( SW[3] &  SW[2] &  SW[1] &  SW[0]);  
	always @(SW)
begin
	case(SW)
		4'd3, 4'd9, 4'd15: LEDR[1] = 1'b1;
	default:
		LEDR[1] = 0; 
	endcase
end
endmodule */

module bt5 (
    input  [3:0] SW,   
    output [1:0] LEDR
);
    wire notA, notB, notC;
    wire t1, t2, t3;

    not (notA, SW[3]);
    not (notB, SW[2]);
    not (notC, SW[1]);

    and (t1, notA, notB, SW[1], SW[0]);
    and (t2, SW[3], notB, notC, SW[0]);
    and (t3, SW[3], SW[2], SW[1], SW[0]);
    or (LEDR[1], t1, t2, t3);

    assign LEDR[0] = 1'b0;
 endmodule 
