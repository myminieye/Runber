`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 19:11
// Design Name: 
// Module Name: key_cnt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 按键计数模块
// 
// Dependencies: 
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//		   _______
//        |       |
//--------         -------
//           _______
//          |       |
//----------         -------
//
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module key_cnt
(
	input clk,
	input key,
	output reg [3:0]key_times
);

reg key_reg;
always @(posedge clk)
begin
	key_reg <= `UD key;
end 

always @(posedge clk )
begin
	if(key_reg&&~key&&key_times==4'd15)
		key_times <=`UD 4'd0;
	else if(key_reg&&~key)
		key_times <=`UD key_times + 1'b1;
end 

endmodule
