`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date:  2019-09-04 20:22
// Design Name: led_light
// Module Name: led_light
// Project Name: 
// Target Devices: Gowin
// Tool Versions: 
// Description: 
//     make the led on and off
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1

module led_light(
    input          clk,
    input          rstn,
    
    output [7:0]   led
);


//==============================================================================
//reg and wire

// runber  12M     12_000_000
// Pocket_lab 50M  50_000_000

    reg [24:0] led_light_cnt= 25'd0;
    reg [ 7:0] led_status = 8'b0000_0001;
    
    //  time counter
    always @(posedge clk)
    begin
        if(!rstn)
            led_light_cnt <= `UD 25'd0;
        else if(led_light_cnt == 25'd599_9999)
            led_light_cnt <= `UD 25'd0;
        else
            led_light_cnt <= `UD led_light_cnt + 25'd1; 
    end
    
    // led status change
    always @(posedge clk)
    begin
        if(!rstn)
            led_status <= `UD 8'b0000_0001;
        else if(led_light_cnt == 25'd599_9999)
            led_status <= `UD {led_status[6:0],led_status[7]};
    end

    assign led = led_status;
    
endmodule
