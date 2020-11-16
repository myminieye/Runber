`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Mill
// 
// Create Date: 2019-09-16 19:11
// Design Name: 
// Module Name: seq
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 四个数码管显示不同的数字，按键KEY0控制第一个数码管，
//        按一下数字加1，从0到9，按键KEY1控制第二个数码管，按一下数字加1，
//        从0到9，按键KEY2控制第三个数码管，按键KEY3控制第四个数码管。
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module top_seq2
(
	input clk,//50MHZ 20ns
	input [3:0]button,
	output reg [3:0]dig,
	output reg [7:0]smg
);

    wire clk_12m;
    pll pll(
        .clkout(clk_12m), //output clkout
        .clkin(clk) //input clkin
    );

/*===================================================
					按键消斗
===================================================*/
wire [3:0]key;
btn_deb 
#(
   .BT_WIDTH(4'd4)
)
u_btn_deb
(
    .clk(clk_12m),
    .btn_in(button),
    .btn_out(key)
);
/*===================================================
					4个按键的计数
===================================================*/
wire [3:0] key0_cnt;
key_cnt key0
(
	.clk(clk_12m),
	.key(key[0]),
	.key_times(key0_cnt)
);

wire [3:0] key1_cnt;
key_cnt key1
(
	.clk(clk_12m),
	.key(key[1]),
	.key_times(key1_cnt)
);

wire [3:0] key2_cnt;
key_cnt key2
(
	.clk(clk_12m),
	.key(key[2]),
	.key_times(key2_cnt)
);

wire [3:0] key3_cnt;
key_cnt key3
(
	.clk(clk_12m),
	.key(key[3]),
	.key_times(key3_cnt)
);
/*===================================================
					时钟分频
===================================================*/
wire clk_100khz;
div_clk div_clk
(
	.clk		(clk_12m),
	.clk_100khz (clk_100khz)
);
/*===================================================
					数码管显示
===================================================*/
reg  [1:0]sel=0;
wire [3:0]dig0;
wire [7:0]smg0;

always @(posedge clk_100khz)
begin
	sel <= `UD sel+1'b1;
end 

seq_control seq_control_0
(
	.sel(2'd3),
	.key(key0_cnt),
	.dig(dig0),
	.smg(smg0)
);

wire [3:0]dig1;
wire [7:0]smg1;

seq_control seq_control_1
(
	.sel(2'd2),
	.key(key1_cnt),
	.dig(dig1),
	.smg(smg1)
);

wire [3:0]dig2;
wire [7:0]smg2;

seq_control seq_control_2
(
	.sel(2'd1),
	.key(key2_cnt),
	.dig(dig2),
	.smg(smg2)
);

wire [3:0]dig3;
wire [7:0]smg3;

seq_control seq_control_3
(
	.sel(2'd0),
	.key(key3_cnt),
	.dig(dig3),
	.smg(smg3)
);


always @(posedge clk_100khz)
begin
	if(sel==2'b00)
		dig <= `UD dig0;
	else if(sel==2'b01)
		dig <= `UD dig1;
	else if(sel==2'b10)
		dig <= `UD dig2;
	else if(sel==2'b11)
		dig <= `UD dig3;
end 


always @(posedge clk_100khz)
begin
	if(sel==2'b00)
		smg <= `UD smg0;
	else if(sel==2'b01)
		smg <= `UD smg1;
	else if(sel==2'b10)
		smg <= `UD smg2;
	else if(sel==2'b11)
		smg <= `UD smg3;
end



endmodule 