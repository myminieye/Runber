`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: Nill
// 
// Create Date: 
// Design Name: 
// Module Name:  
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
`define UD #1

module pwm_servo #(
    parameter       CLK_FRE = 24'd12_000_000,
    parameter       PWM_CYCLE_TIME = 4'd3         // the time unit is 'ms'
)
(
    input       clk, // clock frequency is 12MHz.
    
    input [7:0] cfg, // [7:0] 0~180//cfg[7]:1 forward 0:Reverse ,cfg[6:0] is the angle(0~90)
    
    output      pwm
);
    parameter   PWM_CYCLE = (CLK_FRE/11'd1000)*PWM_CYCLE_TIME;
	parameter   PWM_0_5MS = (CLK_FRE/11'd2000);

    reg         pwm_clk = 1'd0;
    reg [15:0]  pwm_cnt = 16'd0;
    reg [15:0]  pwm_set = PWM_0_5MS;
    reg [ 7:0]  angle=8'b0000_0000;  
    assign      pwm = pwm_clk;
    
	//PWM周期控制
    always @(posedge clk)
    begin
        if(pwm_cnt == PWM_CYCLE - 1'b1)
            pwm_cnt <= `UD 16'd0;
        else 
            pwm_cnt <= `UD pwm_cnt + 1'd1;
    end
	// always@(posedge clk)
	// begin
	    // a <= b;
		// e <= a;
		// c <= d;
	// end
	
    //PWM信号控制
    always @(posedge clk)
    begin
        if(pwm_cnt == 16'd0)
            pwm_clk <= `UD 1'b1;
        else if(pwm_cnt == pwm_set)
            pwm_clk <= `UD 1'b0;
    end
	
    
    reg [3:0] angle_cnt=0;
    // 40 times counter -> 0.3  40个时钟周期的时间宽度变化为0.3度
    always @(posedge clk)
    begin
        if(angle != cfg && pwm_cnt == PWM_CYCLE - 1'b1)
        begin
            if(angle_cnt == 4'd9)
                angle_cnt <= `UD 4'd0;
            else
                angle_cnt <= `UD angle_cnt + 1'b1;
        end
        else if(angle == cfg)
            angle_cnt <= `UD 4'd0;
        else
            angle_cnt <= `UD angle_cnt;
    end
    
	//  cfg   set the servo angle
	//  angle  模块当前角度记录
	always @(posedge clk)
    begin
	    if(angle < cfg)
		begin
		    if((angle_cnt == 4'd2 || angle_cnt == 4'd6 || angle_cnt == 4'd9) && pwm_cnt == PWM_CYCLE - 1'b1)
				angle <= `UD angle + 1'b1;
			else
				angle <= `UD angle;
		end
		else if(angle > cfg)
		begin
		    if((angle_cnt == 4'd2 || angle_cnt == 4'd6 || angle_cnt == 4'd9) && pwm_cnt == PWM_CYCLE - 1'b1)
				angle <= `UD angle - 1'b1;
			else
				angle <= `UD angle;
		end
		else
		    angle <= `UD cfg;
	end

	// angle to counter 角度值转化为计数器阈值
	always @(posedge clk)
    begin
        if(pwm_cnt == PWM_CYCLE - 1'b1)
        begin
			if(angle == cfg)
				pwm_set <= `UD pwm_set;
			else if(angle < cfg)
				pwm_set <= `UD pwm_set + 6'd40;
			else
				pwm_set <= `UD pwm_set - 6'd40;
        end
        else
            pwm_set <= `UD pwm_set;
    end
    // always @(posedge clk)
    // begin
        // case({angle[7],cfg[7]})
            // 2'b00,
            // 2'b11:
            // begin
                // if(angle[6:0] < cfg[6:0])
                // begin
                    // if((angle_cnt == 4'd2 || angle_cnt == 4'd6 || angle_cnt == 4'd9) && pwm_cnt == PWM_CYCLE - 1'b1)
                        // angle[6:0] <= `UD angle[6:0] + 1'b1;
                    // else
                        // angle[6:0] <= `UD angle[6:0];
                // end
                // else
                // begin
                    // if((angle_cnt == 4'd2 || angle_cnt == 4'd6 || angle_cnt == 4'd9) && pwm_cnt == PWM_CYCLE - 1'b1)
                        // angle[6:0] <= `UD angle[6:0] - 1'b1;
                    // else
                        // angle[6:0] <= `UD angle[6:0];
                // end
            // end
            // 2'b01,
            // 2'b10:
            // begin
                // if((angle_cnt == 4'd2 || angle_cnt == 4'd6 || angle_cnt == 4'd9) && pwm_cnt == PWM_CYCLE - 1'b1)
                // begin
                    // if(angle[6:0] == 7'd0)
                    // begin
                        // angle[7] <= `UD ~angle[7];
                        // angle[6:0] <= `UD angle[6:0];
                    // end
                    // else
                        // angle[6:0] <= `UD angle[6:0] - 1'b1;
                // end
                // else
                    // angle[6:0] <= `UD angle[6:0];
            // end
        // endcase
    // end
    
    // always @(posedge clk)
    // begin
        // if(pwm_cnt == PWM_CYCLE - 1'b1)
        // begin
            // case({angle[7],cfg[7]})
                // 2'b00:
                // begin
                    // if(angle == cfg)
                        // pwm_set <= `UD pwm_set;
                    // else if(angle[6:0] < cfg[6:0])
                        // pwm_set <= `UD pwm_set - 6'd40;
                    // else
                        // pwm_set <= `UD pwm_set + 6'd40;
                // end
                // 2'b11:
                // begin
                    // if(angle == cfg)
                        // pwm_set <= `UD pwm_set;
                    // else if(angle[6:0] < cfg[6:0])
                        // pwm_set <= `UD pwm_set + 6'd40;
                    // else
                        // pwm_set <= `UD pwm_set - 6'd40;
                // end
                // 2'b01:
                // begin
                    // if(angle == cfg)
                        // pwm_set <= `UD pwm_set;
                    // else
                        // pwm_set <= `UD pwm_set + 6'd40;
                // end
                // 2'b10:
                // begin
                    // if(angle == cfg)
                        // pwm_set <= `UD pwm_set;
                    // else
                        // pwm_set <= `UD pwm_set - 6'd40;
                // end
            // endcase
        // end
        // else
            // pwm_set <= `UD pwm_set;
    // end
    
endmodule