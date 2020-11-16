`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:myminieye
// Engineer: 
// 
// Create Date: 2020/08/11 19:42:00
// Design Name: 
// Module Name: dht
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 实现与温湿度传感器模块的通信，按下按键1秒后输出18ms低电平触发信号通知传感器传输数据，根据所接收到的信号高电平持续时间的长短判断信号的类型，
// 高电平持续时间：80us（应答信号）、26~28us（数据“0”）、70us（数据“1”），接收40个数据后校验通过的前32位有效数据为最终湿度和温度的结果
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module dht(
            input clk,
            input rstn,
            inout in_out,
			output reg [31:0]information=32'd0//温湿度数据
    );
	
/*=================================================
                                  
            inout引脚的输入输出控制
     
==================================================*/
parameter DELAY = 24'd12000000;//按键按下后延迟1s
parameter OUT = 24'd216000;//输出18ms低电平触发信号，18*12*1000=216000

reg [23:0]count_ctl=24'd0;//输出信号计时

always @ (posedge clk)//1s+18ms计时
       begin
            if(!rstn)
               count_ctl <= `UD 24'd0;
            else if(count_ctl < DELAY + OUT)
               count_ctl <= `UD count_ctl + 24'b1;
            else
               count_ctl <= `UD count_ctl;     
       end
    
reg control=1'b0;    
always @ (posedge clk)//输入输出信号控制信号
       begin
            if(!rstn)
               control <=`UD 1'b0;//输出条件
            else if(count_ctl==OUT + DELAY)//输出1s高电平+18ms低电平后再转为输入状态
               control <=`UD 1'b1;//输入条件
            else
              control <= `UD control;       
       end

reg out_reg=1'b0;    
always @ (posedge clk)//输出信号
       begin
            if(!rstn)
               out_reg <=`UD 1'b1;//按键按下后先输出1s的高电平
            else if(count_ctl==DELAY)//按键按下1s后再输出18ms低电平触发信号
               out_reg <= `UD 1'b0;
            else if(count_ctl==OUT + DELAY)
               out_reg <=`UD 1'b1;
            else
              out_reg <= `UD out_reg;       
       end    
                                                 
assign in_out = (control == 1'b0)? out_reg:1'bz;
//inout的输入输出控制，前1s输出高电平，然后再输出18ms低电平触发信号，输入时为高阻态Z，control为的“0”	
//1s+18ms后control为“1”，此时设为高阻态输入状态
                                      
/*===================================================

              输入状态时，计算输入高电平的时间

====================================================*/		                                      
reg in=1'b0;
always @ (posedge clk)
       begin
            if(control)
		      in <= `UD in_out;//inout为输入时使用reg缓冲
            else
              in <=`UD 1'b0;
       end
reg [11:0]cnt=12'b0;//输入信号高电平计数，
reg [11:0]cnt1=12'b0;//打一拍
reg [11:0]cnt2=12'b0;//再打一拍
always @ (posedge clk)//输入信号为高电平时开始计时，低电平计时为0
       begin
            if(!rstn)
              cnt <= `UD 12'b0;
            else if(in ==1'b1)
                  cnt <= `UD cnt + 12'b1;
               
            else
              cnt <= `UD 12'b0;         
       end
always @ (posedge clk)//将高电平计时计数器打一拍延迟一个时钟周期赋值给cnt1，用于判断输入信号是否从高电平跳转为低电平
       begin
            cnt1 <= `UD cnt;
       end
always @ (posedge clk)//将高电平计时计数器再打一拍延迟一个时钟周期赋值给cnt2，数据info的赋值条件之一
       begin
            cnt2 <= `UD cnt1;
       end
/*===================================================

           判断信号为ack、“0”、“1”

====================================================*/		
reg data_en=1'b0;//ack应答信号到来后读取信号标志
reg data=1'b0;	//当前数据为“1”或“0”

always @ (posedge clk)
        begin
            if(!rstn)
               data_en <= `UD 1'b0;
            else if(cnt1 > cnt)//输入信号从高电平跳转为低电平标志
               begin
                    if( cnt1>900 )//应答信号高电平80us，80*12=960clk
                      data_en <= `UD 1'b1; 
               end               
			else 
					  data_en <= `UD data_en;
        end  
		
always @ (posedge clk)
        begin
            if(cnt1 > cnt && data_en)//应答信号到来后，输入信号从高电平跳转为低电平
               begin
                    if(cnt1<360)//数据“0”高电平26-28us，（26~28）*12=312~336clk
                      data <= `UD 1'b0;
                    if( cnt1>800)//数据“1”高电平70us，70*12=840clk
                      data <= `UD 1'b1;                     
               end  	
			else 
					  data <= `UD 1'b0;   
        end   
/*===================================================

              将每一位数据逐个赋值到info[40]

====================================================*/		
reg [7:0]data_cnt = 8'd40;//传感器的数据计数
always @ (posedge clk)
        begin
             if(!rstn)
               data_cnt <= `UD 8'd40;
             else if(cnt1 > cnt && data_en)
               data_cnt <= `UD data_cnt - 8'b1;
             else if(data_cnt ==8'd0)//40位数据计满标志
               data_cnt <= `UD data_cnt;
        end
		
reg [39:0]info =40'b0;//传感器信号高位先出，赋值时从低位赋值并逐步往高位移位
always @ (posedge clk)       
      begin
        if(!rstn)
           info <= `UD 40'b0;
        else if(cnt2 > cnt1 && data_en)
           info <= `UD {info[38:0],data};
      end
/*===================================================

         校验位的计算并在校验通过后将数据赋值到输出

====================================================*/				
reg [7:0]check = 8'd0;//校验位等于40bit数据中4个8bit数据之和的低8位
always @ (posedge clk)
        begin
              if(data_cnt ==8'd0)
               check <= `UD info[39:32]+info[31:24]+info[23:16]+info[15:8];
        end
always @ (posedge clk)
      begin
         if(!rstn)
            information[31:0] <= `UD 32'h0;
         else if(data_cnt ==8'd0)
            begin
                if(check[7:0]==info[7:0])
                  information[31:0] <= `UD info[39:8];//校验通过后赋值             
            end 
      end		
endmodule