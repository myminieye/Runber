`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date: 2019-08-20 14:36
// Design Name: 
// Module Name: uart_data_gen
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

`define	UD #1
module uart_data_gen(
    input               clk,
    input               rstn,
    input      [7:0]    read_data,
    input               tx_busy,
    input      [7:0]    write_max_num,
    output reg [7:0]    write_data,
    output reg          write_en
);
    
    // set every second send a string,"====HELLO WORLD==="
    // 设置约每秒发送一个字符串
    reg [23:0] time_cnt=0;  
    reg [ 7:0] data_num;
    always @(posedge clk)
    begin
        time_cnt <= `UD time_cnt + 24'd1;
    end
    
    // 设置串口发射工作区间
    reg        work_en=0;
    reg        work_en_1d=0;
    always @(posedge clk)
    begin
        if(time_cnt == 25'd2048)
            work_en <= `UD 1'b1;
        else if(data_num == write_max_num-1'b1)
            work_en <= `UD 1'b0;
    end
    
    always @(posedge clk)
    begin
        work_en_1d <= `UD work_en;
    end

    // get the tx_busy‘s falling edge   获取tx_busy的下降沿
    reg            tx_busy_reg=0;
    wire           tx_busy_f;
    always @ (posedge clk) tx_busy_reg <= `UD tx_busy;
    
    assign tx_busy_f = (!tx_busy) && (tx_busy_reg);
    
    // 串口发射数据触发信号
    reg write_pluse;
    always @ (posedge clk)
    begin
        if(!rstn)
            write_pluse <= `UD 1'b0;
        else if(work_en)
        begin
            if(~work_en_1d || tx_busy_f)
                write_pluse <= `UD 1'b1;
            else
                write_pluse <= `UD 1'b0;
        end
        else
            write_pluse <= `UD 1'b0;
    end
    
    always @ (posedge clk)
    begin
        if(!rstn)
            data_num	<= `UD 8'h0;
        else if(~work_en & tx_busy_f)
            data_num   <= 7'h0;
        else if(write_pluse)
            data_num   <= data_num + 8'h1;
    end
    
    always @(posedge clk)
    begin
        write_en <= `UD write_pluse;
    end

//  字符的对应ASCII码
// H:0x48      E:0x45     L:0x4C    O:0x4F   W:0x57    R:0x52    D:0x44
    always @ (posedge clk)
    begin
        case(data_num)
            8'h0  ,	
            8'h1  ,
            8'h2  ,
            8'h3  :	write_data <= `UD 8'h3D;// ASCII code is =
            8'h4  :	write_data <= `UD 8'h48;// ASCII code is H
            8'h5  :	write_data <= `UD 8'h45;// ASCII code is E
            8'h6  :	write_data <= `UD 8'h4C;// ASCII code is L
            8'h7  :	write_data <= `UD 8'h4C;// ASCII code is L
            8'h8  :	write_data <= `UD 8'h4F;// ASCII code is 0
            8'h9  :	write_data <= `UD 8'h20;// ASCII code is  
            8'ha  :	write_data <= `UD 8'h57;// ASCII code is W
            8'hb  :	write_data <= `UD 8'h4F;// ASCII code is O
            8'hc  :	write_data <= `UD 8'h52;// ASCII code is R  
            8'hd  :	write_data <= `UD 8'h4C;// ASCII code is L  
            8'he  :	write_data <= `UD 8'h44;// ASCII code is D    
            8'hf  ,
            8'h10 ,  
            8'h11 :	write_data <= `UD 8'h3D;// ASCII code is = 
            8'h12 :	write_data <= `UD 8'h0d;
            8'h13 :	write_data <= `UD 8'h0a;
            default :	write_data <= `UD read_data;
        endcase
    end

endmodule
