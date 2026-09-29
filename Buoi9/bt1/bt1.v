module bt1(SW,LEDR, KEY);
input [11:0]SW;
input [3:0] KEY;
output reg [2:0]LEDR;

parameter s0 =3'b000;
parameter s1 =3'b001;
parameter s2 =3'b010;
parameter s3 =3'b011;
parameter s4 =3'b100;

reg [2:0]current_state,next_state;


always @(*)
begin
case(current_state)
s0: if (SW[2]) next_state =s1;
else next_state=current_state;
s1: if (SW[2]) next_state=current_state;
else next_state = s2;
s2: if (SW[2]) next_state=s3;
else next_state=s0;
s3: if (SW[2]) next_state=s1;
else next_state = s4;
s4: if (SW[2]) next_state=s3;
else next_state=s0;
default next_state=s0;
endcase
end
always@(negedge KEY[3] or negedge SW[11])
begin
if (~SW[11]) current_state<=s0;
else current_state <= next_state;
end
always@(*)
begin
if(current_state==s4) LEDR[2] =1'b1;
else LEDR[2]=1'b0;
end
endmodule