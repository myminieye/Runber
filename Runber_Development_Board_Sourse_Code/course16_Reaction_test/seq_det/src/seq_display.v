`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name:  
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
module seq_display(
    input               clk,     //输入处理时钟50MHz            
    input               restart, //输入重新开始信号，高点平有效 
    input               det_end, //输入计时结束信号             
    input      [15:0]   ctrl,    //输入计时统计结果             
                                                                
    output reg  [7:0]   smg,     //输出8位数码管段选            
    output reg  [3:0]   dig      //输出4位数码管位选            
);

    //============================================================================
    //数码管显示荣控制
    reg [3:0] key0_cnt=4'd0,key1_cnt=4'd0,key2_cnt=4'd0,key3_cnt=4'd0;
    always @(posedge clk)
    begin
        if(restart)
        begin
            key0_cnt <= `UD 4'd0;
            key1_cnt <= `UD 4'd0;
            key2_cnt <= `UD 4'd0;
            key3_cnt <= `UD 4'd0;
        end
        else if(det_end)
        begin
            key0_cnt <= `UD ctrl[ 3: 0];
            key1_cnt <= `UD ctrl[ 7: 4];
            key2_cnt <= `UD ctrl[11: 8];
            key3_cnt <= `UD ctrl[15:12];
        end
    end

    /*===================================================
                        时钟分频
    ===================================================*/
    wire clk_100khz;
    div_clk div_clk
    (
        .clk        (clk),
        .clk_100khz (clk_100khz)
    );
    /*===================================================
                        数码管显示
    ===================================================*/
    reg  [1:0]sel=0;
    wire [3:0]dig0;
    wire [7:0]smg0;
    
    always @(posedge clk_100khz)
    begin
        sel <= `UD sel+1'b1;
    end 
    
    seq_control seq_control_0
    (
        .sel(2'd3),
        .key(key0_cnt),
        .dig(dig0),
        .smg(smg0)
    );
    
    wire [3:0]dig1;
    wire [7:0]smg1;
    
    seq_control seq_control_1
    (
        .sel(2'd2),
        .key(key1_cnt),
        .dig(dig1),
        .smg(smg1)
    );
    
    wire [3:0]dig2;
    wire [7:0]smg2;
    
    seq_control seq_control_2
    (
        .sel(2'd1),
        .key(key2_cnt),
        .dig(dig2),
        .smg(smg2)
    );
    
    wire [3:0]dig3;
    wire [7:0]smg3;
    
    seq_control seq_control_3
    (
        .sel(2'd0),
        .key(key3_cnt),
        .dig(dig3),
        .smg(smg3)
    );
    
    always @(posedge clk_100khz)
    begin
        if(sel==2'b00)
            dig <= `UD dig0;
        else if(sel==2'b01)
            dig <= `UD dig1;
        else if(sel==2'b10)
            dig <= `UD dig2;
        else if(sel==2'b11)
            dig <= `UD dig3;
    end 
    
    always @(posedge clk_100khz)
    begin
        if(sel==2'b00)
            smg <= `UD smg0;
        else if(sel==2'b01)
            smg <= `UD smg1;
        else if(sel==2'b10)
            smg <= `UD smg2;
        else if(sel==2'b11)
            smg <= `UD smg3;
    end

endmodule
