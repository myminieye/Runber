About the Development Board
1.1	Overview
The RUNBER development board is a brand new set of FPGA development suite developed by MYMINIEYE, which adopts the GOWIN GW1N-UV4LQ144 solution. GW1N-4B is a FPGA product of the GOWIN LittleBee family.
The development system provides open source of the schematic diagram and a large amount of source codes that can be directly used in the project. For matching source codes, please see the course list.
 
Figure 1.1	RUNBER Development Board
1.2	About the Development System
1.2.1	System Resources
The RUNBER development board is a development suite based on the Gowin GW1N-4 extensible processing platform. It provides the following features:
◎	Gowin® GW1N-UV4LQ144C6/I5
	Default startup mode: built-in flash
 
◎	Peripherals/ports
	Micro USB port (onboard USB JTAG port)
	Common cathode 8-segment, 4-digit numeric display
	8-digit DIP switch
	8-digit LED
	8-digit key
	4 RGB LEDs (common anode)
	36 expanded IO ports (2.54mm pin headers)
◎	Onboard crystal oscillator
	12MHz
2	About the Port
2.1	USB to JTAG port
A USB-to-JTAG module is integrated on the Runber board. With the FT232HQ of FTDI as a connector, a USB-to-micro cable can connect the onboard JTAG module via the onboard J14 (micro USB socket, the corresponding port of which can be found by referring to the above drawing of the board ports). The computer can recognize the following drivers when it gets connected:
 
FPGA model of the RUNBER: GW1N-UV4LQ144C6/I5;
If the warning below appears after the fs file is compiled, the devices do not match each other;
 
If the models of the devices selected in the project correspond with our boards, there must be problems in selection of the series of the devices. Double click the devices in the box in the figure below for resetting. The models of the devices can also be changed here if they do not correspond with the board.
 
If the series of the devices are unknown, you can get the models of the devices via JTAG scan as indicated below (the series of the devices are in Device Chooser, the number ending with R is that for the FPGA with built-in SDRAM, and the devices selected by the Runber board do not have the built-in SDRAM):
 
    
2.2	Power supply
The board can be powered with the VBUS from the USB, or the 5V power from the expansion port or 3.3V power from a LDO. As we select the UV series devices, up to 3.3V core voltage is supported, which simplifies the power system of the board.
       
2.3	Clock
The Runber board features an oscillator that provides clock for FT232HQ and GW1N-4 at the same time at a frequency of 12MHz.
The pins connecting GW1N-4 are shown in the table below:
Signal	Description	Gowin pins
FPGA_CLK_12M	Clock input at 12MHz	4
2.4	Common cathode numeric display
The correspondence between the pins of the numeric display and the segment selection is shown in the figure below, with the response time of about 0.1us. An average forward current of 20mA is needed for each segment.
 
The pins connecting GW1N-4 are shown in the table below:
Signal	Description	Gowin pins
SEG_DIG1	Digit 1of the numeric display from the left	137
SEG_DIG2	Digit 2 of the numeric display from the left	140
SEG_DIG3	Digit 3 of the numeric display from the left	141
SEG_DIG4	Digit 4 of the numeric display from the left	7
SEG_A	Segment A of the numeric display	138
SEG_B	Segment B of the numeric display	142
SEG_C	Segment C of the numeric display	9
SEG_D	Segment D of the numeric display	11
SEG_E	Segment E of the numeric display	12
SEG_F	Segment F of the numeric display	139
SEG_G	Segment G of the numeric display	8
SEG_DP	Segment DP of the numeric display	10
2.5	Monochrome LEDs
The Runber board features 8 LEDs for IO control, as well as a power indicator at the side of the micro USB socket (POWER) and a loading indicator below the crystal oscillator (U27) (DONE).
The 8 controllable LEDs can be lightened at high level. The circuit diagram and the connection of the pins are shown below:
 
Signal	Description	Gowin pin
LED1	Control signal of LED1	23
LED2	Control signal of LED2	24
LED3	Control signal of LED3	25
LED4	Control signal of LED4	26
LED5	Control signal of LED5	27
LED6	Control signal of LED6	28
LED7	Control signal of LED7	29
LED8	Control signal of LED8	30
2.6	RGB LEDs
The Runber board features 4 common anode RGB LEDs; the corresponding color of the LED will light up when the control IO is at low level.
    
