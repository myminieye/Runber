`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-19 09:10
// Design Name: 
// Module Name: key_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 按键消抖，按键状态检测
// 
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module seq_det
(
	input clk,
	input key8_led,//检测状态标记
	input [2:0]key_in_led,//待检测序列
	input [7:0]bm,//输入序列
	output reg [3:0]data
);

reg [5:0]flag;

always @(posedge clk)
begin
	if(!key8_led&&bm[7:5]==key_in_led)
		flag[0] <= `UD 1'b1;
	else 
		flag[0] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	if(!key8_led&&bm[6:4]==key_in_led)
		flag[1] <= `UD 1'b1;
	else 
		flag[1] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	if(!key8_led&&bm[5:3]==key_in_led)
		flag[2] <= `UD 1'b1;
	else 
		flag[2] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	if(!key8_led&&bm[4:2]==key_in_led)
		flag[3] <= `UD 1'b1;
	else 
		flag[3] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	if(!key8_led&&bm[3:1]==key_in_led)
		flag[4] <= `UD 1'b1;
	else 
		flag[4] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	if(!key8_led&&bm[2:0]==key_in_led)
		flag[5] <= `UD 1'b1;
	else 
		flag[5] <= `UD 1'b0;
end 

always @(posedge clk)
begin
	data <= `UD flag[5] + flag[4] + flag[3] + flag[2] + flag[1] + flag[0]; 
end 

/*
always @(posedge clk)
begin
	if(!key8_led&&bm[7:5]==key_in_led)
		data <= `UD data + 1'b1;
	else if (!key8_led&&bm[6:4]==key_in_led)
		data <= `UD data + 1'b1;
	else if(!key8_led&&bm[5:3]==key_in_led)
		data <= `UD data + 1'b1;
	else if(!key8_led&&bm[4:2]==key_in_led)
		data <= `UD data + 1'b1;	
	else if(!key8_led&&bm[3:1]==key_in_led)
		data <= `UD data + 1'b1;	
	else if(!key8_led&&bm[2:0]==key_in_led)
		data <= `UD data + 1'b1;	
	else if(!key8_led)
		data <= `UD data;			
	else
		data <= `UD 4'd0;
end 
*/

endmodule