`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-20 10:19
// Design Name: 
// Module Name: watch_data_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 数字时钟数据逻辑的产生
// 
// Dependencies: 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module watch_data_gen #(
    parameter CLK_FRE = 26'd50_000_000
)
(
	input clk,
	input rstn,
	input [2:0]key,
	output reg [3:0]hour_h_o,
	output reg [3:0]hour_l_o,
	output reg [3:0]minutes_h_o,
	output reg [3:0]minutes_l_o,
	output reg second_led,
	output reg [2:0]state_flag
);

/*===================================================
					基准的产生
===================================================*/
// 1s= 20ns * 50000000;
reg [25:0]second_cnt;
always @(posedge clk)
begin
	if(second_cnt==CLK_FRE-1'b1)
		second_cnt <= `UD 26'd0;
	else 
		second_cnt <= `UD second_cnt + 1'b1;
end 
//每个1s闪烁一次
always @(posedge clk)
begin
	if(!rstn)
		second_led <= `UD 1'b0;
	if(second_cnt==(CLK_FRE>>1)-1'b1)
		second_led <= `UD 1'b1;
	else if(second_cnt==CLK_FRE-1'b1)
		second_led <= `UD 1'b0;
end 

reg [3:0]minutes_h;
reg [3:0]minutes_l;
reg [3:0]hour_h;
reg [3:0]hour_l;

reg [3:0]minutes_l_fix=0;
reg [3:0]minutes_h_fix=0;
reg [3:0]hour_l_fix=0;
reg [3:0]hour_h_fix=0;
/*===================================================
				校准逻辑产生	
===================================================*/
wire [2:0]key_out;

btn_deb #(
   .BT_WIDTH(4'd3),
   .CLK_FRE (CLK_FRE)
)
u_btn_deb
(
    .clk	(clk),
    .btn_in (key),                              
    .btn_out(key_out)
);
/*===================================================
	//key[0] -> k1 ;用于校准标记
	key_cnt = 3'd0用于正常显示；
	key_cnt = 3'd1用于分钟低位校准；
	key_cnt = 3'd2用于分钟高位校准；
	key_cnt = 3'd3用于时钟低位校准；
	key_cnt = 3'd4用于时钟高位校准；
===================================================*/
reg [2:0]key_out_reg=3'd0;
always @(posedge clk)
begin
	key_out_reg <= `UD key_out;
end 

reg [2:0]key_cnt=3'd0;
always @(posedge clk)
begin
	if(key_cnt==3'd4 && (!key_out[0] && key_out_reg[0]))
		key_cnt <= `UD 3'd0;
	else if(!key_out[0] && key_out_reg[0])
		key_cnt <= `UD key_cnt + 1'b1;
end 
/*===================================================
			key[1] 用于"+"；key[2] 用"-"
===================================================*/
always @(posedge clk)
begin
	if(key_cnt==3'd0)//校准前将分钟低位和输出值保持一致
		minutes_l_fix <= `UD minutes_l;
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd1 && minutes_l_fix == 4'd9)//当处于分钟校准状态时，按下"+"按键,且此时校准值已经为9时，再按下按键，则校准值变为0
		minutes_l_fix <= `UD 4'd0;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd1 && minutes_l_fix == 4'd0)//当处于分钟校准状态时，按下"-"按键,且此时校准值已经为0时，再按下按键，则校准值变为9
		minutes_l_fix <= `UD 4'd9;//"-"
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd1)//当处于分钟低位校准状态时，按下"+"按键,校准数值加1；
		minutes_l_fix <= `UD minutes_l_fix + 1'b1;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd1)//当处于分钟低位校准状态时，按下"-"按键,校准数值减1；
		minutes_l_fix <= `UD minutes_l_fix - 1'b1;	//"-"	
end 