Signal	Description	Gowin pins
G_LED1	Control signal of G_LED1	114
B_LED1	Control signal of B_LED1	113
R_LED2	Control signal of R_LED2	112
G_LED2	Control signal of G_LED2	111
B_LED2	Control signal of B_LED2	110
R_LED2	Control signal of R_LED2	106
G_LED3	Control signal of G_LED3	104
B_LED3	Control signal of B_LED3	102
R_LED3	Control signal of R_LED4	101
G_LED4	Control signal of G_LED4	100
B_LED4	Control signal of B_LED4	99
R_LED4	Control signal of R_LED4	98
2.7	DIP switch
The Runber board features an 8-digit DIP switch. The circuit design is that the IO can recognize low level by default, and we get high level when the switch gets through. The circuit is shown below:
 
The connection of the pins is shown in the table below:
Signal	Description	Gowin pins
SW1	Control signal of SW1	75
SW2	Control signal of SW2	76
SW3	Control signal of SW3	78
SW4	Control signal of SW4	79
SW5	Control signal of SW5	80
SW6	Control signal of SW6	81
SW7	Control signal of SW7	82
SW8	Control signal of SW8	83
2.8	Keys
The Runber board features 8 soft touch keys. The circuit design is that the IO can recognize high level by default, and we get low level when the key is pressed down. The circuit is shown below:
 
The connection of the pins is shown in the table below:
Signal	Description	Gowin pin
KEY1	Control signal of KEY1	58
KEY2	Control signal of KEY2	59
KEY3	Control signal of KEY3	60
KEY4	Control signal of KEY4	61
KEY5	Control signal of KEY5	62
KEY6	Control signal of KEY6	63
KEY7	Control signal of KEY7	64
KEY8	Control signal of KEY8	65
2.9	Expansion IO
The Runber board reserves 2 set of 2.54mm pin headers (20 pins) for expansion by the user. The connection of the circuit is shown below:
                 
J1 is to the left of the numeric display. The MSPI_CLK, MSPI_CS, MSPI_MOSI and MSPI_MISO connected to J1 are special pins use to connect externally mounted FLAH, which can be set as regular IO. The process of setting up in the project is shown below:
(1) Open the project configuration;
 
(2) Select Dual-Purpose Pin under Place&Route, and then tick Use MSPI as regular IO.
 
The connection of the pins of J1 is shown below:
Signal	Description	Gowin pin
A3V3_1A	Pin for 3.3V power (the first from the end of the numeric display)	
GPIO38	Expansion IO	38
GPIO39	Expansion IO	39
GPIO40	Expansion IO	40
GPIO41	Expansion IO	41
GPIO42	Expansion IO	42
GPIO43	Expansion IO	43
GPIO44	Expansion IO	44
GPIO66	Expansion IO	66
GPIO67	Expansion IO	67
GPIO68	Expansion IO	68
GPIO69	Expansion IO	69
GPIO70	Expansion IO	70
GPIO71	Expansion IO	71
GPIO72	Expansion IO	72
MSPI_CLK	SPI clock pin when used as MSPI connector	96
MSPI_CS	SPI enable pin when used as MSPI connector	95
MSPI_MOSI	SPI output pin when used as MSPI connector	94
MSPI_MISO	SPI input pin when used as MSPI connector	93
GND	Ground pin	
J2 is to the right of the numeric display (the side of LED), with the 1st pin at the end of the numeric display and the 20th at the end of the key. The pins connected to gowin are numbered in the same way as the signal; the input for VBUS signal is 5V.
The connection of the pins of J2 is shown below:
Signal	Description	Gowin pin
VBUS	Pin for 5V power (the first from the end of the numeric display)	
GPIO136	Expansion IO	136
GPIO135	Expansion IO	135
GPIO134	Expansion IO	134
GPIO133	Expansion IO	133
GPIO132	Expansion IO	132
GPIO131	Expansion IO	131
GPIO130	Expansion IO	130
GPIO129	Expansion IO	129
GPIO128	Expansion IO	128
GPIO123	Expansion IO	123
GPIO122	Expansion IO	122
GPIO121	Expansion IO	121
GPIO120	Expansion IO	120
GPIO119	Expansion IO	119
GPIO118	Expansion IO	118
GPIO117	Expansion IO	117
GPIO116	Expansion IO	116
GPIO115	Expansion IO	115
GND	Ground pin	
2.10	Connection to external power supply for Runber
When used as a module, the Runber can be powered in 2 ways:
(1) 5V power for Runber via Pin1 of J2;
(2) 3.3V power for Runber via Pin1 of J1.
Note: Runber can function when powered in either of the above ways.
