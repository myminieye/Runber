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
module btn_deb#(
    parameter                  BTN_WIDTH = 4'd8
)
(
    input                      clk,
    input      [BTN_WIDTH-1:0] btn_in,
    
    output reg [BTN_WIDTH-1:0] btn_deb
);

//==================================================================================
    reg [17:0] time_cnt= 18'd0;
    always@(posedge clk)
    begin
        time_cnt <= `UD time_cnt + 18'd1;
    end
    
    always @(posedge clk)
    begin
        if(time_cnt == 18'd0)
            btn_deb <= `UD btn_in;
    end

endmodule