always @(posedge clk)
begin
	if(key_cnt!=3'd2)//校准前数据和输出值保持一致
		minutes_h_fix <= `UD minutes_h; 
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd2 && minutes_h_fix == 4'd5)//当处于校准状态时，按下"+"按键,且此时校准值已经为5时，再按下按键，则校准值变为0
		minutes_h_fix <= `UD 4'd0;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd2 && minutes_h_fix == 4'd0)//当处于分钟校准状态时，按下"-"按键,且此时校准值已经为0时，再按下按键，则校准值变为5
		minutes_h_fix <= `UD 4'd5;//"-"	
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd2)//当处于校准状态时，按下"+"按键,按下"+"按键,校准数值加1；
		minutes_h_fix <= `UD minutes_h_fix + 1'b1;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd2)//当处于校准状态时，按下"-"按键,校准数值减1；
		minutes_h_fix <= `UD minutes_h_fix - 1'b1;//"-"
end 


always @(posedge clk)
begin
	if(key_cnt!=3'd3 )//校准前数据赋值为0
		hour_l_fix <= `UD 4'd0;
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd3 && hour_h_o != 4'd2 && hour_l_fix==4'd9)//当处于校准状态时，按下"+"按键,且此时小时的高位不为2且校准值已经为9时，再按下按键，则校准值变为0
		hour_l_fix <= `UD 4'd0;//"+"
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd3 && hour_h_o == 4'd2 && hour_l_fix==4'd3)//当处于校准状态时，按下"+"按键,且此时小时的高位为2且校准值已经为3时，再按下按键，则校准值变为0
		hour_l_fix <= `UD 4'd0;//"+"	
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd3 && hour_h_o != 4'd2 && hour_l_fix==4'd0)//当处于校准状态时，按下"-"按键,且此时小时的高位不为2时，校准位为0，再按下按键，则校准值变为,9
		hour_l_fix <= `UD 4'd9;//"-"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd3 && hour_h_o == 4'd2 && hour_l_fix==4'd0)//当处于校准状态时，按下"-"按键,且此时小时的高位为2时，校准位为0，再按下按键，则校准值变为3
		hour_l_fix <= `UD 4'd3;//"-"			
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd3)//当处于校准状态时，按下"+"按键,按下"+"按键,校准数值加1；
		hour_l_fix <= `UD hour_l_fix + 1'b1;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd3)//当处于校准状态时，按下"-"按键,校准数值减1；
		hour_l_fix <= `UD hour_l_fix - 1'b1;		
end 


