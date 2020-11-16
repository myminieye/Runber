`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/12 14:08:13
// Design Name: 
// Module Name: change
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:为使数据在数码管中显示，将8bit的温湿度整数部分和8bit的小数部分共32bit数据按十进制数位分开
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module change(
             input clk,
             input rstn,
             input  [31:0]information,//读取的40位数据中的高32位
             output reg [3:0]humidity_one=0,//湿度
             output reg [3:0]humidity_ten=0,
             output reg [3:0]humidity_decimal,
             output reg [3:0]temp_one=0,//温度
             output reg [3:0]temp_ten=0,
             output reg [3:0]temp_decimal
    );

 reg [7:0]humidity_integer=0;
 reg [7:0]temp_integer=0;

always @ (posedge clk)
       begin
            humidity_integer[7:0] <= `UD information[31:24];//湿度整数
       end
always @ (posedge clk)
       begin
            humidity_decimal[3:0] <= `UD information[19:16];//湿度小数
       end
       
    always @(posedge clk)
    begin
        if(humidity_integer < 8'd10)
        begin
            humidity_one <= `UD humidity_integer[3:0];
            humidity_ten<=`UD 4'd0;
        end
        else if(humidity_integer < 8'd20)
        begin
            humidity_one <= `UD humidity_integer - 8'd10;
            humidity_ten<=`UD 4'd1;
        end
        else if(humidity_integer < 8'd30)
        begin
            humidity_one <= `UD humidity_integer - 8'd20;
            humidity_ten<=`UD 4'd2;
        end
        else if(humidity_integer < 8'd40)
        begin
            humidity_one <= `UD humidity_integer - 8'd30;
            humidity_ten<=`UD 4'd3;
        end
        else if(humidity_integer < 8'd50)
        begin
            humidity_one <= `UD humidity_integer - 8'd40;
            humidity_ten<=`UD 4'd4;
        end
        else if(humidity_integer < 8'd60)
        begin
            humidity_one <= `UD humidity_integer - 8'd50;
            humidity_ten<=`UD 4'd5;
        end
        else if(humidity_integer < 8'd70)
        begin
            humidity_one <= `UD humidity_integer - 8'd60;
            humidity_ten<=`UD 4'd6;
        end
        else if(humidity_integer < 8'd80)
        begin
            humidity_one <= `UD humidity_integer - 8'd70;
            humidity_ten<=`UD 4'd7;
        end
        else if(humidity_integer < 8'd90)
        begin
            humidity_one <= `UD humidity_integer - 8'd80;
            humidity_ten<=`UD 4'd8;
        end
        else if(humidity_integer < 8'd100)
        begin
            humidity_one <= `UD humidity_integer - 8'd90;
            humidity_ten<=`UD 4'd9;
        end
    end
            
              
always @ (posedge clk)
       begin
            temp_integer[7:0] <= `UD information[15:8];//温度整数
       end
always @ (posedge clk)
       begin
            temp_decimal[3:0] <= `UD information[3:0];//温度小数
       end
       
    always @(posedge clk)
    begin
        if(temp_integer < 8'd10)
        begin
            temp_one <= `UD temp_integer[3:0];
            temp_ten<=`UD 4'd0;
        end
        else if(temp_integer < 8'd20)
        begin
            temp_one <= `UD temp_integer - 8'd10;
            temp_ten<=`UD 4'd1;
        end
        else if(temp_integer < 8'd30)
        begin
            temp_one <= `UD temp_integer - 8'd20;
            temp_ten<=`UD 4'd2;
        end
        else if(temp_integer < 8'd40)
        begin
            temp_one <= `UD temp_integer - 8'd30;
            temp_ten<=`UD 4'd3;
        end
        else if(temp_integer < 8'd50)
        begin
            temp_one <= `UD temp_integer - 8'd40;
            temp_ten<=`UD 4'd4;
        end
        else if(temp_integer < 8'd60)
        begin
            temp_one <= `UD temp_integer - 8'd50;
            temp_ten<=`UD 4'd5;
        end
        else if(temp_integer < 8'd70)
        begin
            temp_one <= `UD temp_integer - 8'd60;
            temp_ten<=`UD 4'd6;
        end
        else if(temp_integer < 8'd80)
        begin
            temp_one <= `UD temp_integer - 8'd70;
            temp_ten<=`UD 4'd7;
        end
        else if(temp_integer < 8'd90)
        begin
            temp_one <= `UD temp_integer - 8'd80;
            temp_ten<=`UD 4'd8;
        end
        else if(temp_integer < 8'd100)
        begin
            temp_one <= `UD temp_integer - 8'd90;
            temp_ten<=`UD 4'd9;
        end
    end
       

endmodule
