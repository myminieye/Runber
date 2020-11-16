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
    input          clk, //ÊäÈëÊ±ÖÓ50MHz
    input  [7:0]   key,//8¸ö°´¼üÊäÈë
    
    output [7:0]   led,//8¸öledÊä³ö
    output [7:0]   smg,//8Î»ÊıÂë¹Ü¶ÎÑ¡
    output [3:0]   dig  //4Î»ÊıÂë¹ÜÎ»Ñ¡
);
    
    //===========================================================================
    wire  [7:0] btn_deb;
    wire        restart;
    wire        det_start;
    wire        det_end;
    
    wire [15:0] ctrl;
    //===========================================================================
    btn_deb#(       // °´¼üÏû¶¶             
        .BTN_WIDTH      (  4'd8      ) //parameter                  BTN_WIDTH = 4'd8 //°´¼üÎ»¿í                         
    ) U_btn_deb                                                                                            
    (                                                                                                    
        .clk            (  clk       ),//input                      clk,//ÊäÈë´¦ÀíÊ±ÖÓ50MHz                             
        .btn_in         (  key       ),//input      [BTN_WIDTH-1:0] btn_in,//ÊäÈë°´¼üĞÅºÅ                               
                                                                                                         
        .btn_deb        (  btn_deb  ) //output reg [BTN_WIDTH-1:0] btn_deb //Êä³ö°´¼üÏû¶¶ĞÅºÅ                          
    );

    assign restart = (~btn_deb[0])&(~btn_deb[7]);
    
    led_ctl led_ctl(
        .clk            (  clk        ),//input                 clk,      //ÊäÈë´¦ÀíÊ±ÖÓ50MHz                            
        .restart        (  restart    ),//input                 restart,  //ÊäÈëÖØĞÂ¿ªÊ¼ĞÅºÅ£¬¸ßµãÆ½ÓĞĞ§             
                                                                                                                  
        .det_start      (  det_start  ),//output reg            det_start,//Êä³ö¼ì²â¿ªÊ¼ĞÅºÅ                       
        .led            (  led        ) //output reg   [7:0]    led      //Êä³ö¼ì²âÌõ¼ş£¬ÒÔLEDÊÓ¾õ´¥·¢                   
    );
    
    compare compare(
        .clk            (  clk        ),//input                clk,      //ÊäÈë´¦ÀíÊ±ÖÓ50MHz                                    
        .det_start      (  det_start  ),//input                det_start,//ÊäÈë¼ÆÊ±¿ªÊ¼ĞÅºÅ£¬1¸öÊ±ÖÓÖÜÆÚ£¬¸ßµçÆ½ÓĞĞ      §                            
        .restart        (  restart    ),//input                restart,  //ÊäÈëÖØĞÂ¿ªÊ¼ĞÅºÅ£¬¸ßµãÆ½ÓĞĞ§    
        .btn_deb        (  btn_deb    ),//input      [ 7:0]    btn_deb,  //ÊäÈë°´¼üĞÅºÅ                                   
        .bit_sel        (  led        ),//input      [ 7:0]    bit_sel,  //ÊäÈë¼ì²âÌõ¼ş                                  
                                                                                                               
        .det_end        (  det_end    ),//output               det_end,  //Êä³ö¼ÆÊ±½áÊøĞÅºÅ                                  
        .ctrl           (  ctrl       ) //output reg [15:0]    ctrl      //Êä³ö¼ÆÊ±Í³¼Æ½á¹û                                 
    );

    seq_display seq_display(
        .clk            (  clk        ),//input               clk,     //ÊäÈë´¦ÀíÊ±ÖÓ50MHz                      
        .restart        (  restart    ),//input               restart, //ÊäÈëÖØĞÂ¿ªÊ¼ĞÅºÅ£¬¸ßµãÆ½ÓĞĞ§      
        .det_end        (  det_end    ),//input               det_end, //ÊäÈë¼ÆÊ±½áÊøĞÅºÅ                   
        .ctrl           (  ctrl       ),//input      [15:0]   ctrl,    //ÊäÈë¼ÆÊ±Í³¼Æ½á¹û                    
                                                                                           
        .smg            (  smg        ),//output reg  [7:0]   smg,     //Êä³ö8Î»ÊıÂë¹Ü¶ÎÑ¡                     
        .dig            (  dig        ) //output reg  [3:0]   dig      //Êä³ö4Î»ÊıÂë¹ÜÎ»Ñ¡                     
    );



endmodule
