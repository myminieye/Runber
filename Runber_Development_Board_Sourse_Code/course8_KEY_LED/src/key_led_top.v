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
module key_led_top(
    input           clk,
    input           key,
    
    output [7:0]    led
);

   wire [1:0] ctrl;
   
   key_ctl key_ctl(
       .clk        (  clk  ),//input            clk,
       .key        (  key  ),//input            key,
                 
       .ctrl       (  ctrl  )//output     [1:0] ctrl
   );
   
   led u_led(
       .clk   (  clk   ),//input         clk,
       .ctrl  (  ctrl  ),//input  [1:0]  ctrl,
                      
       .led   (  led   ) //output [7:0]  led
   );

endmodule
