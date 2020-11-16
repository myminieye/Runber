`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name:  dec_counter
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
module dec_counter(
    input            clk,
    input            det_start,
    input            trig,
    input            flow,
                     
    output reg       carry,
    output reg [3:0] dec
);

    always @(posedge clk)
    begin
        if(det_start)  //复位
            dec <= `UD 4'd0;
        else if(flow)  //溢出处理
            dec <= `UD 4'd10;
        else if(trig)
        begin
            if(dec == 4'd9)
                dec <= `UD 4'd0;
            else if(dec != 4'd10)
                dec <= `UD dec + 1'b1;                
        end
    end
    
    always @(posedge clk)
    begin
        if(trig & dec == 4'd9)
            carry <= `UD 1'b1;
        else
            carry <= `UD 1'b0;                
    end
 
endmodule
