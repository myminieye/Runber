`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//        Company        : Myminieye
//     Internet site     : www.myminieye.com
// WeChat public account : MYMINIEYE
//       Engineer        : Mill
// 
//      Create Date      : 2020-08-17 08:02 
//      Design Name      :  
//      Module Name      : top_dht
//     Project Name      : 
//    Target Devices     : Gowin
//     Tool Versions     : 
//      Description      : 
//                       
//     Dependencies      : 
//                       
//       Revision        : Revision 0.01 - File Created
//  Additional Comments  :
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module top_dht
(	
	input clk,
	input rstn,
	inout in_out,
    output reg [3:0]dig,
	output reg [7:0]smg
);


/*===================================================
				触发和数据读取
===================================================*/
wire [31:0]information;
dht dht
(
        .clk			(clk		),//input clk,
        .rstn			(rstn		),//input rstn,
        .in_out			(in_out		),//inout in_out,
		.information	(information) //output reg [31:0]information

    );

wire [3:0]humidity_one;//湿度
wire [3:0]humidity_ten;
wire [3:0]humidity_decimal;
wire [3:0]temp_one;//温度
wire [3:0]temp_ten;
wire [3:0]temp_decimal;
/*===================================================
				数据形式转换
===================================================*/
change  change
(
       .clk		        (clk			 ),//input 			 clk,
       .rstn			(rstn			 ),//input 			 rstn,
       .information	    (information	 ),//读取的40位数据中的高32位//input  [31:0]	 information,//读取的40位数据中的高32位
       .humidity_one    (humidity_one    ),//output reg [3:0]humidity_one=0,//湿度
       .humidity_ten    (humidity_ten    ),//output reg [3:0]humidity_ten=0,
       .humidity_decimal(humidity_decimal),//output reg [3:0]humidity_decimal,
       .temp_one		(temp_one		  ), //output reg [3:0]temp_one=0,//温度
       .temp_ten        (temp_ten        ),//output reg [3:0]temp_ten=0,
       .temp_decimal    (temp_decimal    ) //output reg [3:0]temp_decimal
    );

/*===================================================
					时钟分频
===================================================*/
wire clk_100khz;
div_clk div_clk
(
	.clk		(clk),
	.clk_100khz (clk_100khz)
);
/*===================================================
					温度数码管显示
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
	.key(temp_one),
	.dig(dig0),
	.smg(smg0)
);

wire [3:0]dig1;
wire [7:0]smg1;

seq_control seq_control_1
(
	.sel(2'd2),
	.key(temp_ten),
	.dig(dig1),
	.smg(smg1)
);

wire [3:0]dig2;
wire [7:0]smg2;

seq_control seq_control_2
(
	.sel(2'd1),
	.key(humidity_one),
	.dig(dig2),
	.smg(smg2)
);

wire [3:0]dig3;
wire [7:0]smg3;

seq_control seq_control_3
(
	.sel(2'd0),
	.key(humidity_ten),
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