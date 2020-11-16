`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/20 16:36:20
// Design Name: 
// Module Name: cnt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 回响信号为高电平期间进行计时，将距离用数码管显示出来
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module cnt (
   	input  clk,
    input  rstn,
    inout  sig,
    output reg [3:0]count_one,
    output reg [3:0]count_ten,
    output reg [3:0]count_hundred,
    output reg [3:0]count_thousand
);

/*`define SIM_MODE
`ifdef SIM_MODE

		    parameter  TRIG_L =12'd24;//2us关闭,12*2
        parameter  TRIG_H =12'd60;//trig持续5us计时,12*5
        parameter  PERIOD =24'd800;//间隔1s测量一次  
		    parameter  COUNT_CM =13'd30;

`else*/
    	  parameter  TRIG_L =12'd24;//2us关闭,12*2
        parameter  TRIG_H =12'd60;//trig持续5us计时,12*5
        parameter  PERIOD =24'd12000000;//间隔1s测量一次  
	    	parameter  COUNT_CM =32'd695;//计满696个clk距离加一
//`endif



/*
	假如速度为340m/s，距离的公式为：us/58（厘米），时钟频率为：12MHz，
    每1厘米的距离所用的时间为12*58=696个clk周期
*/

/*===================================================
		各状态周期计时，通过不同的时间点控制当前的状态
        输出2us低电平、输出5us高电平、输入高电平计时
===================================================*/
reg[23:0] count_period =24'b0;

always @ (posedge clk)
     begin 
          if(!rstn||(count_period==(TRIG_L+TRIG_H+PERIOD)))
            count_period<=`UD 24'b0;
          else
            count_period<=`UD count_period+1'd1;
     end
/*===================================================
					2us低电平+5us高电平的TRIG信号
===================================================*/
reg trig;//输出触发信号标志
always @ (posedge clk)
     begin 
          if(!rstn)
            trig <=`UD 1'd1;
          else if(count_period<=(TRIG_L+TRIG_H))
            trig <=`UD 1'd1;
          else
            trig <=`UD 1'd0;
     end
reg sig_out;//输出触发信号的2us低电平+5us高电平
always @ (posedge clk)
      begin 
           if(!rstn)
            sig_out <=`UD 1'd0;
          else if((count_period>TRIG_L)&&(count_period<=(TRIG_L+TRIG_H)))
            sig_out <=`UD 1'd1;
          else
            sig_out <=`UD 1'd0;
     end
    assign sig = (trig==1'b0) ? 1'bz : sig_out;//trig等于0时为输入状态，等于1时为输出状态

reg in;//输入状态时，输入信号打一拍，inout的输入信号用reg型缓冲
always @ (posedge clk)
       begin
           if(!trig)
             in <= `UD sig;//打一拍
           else
             in <= `UD 1'b0;
       end
           
/*===================================================
					去毛刺
===================================================*/ 

 reg [17:0]low_cnt=18'b0;  //200us == 12*200 = 2400;
    always @ (posedge clk)
    begin
        if(trig == 1'b0)
        begin
            if(~in)
            begin
                if(low_cnt == 18'd2400)
                    low_cnt <= `UD low_cnt;
                else
                    low_cnt <= `UD low_cnt + 18'b1;//in为0时开始计数，in为1时清零
            end
            else
                low_cnt <= `UD 18'b0;
        end
        else
            low_cnt <= `UD 18'b0;
    end

    reg flag=1'b0;//输入高电平信号有效标志，
    always @ (posedge clk)
    begin
        if(!rstn||trig==1'b1)
            flag <= `UD 1'b0;
        else if(low_cnt == 18'd1200)     //低电平持续1200clk时有效标志为1
            flag <= `UD ~flag;            
        else
            flag <= `UD flag;
    end

reg [12:0] count_echo=13'd0;
always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_echo==COUNT_CM||!flag)
            count_echo <= `UD 13'd0;
          // if((in_reg == 1'b0 && in))
            //    count_echo <= `UD 32'd0;
          else if((trig==0)&&(in==1'b1)&&(count_echo<COUNT_CM)&&flag)//1cm计时
          
            count_echo <= `UD count_echo+1'd1;
                 
          else
            count_echo <= `UD count_echo;
     end     
always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_one==4'd10) 
            count_one<= `UD 1'd0;
          else if((count_echo==COUNT_CM)&&(count_one<=4'd9))//个位
            count_one<= `UD count_one+1'd1;
          else
            count_one<= `UD count_one;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_ten==4'd10) 
            count_ten<= `UD 1'd0;
          else if((count_one==4'd10)&&(count_ten<=4'd9))//十位
            count_ten<= `UD count_ten+1'd1;      
          else
            count_ten<= `UD count_ten;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_hundred==4'd10) 
            count_hundred<= `UD 1'd0;
          else if((count_ten==4'd10)&&(count_hundred<=4'd9))//百位
            count_hundred<= `UD count_hundred+1'd1;
          else
            count_hundred<= `UD count_hundred;
     end

always @ (posedge clk)
     begin
          if(!rstn||trig==1'b1||count_thousand==4'd10) 
            count_thousand<= `UD 1'd0;
          else if((count_hundred==4'd10)&&(count_thousand<=4'd9))//千位
            count_thousand<= `UD count_thousand+1'd1;
          else
            count_thousand<= `UD count_thousand;
     end
endmodule
