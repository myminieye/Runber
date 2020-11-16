`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date: 
// Design Name: 
// Module Name:  
// Project Name: 
// Target Devices: 
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

module servo_ctl(
    input       clk,
    input [1:0] key,
    
    output      pwm
);

   wire [7:0] ctrl;
   
   key_ctl key_ctl(
       .clk        (  clk   ),//input            clk,
       .key        (  key   ),//input            key,
                 
       .ctrl       (  ctrl  )//output     [1:0] ctrl
   );
   
   pwm_servo #(
       .CLK_FRE         (  24'd12_000_000  ),//parameter       CLK_FRE = 24'd12_000_000,                                              
       .PWM_CYCLE_TIME  (  4'd20           ) //parameter       PWM_CYCLE_TIME = 4'd3         // the time unit is 'ms'                 
   ) pwm_servo (                                                                                                             
       .clk             (  clk             ),//input       clk, // clock frequency is 12MHz.                                          
                                                                                                                           
       .cfg             (  ctrl            ),//input [7:0] cfg, // cfg[7]:1 forward 0:Reverse ,cfg[6:0] is the angle(0~90)            
                                                                                                                           
       .pwm             (  pwm             ) //output      pwm                                                                        
   );


endmodule
