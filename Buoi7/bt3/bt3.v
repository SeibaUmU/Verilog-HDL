module bt3(
    input        CLOCK_50,
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
    parameter H     = 7'b0001001; 
    parameter A     = 7'b0001000;
    parameter P     = 7'b0001100;
    parameter Y     = 7'b0010001;
    parameter BLANK = 7'b1111111;

    wire light_status; 
    counter bo_dem_10s_5s (CLOCK_50,light_status);
	 
    assign HEX4 = (light_status) ? H : BLANK;
    assign HEX3 = (light_status) ? A : BLANK;
    assign HEX2 = (light_status) ? P : BLANK;
    assign HEX1 = (light_status) ? P : BLANK;
    assign HEX0 = (light_status) ? Y : BLANK;
    assign HEX7 = BLANK; assign HEX6 = BLANK; assign HEX5 = BLANK;

endmodule

module counter(
    input ck,
    output reg clock_riel // mac dinh sang (ON)
);
    integer q = 0;

    always @(posedge ck)
    begin
		  if (q < 500000000) begin //sang 10s
            clock_riel <= 1'b1;
            q <= q + 1;
        end
        else if (q < 750000000) begin //tat 5s
            clock_riel <= 1'b0;
            q <= q + 1;
        end
        else begin
            //reset ve 0
            q <= 0;
            clock_riel <= 1'b1;
        end
    end
endmodule