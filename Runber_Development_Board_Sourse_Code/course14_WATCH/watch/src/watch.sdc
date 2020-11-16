//Copyright (C)2014-2019 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.1.01 Beta
//Created Time: 2019-09-21 16:45:59
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
