`timescale 1ns / 1ps
`define UD #1
module div_clk
(
	input clk,
	output  clk_100khz
);
//times =120 :83.33ns*120=10ms=100khz;
reg [8:0]cnt;
always @(posedge clk)
begin
	if(cnt == 9'd119)
		cnt<= `UD 9'd0;
	else 
		cnt <= `UD cnt + 1'b1;
end  

reg flag=1'b0;
always @(posedge clk)
begin
	if(cnt == 9'd59)
		flag <= `UD 1'b1;
	else if(cnt == 9'd119)
		flag <= `UD 1'b0;
end 
assign clk_100khz = flag;

endmodule