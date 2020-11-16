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
module key_control
(
	input clk,
	input key_8,
	input [2:0]key_in,
	output reg key8_led,
	output reg [2:0]key_in_led,
	output reg [2:0]seq_data
);

/*===================================================
					按键消斗
===================================================*/
wire [2:0]key_out;
btn_deb 
#(
   .BT_WIDTH(4'd3)
)
u_btn_deb_key1
(
    .clk(clk),
    .btn_in(key_in),
    .btn_out(key_out)
);

btn_deb 
#(
   .BT_WIDTH(4'd1)
)
u_btn_deb_key8
(
    .clk(clk),
    .btn_in(key_8),
    .btn_out(key_8_out)
);

/*===================================================
					
===================================================*/

reg [2:0]key_out_reg;
reg key_8_out_reg;

always @(posedge clk)
begin
	key_out_reg <= `UD key_out;
	key_8_out_reg<= `UD key_8_out;
end 

reg key_8_flag=0;
always @(posedge clk)
begin
	if(!key_8_out && key_8_out_reg)
		key_8_flag <= `UD ~key_8_flag;
	else
		key_8_flag <= `UD key_8_flag;
end 

always @(posedge clk)
begin
	key8_led <= `UD key_8_flag;
end

reg [2:0]key_flag=3'b000;
always @(posedge clk)
begin
	if(key_8_flag==1'b0)
		key_flag[0] <= `UD 1'b0;
	else if(!key_out[0] && key_out_reg[0])
		key_flag[0] <= `UD ~key_flag[0];
	else 
		key_flag[0] <= `UD key_flag[0];
end 

always @(posedge clk)
begin
	if(key_8_flag==1'b0)
		key_flag[1] <= `UD 1'b0;
	else if(!key_out[1] && key_out_reg[1])
		key_flag[1] <= `UD ~key_flag[1];
	else 
		key_flag[1] <= `UD key_flag[1];
end 

always @(posedge clk)
begin
	if(key_8_flag==1'b0)
		key_flag[2] <= `UD 1'b0;
	else if(!key_out[2] && key_out_reg[2])
		key_flag[2] <= `UD ~key_flag[2];
	else 
		key_flag[2] <= `UD key_flag[2];
end 
always @(posedge clk)
begin
	key_in_led <= `UD key_flag;
end

//seq_data
always @(posedge clk)
begin
	if(key_8_flag)
		seq_data <= `UD key_in_led;
end

endmodule