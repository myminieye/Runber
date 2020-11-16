`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 11:26
// Design Name: 
// Module Name: blue
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 4个数码管显示，0~9，每个1s变化一次
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module top_seq
(
	input clk,//12MHZ 83.33ns
	output [3:0]dig,
	output reg [7:0]smg
);

wire clk_12m;
pll your_instance_name(
        .clkout(clk_12m), //output clkout
        .clkin(clk) //input clkin
    );

wire clk_1hz;
div_clk u_div_clk
(
	.clk(clk_12m),
	.clk_1hz(clk_1hz)
);

reg [3:0]counter=0;
always @(posedge clk_1hz)
begin
	if(counter==4'd9)
		counter <= `UD 4'd0;
	else 
		counter <= `UD counter + 1'b1;
end

assign dig = 4'b0000;

//IO_LOC "smg[0]" 101 -> G;
//IO_LOC "smg[1]" 104 -> F;
//IO_LOC "smg[2]" 97  -> E;
//IO_LOC "smg[3]" 98  -> D;
//IO_LOC "smg[4]" 100 -> C;
//IO_LOC "smg[5]" 102 -> B;
//IO_LOC "smg[6]" 106 -> A;
//IO_LOC "smg[7]" 99  -> P;
//===========================================
// 0 1 2 3 4 5 6 7  
// G F E D C B A P
//共阳极数码管，为0有效，即点亮
// Runber 共阴极数码管 ，为1有效
//===========================================
always @(*)
begin 
	case(counter)
		4'd0:smg = 8'b0111_1110;//"0"  8'b1000_0001
		4'd1:smg = 8'b0011_0000;//"1"  8'b1100_1111
		4'd2:smg = 8'b0110_1101;//"2"  8'b1001_0010
		4'd3:smg = 8'b0111_1001;//"3"  8'b1000_0110
		4'd4:smg = 8'b0011_0011;//"4"  8'b1100_1100
		4'd5:smg = 8'b0101_1011;//"5"  8'b1010_0100
		4'd6:smg = 8'b0101_1111;//"6"  8'b1010_0000
		4'd7:smg = 8'b0111_0000;//"7"  8'b1000_1111
		4'd8:smg = 8'b0111_1111;//"8"  8'b1000_0000
		4'd9:smg = 8'b0111_1011;//"9"  8'b1000_0100
		default:smg = 8'b0111_1110;
	endcase
end 

endmodule
