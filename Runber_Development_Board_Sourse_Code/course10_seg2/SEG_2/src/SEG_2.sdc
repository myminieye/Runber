//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.2.02 Beta
//Created Time: 2020-01-07 14:25:51
create_clock -name clk -period 83.333 -waveform {0 41.666} [get_ports {clk}]
create_clock -name clk_12m -period 83.333 -waveform {0 41.666} [get_nets {clk_12m}]
