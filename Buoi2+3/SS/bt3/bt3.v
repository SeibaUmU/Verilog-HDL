module bt3(LEDR, SW);
	input [9:1] SW;    
	output [3:1] LEDR;
	
    wire e1, e2, e3, e4;
    wire s1, s2, s3, s4;
    wire i1, i2, i3, i4;

    sosanh_1bit bit3(s1, e1, i1, SW[9], SW[5], SW[1]);
    sosanh_1bit bit2(s2, e2, i2, SW[8], SW[4], e1);
    sosanh_1bit bit1(s3, e3, i3, SW[7], SW[3], e2);
    sosanh_1bit bit0(s4, e4, i4, SW[6], SW[2], e3);

    assign LEDR[1] = s1 | s2 | s3 | s4; //A>B
    assign LEDR[2] = i1 | i2 | i3 | i4; //A<B
    assign LEDR[3] = e4;					 //A=B
endmodule

module sosanh_1bit(s, e, i, a, b, g);
	input a, b;
	input g;
	output s, e, i;
	assign s = g & (a & ~b); //A>B
	assign i = g & (~a & b); //A<B
	assign e = g & (a ~^ b); //A=B
endmodule