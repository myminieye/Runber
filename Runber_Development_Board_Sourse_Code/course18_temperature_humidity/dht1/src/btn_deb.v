`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date: 2019-09-16 20:31  
// Design Name:  
// Module Name:  btn_deb
// Project Name: 
// Target Devices: Gowin
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1
module btn_deb
(
    input       clk,  //12MHz
    input       btn_in,
    input       rstn,
    output reg  btn
);

//==================================================================================
    reg [17:0] time_cnt= 18'd0;
    always @ (posedge clk)
    begin
        if(!rstn || time_cnt == 18'h3A980)//20ms计时
            time_cnt <= `UD 18'd0;
        else
            time_cnt <= `UD time_cnt + 18'd1;
    end
    reg btn_deb1=1'b1;
    reg btn_deb2=1'b1;
    always @(posedge clk)
    begin
        if(time_cnt == 18'd0)
            btn_deb1 <= `UD btn_in;
            btn_deb2 <= `UD btn_deb1;
    end
    always @(posedge clk)
    begin
        if(!rstn)
            btn <= `UD 1'b0;
        else if((!btn_deb1) && (!btn_deb2))//间隔20ms采集按键数据，若连续两次为低电平则认为按键按下
            btn <= `UD 1'b1;
        else
            btn <= `UD 1'b0;
    end

endmodule
