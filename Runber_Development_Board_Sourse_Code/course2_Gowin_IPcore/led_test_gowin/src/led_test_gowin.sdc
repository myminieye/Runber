//Copyright (C)2014-2019 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.1.01 Beta
//Created Time: 2019-11-05 16:32:17
create_clock -name clk -period 83.333 -waveform {0 41.666} [get_ports {clk}] -add
create_clock -name clk_out -period 19.608 -waveform {0 9.804} [get_nets {clk_out}] -add
