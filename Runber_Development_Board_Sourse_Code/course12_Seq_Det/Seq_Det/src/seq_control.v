`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 19:46
// Design Name: 
// Module Name: seq_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 分频得到100khz的时钟，即10ms
// 
// Dependencies: 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module seq_control
(
	input [1:0]sel,
	input [3:0]key,
	output reg [3:0]dig,
	output reg [7:0]smg
);
/*===================================================
					位选择映射
===================================================*/
always @(*)
begin
	case(sel)
		2'd0:dig = 4'b1110;
		2'd1:dig = 4'b1101;
		2'd2:dig = 4'b1011;
		2'd3:dig = 4'b0111;
		default:dig = 4'b1111;
	endcase
end
//===========================================
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
//===========================================
always @(*)
begin
	case(key)
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
		default:smg = 8'b1111_1111;		
	endcase
end 



endmodule