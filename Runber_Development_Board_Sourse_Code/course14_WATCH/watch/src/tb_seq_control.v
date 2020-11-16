`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 19:46
// Design Name: 
// Module Name: seq_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 分频得到100khz的时钟，即10ms
// 
// Dependencies: 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module tb_seq_control;

	reg clk;
	reg [2:0]control_dig;
	reg [1:0]sel=0;
	reg [3:0]key;
	wire [3:0]dig;
	wire [7:0]smg;


seq_control uut
(
	.clk		 (clk		 ),
	.control_dig (control_dig ),
	.sel		 (sel		 ),
	.key		 (key		 ),
	.dig		 (dig		 ),
	.smg         (smg         )
);

initial
begin
	#0;
		clk=1'b0;
		control_dig=3'd0;
		//sel=2'd0;
		key=4'd0;
	repeat(30) @(posedge clk)#1;
		control_dig=3'd2;
		//sel=2'd1;
		key=4'd5;		
end 

always @(posedge clk)
begin
	sel <=`UD sel + 1'b1; 
end 

always #10 clk = ~clk;
endmodule 