`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:   
// Design Name:  
// Module Name: key_ctl 
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
    input            clk,
    input      [3:0] key,
    input            enter,
    input            init,
    
    output           enter_trig,
    output           init_trig,
    output     [7:0] ctrl
);

    wire [5:0] btn_deb;
    // °´¼üÏû¶¶
    btn_deb#(                    
        .BTN_WIDTH   (  4'd6     ) //parameter                  BTN_WIDTH = 4'd8
    ) U_btn_deb                           
    (                            
        .clk         (  clk      ),//input                      clk,
        .btn_in      (  {enter,init,key}      ),//input      [BTN_WIDTH-1:0] btn_in,
                  
        .btn_deb     (  btn_deb  ) //output reg [BTN_WIDTH-1:0] btn_deb
    );

    reg [1:0]  key1_push_cnt=2'd0;
    reg [1:0]  key2_push_cnt=2'd0;
    reg [1:0]  key3_push_cnt=2'd0;
    reg [1:0]  key4_push_cnt=2'd0;
    
    reg btn1_deb_1d,btn2_deb_1d,btn3_deb_1d,btn4_deb_1d;
    reg enter_deb_1d,init_deb_1d;
    
    assign enter_trig = ~btn_deb[5] & enter_deb_1d;
    assign init_trig = ~btn_deb[4] & init_deb_1d;

    always @(posedge clk)
    begin
        btn1_deb_1d  <= `UD btn_deb[0];
        btn2_deb_1d  <= `UD btn_deb[1];
        btn3_deb_1d  <= `UD btn_deb[2];
        btn4_deb_1d  <= `UD btn_deb[3];
        init_deb_1d  <= `UD btn_deb[4];
        enter_deb_1d <= `UD btn_deb[5];
    end

    always @(posedge clk)
    begin
        if(~btn_deb[4] & init_deb_1d)
            key1_push_cnt <= `UD 2'd0;
        else if(~btn_deb[0] & btn1_deb_1d)
        begin
            key1_push_cnt <= `UD key1_push_cnt + 2'd1;
        end
    end
    
    always @(posedge clk)
    begin
        if(~btn_deb[4] & init_deb_1d)
            key2_push_cnt <= `UD 2'd0;
        else if(~btn_deb[1] & btn2_deb_1d)
        begin
            key2_push_cnt <= `UD key2_push_cnt + 2'd1;
        end
    end
    
    always @(posedge clk)
    begin
        if(~btn_deb[4] & init_deb_1d)
            key3_push_cnt <= `UD 2'd0;
        else if(~btn_deb[2] & btn3_deb_1d)
        begin
            key3_push_cnt <= `UD key3_push_cnt + 2'd1;
        end
    end
    
    always @(posedge clk)
    begin
        if(~btn_deb[4] & init_deb_1d)
            key4_push_cnt <= `UD 2'd0;
        else if(~btn_deb[3] & btn4_deb_1d)
        begin
            key4_push_cnt <= `UD key4_push_cnt + 2'd1;
        end
    end

    assign ctrl = {key4_push_cnt,key3_push_cnt,key2_push_cnt,key1_push_cnt};

endmodule
