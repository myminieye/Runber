`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: MYMINIEYE
// Engineer:Mill
//
// Create Date:   2019/08/26 21:34:00
// Design Name:   
// Module Name:   led_test
// Project Name:  
// Target Device:  
// Tool versions:  
// Description: 
//
//
//
// Dependencies:
// 
// Revision:v01
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define UD #1
module led_test
(
	input clk,
	output  reg [2:0]led
);

//clk_out = 50MHZ
//1s = 5*10^7=16'h2faf080
wire clk_out;


clk_gen clk_50m_gen
(
.clkout(clk_out),
.clkin(clk)
);

reg [25:0] time_cnt;
always @(posedge clk_out)
begin
	if(time_cnt==26'h2faf080-1'b1)
		time_cnt <= `UD 26'd0;
	else 
		time_cnt <= `UD time_cnt +1'b1;
end 

reg [1:0]cnt;
always @(posedge clk_out)
begin
	if(cnt==2'd2 && time_cnt==26'h2faf080-1'b1)
		cnt <= `UD 2'd0;
	else if(time_cnt==26'h2faf080-1'b1)
		cnt <= `UD cnt + 1'b1;
end

always @(*)
begin
	case(cnt)
		2'd0:
			led = 3'b110;
		2'd1:       
			led = 3'b101;
		2'd2:       
			led = 3'b011;
		default:
			led = 3'b110;
	endcase 
end 

endmodule
