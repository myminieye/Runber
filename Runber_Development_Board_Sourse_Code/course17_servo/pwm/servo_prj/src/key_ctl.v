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
module key_ctl(
    input          clk,
    input   [1:0]  key,
    
    output  [7:0]  ctrl  // 0~180S
);

    wire[1:0] btn_deb;
    // °´¼üÏû¶¶
    btn_deb#(                    
        .BTN_WIDTH   (  4'd2     ) //parameter                  BTN_WIDTH = 4'd8
    ) U_btn_deb                           
    (                            
        .clk         (  clk      ),//input                      clk,
        .btn_in      (  key      ),//input      [BTN_WIDTH-1:0] btn_in,
                  
        .btn_deb     (  btn_deb  ) //output reg [BTN_WIDTH-1:0] btn_deb
    );

    reg[1:0] btn_deb_1d;
    always @(posedge clk)
    begin
        btn_deb_1d <= `UD btn_deb;
    end
    // set angle
    reg [7:0]  key_push_cnt=8'b0000_0000;
	always @(posedge clk)
    begin
        if(~btn_deb[0] & btn_deb_1d[0])
        begin
			if(key_push_cnt <= 8'd10)
				key_push_cnt <= `UD key_push_cnt;
			else
				key_push_cnt <= `UD key_push_cnt -8'd5;
        end
        else if(~btn_deb[1] & btn_deb_1d[1])
        begin
            if(key_push_cnt >= 8'd170)
				key_push_cnt <= `UD key_push_cnt;
			else
				key_push_cnt <= `UD key_push_cnt + 8'd5;
        end
    end
	
    // always @(posedge clk)
    // begin
        // if(~btn_deb[0] & btn_deb_1d[0])
        // begin
            // if(key_push_cnt[7])
            // begin
                // if(key_push_cnt[6:0] <= 8'd10)
                // begin
                    // key_push_cnt[6:0] <= `UD 8'd10 - key_push_cnt[6:0];
                    // key_push_cnt[7] <= `UD ~key_push_cnt[7];
                // end
                // else
                    // key_push_cnt[6:0] <= `UD key_push_cnt[6:0] -8'd5;
            // end
            // else
                // key_push_cnt[6:0] <= `UD key_push_cnt[6:0] + 8'd5;
        // end
        // else if(~btn_deb[1] & btn_deb_1d[1])
        // begin
            // if(~key_push_cnt[7])
            // begin
                // if(key_push_cnt[6:0] <= 8'd10)
                // begin
                    // key_push_cnt[6:0] <= `UD 8'd10 - key_push_cnt[6:0];
                    // key_push_cnt[7] <= `UD ~key_push_cnt[7];
                // end
                // else
                    // key_push_cnt[6:0] <= `UD key_push_cnt[6:0] - 8'd5;
            // end
            // else
                // key_push_cnt[6:0] <= `UD key_push_cnt[6:0] + 8'd5;
        // end
    // end
    
    assign ctrl = key_push_cnt;

endmodule
