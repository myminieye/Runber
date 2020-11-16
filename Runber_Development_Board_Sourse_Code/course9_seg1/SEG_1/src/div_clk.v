`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 11:26
// Design Name: 
// Module Name: blue
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 数码管显示，0~9，每个1s变化一次
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module div_clk
(
	input clk,
	output clk_1hz
);
// 83.33*12000000=1s hex= B71B00
reg [23:0] times_cnt=0;

    always @(posedge clk)
    begin
	   if(times_cnt== 24'hB71B00-1'b1)
	       times_cnt <= `UD 24'd0;
	   else 		
		   times_cnt <= `UD times_cnt + 1'b1;
    end 

reg flag=0;
always @(posedge clk)
begin
	if(times_cnt==24'hB71B00/2 - 1'b1)
		flag <= `UD 1'b1;
	else if(times_cnt== 24'hB71B00 - 1'b1)
		flag <= `UD 1'b0;		
end 
assign clk_1hz = flag;

endmodule