always @(posedge clk)
begin
	if(key_cnt!=3'd4)//校准前数据和输出值保持一致
		hour_h_fix <= `UD hour_h;
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd4 && hour_h_fix == 4'd2)//当处于校准状态时，按下"+"按键,且此时小时的高位为2，再按下按键，则校准值变为0
		hour_h_fix <= `UD 4'd0;//"+"
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd4 && hour_h_fix == 4'd0)//当处于校准状态时，按下"-"按键,且此时小时的高位为0，再按下按键，则校准值变为2
		hour_h_fix <= `UD 4'd2;//"-"
	else if(!key_out[1] && key_out_reg[1] && key_cnt==3'd4 )//当处于校准状态时，按下"+"按键,按下"+"按键,校准数值加1；
		hour_h_fix <= `UD hour_h_fix + 1'b1;//"+"	
	else if(!key_out[2] && key_out_reg[2] && key_cnt==3'd4)//当处于校准状态时，按下"-"按键,校准数值减1；
		hour_h_fix <= `UD hour_h_fix - 1'b1;//"-"			
end 
/*===================================================
					秒钟的产生:中间值
===================================================*/
//秒钟计60次（0~59）为1分钟
reg [5:0]second_flag=0;
always @(posedge clk)
begin
	if(second_cnt==CLK_FRE-1'b1 && second_flag==6'd59)
		second_flag <=`UD 6'd0;
	else if(second_cnt==CLK_FRE-1'b1)
		second_flag <=`UD second_flag + 1'b1;
end 
/*===================================================
					分钟的产生:中间值
===================================================*/
//minutes_l gen 
always @(posedge clk)
begin
	if(!rstn)//初始值为0
		minutes_l <= `UD 4'd0;
	else if(key_cnt==3'd1)//校准时，分钟低位为校准值
		minutes_l <= `UD minutes_l_fix;
	else if(second_cnt==CLK_FRE-1'b1 && second_flag==6'd59 && minutes_l==4'd9)//9分59秒产生进位，低位赋值为0
		minutes_l <= `UD 4'd0;	
	else if(second_cnt==CLK_FRE-1'b1 && second_flag==6'd59)//60秒产生分钟的低位进位
		minutes_l <= `UD minutes_l +1'b1;		
end 
//minutes_h gen 
always @(posedge clk)
begin
	if(!rstn)
		minutes_h <= `UD 4'd0;
	else if(key_cnt==3'd2)
		minutes_h <= `UD minutes_h_fix;
	else if(second_cnt==CLK_FRE-1'b1 && second_flag==6'd59 && minutes_h==4'd5  && minutes_l==4'd9)//当为59分59秒的时候产生进位，分钟的高位赋值为0；
		minutes_h <= `UD 4'd0;
	else if(second_cnt==CLK_FRE-1'b1 && second_flag==6'd59 && minutes_l==4'd9 )//9分59秒的时候产生进位；
		minutes_h <= `UD minutes_h +1'b1;		
end 
/*===================================================
					小时的产生:中间值
===================================================*/
always @(posedge clk)
begin
	if(!rstn)
		hour_l <= `UD 4'd0;
	else if(key_cnt==3'd3)
		hour_l <= `UD hour_l_fix;
	else if(hour_h!=4'd2 && hour_l==4'd9 && second_cnt==CLK_FRE-1'b1 && second_flag==6'd59 && minutes_h==4'd5 && minutes_l==4'd9 )//9:59:59或者19:59:59，下一秒hour_l为0；
		hour_l <= `UD 4'd0;
	else if(hour_h==4'd2 && hour_l==4'd3 && second_cnt==CLK_FRE-1'b1 && second_flag==6'd59  && minutes_h==4'd5 && minutes_l==4'd9 )//23:59:59;hour_l为0；
		hour_l <= `UD 4'd0;			
	else if(second_cnt==CLK_FRE-1'b1 && minutes_h==4'd5 && minutes_l==4'd9 && second_flag==6'd59)//XX:59:59;hour_l加1；
		hour_l <= `UD hour_l +1'b1;			
end 

always @(posedge clk)
begin
	if(!rstn)
		hour_h <= `UD 4'd0;
	else if(key_cnt==3'd4)
		hour_h <= `UD hour_h_fix;
	else if(hour_h==4'd2 && hour_l==4'd3 && second_cnt==CLK_FRE-1'b1 && minutes_h==4'd5 && minutes_l==4'd9 && second_flag==6'd59)//当时间刻度为：23:59:59 ,hour_h 为0
		hour_h <= `UD 4'd0;
	else if(hour_l==4'd9 && second_cnt==CLK_FRE-1'b1 && minutes_h==4'd5 && minutes_l==4'd9 && second_flag==6'd59)//当时间刻度为：09:59:59 or 19:59:59,hour_h 加1
		hour_h <= `UD hour_h + 1'b1;		
end 

/*===================================================
				output 
===================================================*/
/*===================================================
	//key[0] -> k1 ;用于校准标记
	key_cnt = 3'd0用于正常显示；
	key_cnt = 3'd1用于分钟低位校准；
	key_cnt = 3'd2用于分钟高位校准；
	key_cnt = 3'd3用于时钟低位校准；
	key_cnt = 3'd4用于时钟高位校准；
===================================================*/
always @(posedge clk)
begin
	minutes_l_o <=`UD minutes_l;		
end 

always @(posedge clk)
begin
	minutes_h_o <=`UD minutes_h;		
end 

always @(posedge clk)
begin
	hour_l_o <=`UD hour_l;		
end 

always @(posedge clk)
begin
	hour_h_o <=`UD hour_h;		
end 

always @(posedge clk)
begin
	state_flag <= `UD key_cnt;
end 

endmodule