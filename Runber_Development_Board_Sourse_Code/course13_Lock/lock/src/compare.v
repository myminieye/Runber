`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name:  compare
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
module compare(
    input        clk,
    input [7:0]  sw,
    input [7:0]  ctrl,
    input        enter_trig,
    
    output       com_result
);

//==============================================================================
    //锁存当前的输入密码；
    reg [7:0] ctrl_1d;
    always @(posedge clk)
    begin
        if(enter_trig)
            ctrl_1d <= `UD ctrl;
    end

    assign com_result = (ctrl_1d == sw);
endmodule
