//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.5 Beta
//Created Time: 2020-05-13 09:54:17
create_clock -name clk_1Hz -period 1000000000 -waveform {0 500000000} [get_nets {clk_1hz}]
create_clock -name clk -period 83.333 -waveform {0 41.666} [get_ports {clk}]
create_clock -name clk_12m -period 83.333 -waveform {0 41.666} [get_nets {clk_12m}]
create_clock -name clk_c -period 83.333 -waveform {0 41.666} [get_nets {clk_c}]
