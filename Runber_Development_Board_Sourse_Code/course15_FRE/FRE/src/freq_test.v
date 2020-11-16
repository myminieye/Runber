`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 19:36
// Design Name: 
// Module Name: top_freq
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 频率测量顶层模块
// 
// Dependencies: 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module freq_test
(
	input             clk,
	input  [3:0]      key_times,
	output reg [3:0]  seg0,
	output reg [3:0]  seg1,
	output reg [3:0]  seg2,
	output reg [3:0]  seg3	
);
parameter CLK_FRE = 26'd12_000_000;
/*===================================================
				16个测量时钟的产生
===================================================*/
reg [23:0] clk_gen;
always @(posedge clk)
begin
	clk_gen <=`UD clk_gen + 1'b1;
end 

wire  freq_gen;
assign  freq_gen = clk_gen[23-key_times];
/*===================================================
					1s基准产生
===================================================*/
// 20*50000000=1s hex= 2faf080
wire clk_1hz;
reg [28:0] times_cnt=0;
always @(posedge clk)
begin
	if(times_cnt== CLK_FRE-1'b1)
		times_cnt <= `UD 29'd0;
	else 		
		times_cnt <= `UD times_cnt + 1'b1;
end 

reg flag=0;
always @(posedge clk)
begin
	if(times_cnt==CLK_FRE/2 - 1'b1)
		flag <= `UD 1'b1;
	else if(times_cnt== CLK_FRE-1'b1)
		flag <= `UD 1'b0;		
end 
assign clk_1hz = flag;
/*===================================================	
					1s测量，3秒显示标记
===================================================*/
reg test_flag;
reg [1:0]flag_cnt=2'd0;
always @(posedge clk_1hz) 
begin
	flag_cnt <=`UD flag_cnt + 1'b1;
end 

always @(*)
begin
	if(flag_cnt==2'd0)
		test_flag = 1'b1;
	else 
		test_flag = 1'b0;
end 

reg test_flag_reg;

always @(posedge clk)
begin
	test_flag_reg <=`UD test_flag;
end 

wire test_start;
assign test_start = test_flag && test_flag_reg==1'b0;

reg freq_gen_reg;
always @(posedge clk)
begin
	freq_gen_reg <= `UD freq_gen;
end 

wire freq_risedge;
assign freq_risedge = !freq_gen_reg && freq_gen;
/*===================================================					
			output reg [3:0]seg0,
			output reg [3:0]seg1,
			output reg [3:0]seg2,
			output reg [3:0]seg3	
===================================================*/
//assign data_in=FRE[13:0];
//assign qian=data_in/1000;
//assign bai=data_in/100%10;
//assign shi=data_in/10%10;
//assign ge=data_in%10;

wire seg0_carry;
wire seg1_carry;
wire seg2_carry;
wire seg3_carry;
//test_flag是一个脉冲为1s的测试使能信号，freq_risedge为待测试信号上升沿
assign seg0_carry = (seg0 == 4'd9) && freq_risedge && test_flag;
assign seg1_carry = (seg1 == 4'd9) && seg0_carry;
assign seg2_carry = (seg2 == 4'd9) && seg1_carry;
assign seg3_carry = (seg3 == 4'd9) && seg2_carry;

always @(posedge clk)     //频率的个位
begin
	if(seg3_carry)        //当我们测量达到最大值时，将赋值为9
		seg0 <= `UD 4'd9;
	else if(seg0_carry)   //溢出
		seg0 <= `UD 4'd0;
	else if(freq_risedge && test_flag)//
		seg0 <= `UD seg0 + 1'b1;
	else if(test_start)    //每次测量前将数码管赋值为0
		seg0 <= `UD 4'd0;
end 


always @(posedge clk)   //频率的十位
begin
	if(seg3_carry)      //当我们测量达到最大值时，将赋值为9
		seg1 <= `UD 4'd9;
	else if(seg1_carry) //当前位计数到9，溢出处理
		seg1 <= `UD 4'd0;
	else if(seg0_carry) //低位进位信号触发当前位计数加1
		seg1 <= `UD seg1 + 1'b1;
	else if(test_start)//每次测量前将数码管赋值为0
		seg1 <= `UD 4'd0;
end 

always @(posedge clk)//频率的百位
begin
	if(seg3_carry)//当我们测量达到最大值时，将赋值为9
		seg2 <= `UD 4'd9;
	else if(seg3_carry)
		seg2 <= `UD 4'd0;
	else if(seg1_carry)
		seg2 <= `UD seg2 + 1'b1;
	else if(test_start)//每次测量前将数码管赋值为0
		seg2 <= `UD 4'd0;
end 

always @(posedge clk)//频率的千位
begin
	if(seg3_carry)//当我们测量达到最大值时，将赋值为9
		seg3 <= `UD 4'd9;
	else if(seg3_carry)
		seg3 <= `UD 4'd9;
	else if(seg2_carry)
		seg3 <= `UD seg3 + 1'b1;
	else if(test_start)//每次测量前将数码管赋值为0
		seg3 <= `UD 4'd0;
end 

endmodule