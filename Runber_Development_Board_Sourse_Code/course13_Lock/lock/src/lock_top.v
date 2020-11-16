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
module lock_top(
    input          clk,
    input  [3:0]   key,
    input          enter,
    input          init, 
    input  [7:0]   sw,
    
    output [7:0]   smg,
    output [3:0]   dig 
);

    
    wire             enter_trig;
    wire             init_trig;
    wire [7:0]       ctrl;  
    wire             com_result; 
    
    key_ctl key_ctl(
        .clk           (  clk         ),//input            clk,
        .key           (  key         ),//input      [3:0] key,
        .enter         (  enter       ),//input            enter,
        .init          (  init        ),//input            init,

        .enter_trig    (  enter_trig  ),//output           enter_trig,
        .init_trig     (  init_trig   ),//output           init_trig,
        .ctrl          (  ctrl        ) //output     [7:0] ctrl
    );
    
    compare compare(
        .clk           (  clk         ),//input        clk,
        .sw            (  sw          ),//input [7:0]  sw,
        .ctrl          (  ctrl        ),//input [7:0]  ctrl,
        .enter_trig    (  enter_trig  ),//input        enter_trig,

        .com_result    (  com_result  ) //output       com_result
    );
    
    seq_display(
        .clk           (  clk         ),//input               clk,
        .enter_trig    (  enter_trig  ),//input               enter_trig,
        .init_trig     (  init_trig   ),//input               init_trig,
        .com_result    (  com_result  ),//input               com_result,
        .ctrl          (  ctrl        ),//input       [7:0]   ctrl,

        .smg           (  smg         ),//output reg  [7:0]   smg,
        .dig           (  dig         ) //output reg  [3:0]   dig
    );

endmodule
