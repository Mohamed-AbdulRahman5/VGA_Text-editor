# # VGA_Text-editor


#  Serial-VGA Text Editor for FPGA-based Video Display System

# Introduction:

This document provides an overview of the Serial-VGA Text Editor project,
 which is a Verilog-based implementation of a VGA video display system for an FPGA-based platform. 
The project includes a `vga_controller` module that controls the position of a cursor on the screen and generates VGA video output. 
The module takes in input signals from pushbuttons and a UART receiver, 
and generates output signals to control the position of the cursor and the video output.

Objectives:

The objectives of the Serial-VGA Text Editor project are as follows:

1. To develop a VGA video display system that can be implemented on an FPGA-based platform.
2. To provide an easy-to-use interface for editing text on the screen.
3. To generate high-quality VGA video output with a resolution of 640x480 pixels and 256 colors.
4. To support input devices such as pushbuttons and a UART receiver for controlling the position of the cursor and editing text on the screen.

Hardware Requirements:

The Serial-VGA Text Editor project requires the following hardware components:

1. An FPGA development board with a VGA output port.
2. A set of pushbuttons for controlling the position of the cursor on the screen.
3. A UART receiver for receiving text input from a computer or other device.

Software Requirements:

The Serial-VGA Text Editor project requires the following software components:

1. A Verilog-based hardware design tool such as Quartus or Vivado.
2. A text editor for editing Verilog code.
3. A computer or other device with a UART interface for sending text input to the FPGA development board.

Design:

The `vga_controller` module is a key component of the Serial-VGA Text Editor project. The module includes several submodules,
 including a cursor move module, an ASCII ROM module, a text generator module, a VGA sync module, a video memory module, and a UART module. 
These submodules work together to control the position of the cursor on the screen, receive text input from a UART receiver, and generate VGA video output.

1. Cursor Move Module:
The cursor move module takes in input signals from pushbuttons and generates output signals to control the position of the cursor on the screen.
 The module includes state machines to handle the different combinations of pushbutton signals and
 to prevent the cursor from moving outside the bounds of the screen. The module also includes a cursor position register
 that stores the current position of the cursor.

2. ASCII ROM Module:
The ASCII ROM module stores the bitmap data for all ASCII characters. The module takes in an address signal that is generated from the video memory module,
 based on the location of the line and the character being displayed. The module generates an output signal for the corresponding bitmap data of the character.
 The char is being chosen from the video memory module based on the line location and horizontal x pixel being displayed.

3. Text Generator Module:
The text generator module reads the bitmap data from the ASCII ROM module and generates the bitmap of the character on the screen when displayed.
 The module takes in input signals from the cursor move module, the VGA sync module, and the video memory module, 
and generates output signals for the RGB color values of the characters.
 The module includes logic to handle the display of the cursor on the screen.

4. VGA Sync Module:
The VGA sync module generates the necessary signals for VGA video output, including the horizontal sync,
 vertical sync, and video enable signals. The module takes in several parameters, including the total number of pixels and horizontal lines in a frame,
 the active horizontal and vertical resolutions, and the timing specifications for the horizontal and vertical sync pulses.
 The module outputs signals including the pixel coordinates (`p_x` and `p_y`), the horizontal and vertical sync signals (`H_sync` and `V_sync`),
 and the video enable signal (`video_on`).

5. Video Memory Module:
The video memory module stores the ASCII code of the characters to be displayed on the screen. 
The module takes in an address signal that is generated based on the tile location, 
which represents an 8x16 block of pixels on the screen. The module generates an output signal for the corresponding ASCII code of the character.

6. UART Module:
The UART module receives text input from a computer or other device through the UART interface. 
The module includes logic to handle the reception and storage of text data, as well as a state machine to handle the different combinations of received characters.
The module outputs signals including the received character (`rx_data`) and a flag signal (`rx_flag`) to indicate when a new character has been received.

The Serial-VGA Text Editor project also includes a top-level module that instantiates the `vga_controller` module and provides input and output ports
 for connecting to other components of the system.

Usage:

The Serial-VGA Text Editor project can be used in a larger hardware project to generate VGA video output and edit text on the screen.
 The module takes in input signals from pushbuttons and a UART receiver and outputs signals for
 the RGB color values of the characters and the VGA video output.

Installation:

To install the Serial-VGA Text Editor project, follow these steps:

1. Install a Verilog-based hardware design tool such as Quartus or Vivado.
2. Download the Verilog source code for the `vga_controller` module and the top-level module.
3. Open the Verilog source code in the hardware design tool.
4. Configure the input and output ports of the top-level module to match the hardware components of your system.
5. Compile the Verilog source code to generate a bitstream file.
6. Transfer the bitstream file to the FPGA development board.
7. Connect the pushbuttons and UART receiver to the input ports of the system.
8. Connect the VGA output port of the FPGA development board to a VGA monitor or other display device.

Limitations:

The Serial-VGA Text Editor project is designed for a specific FPGA development board and may not be compatible with other boards.
 The project is also limited in its resolution and color depth due to the limitations of VGA output.
 The project does not include support for advanced features such as hardware acceleration or audio output.

Future Work:

Future work for the Serial-VGA Text Editor project could include increasing the resolution and color depth of the VGA output,
adding support for advanced features such as hardware acceleration or audio output,
and improving the user interface for editing text on the screen.

