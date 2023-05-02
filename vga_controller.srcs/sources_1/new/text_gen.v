`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2023 03:27:13 PM
// Design Name: 
// Module Name: text_gen
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
/*The text_gen module generates RGB color values for displaying ASCII text on a video display. 
The module has the following inputs and outputs:

Inputs:

clk: The clock signal.
video_on: The video enable signal that indicates when to display video output.
x: The horizontal pixel position of the current character being displayed.
rom_data: The ASCII data from ROM.
cursor_on: The cursor enable signal that indicates when to display a cursor.
Outputs:

rgb: The RGB color value for the current pixel.
The module reads ASCII data from a ROM and generates the corresponding RGB color values for each pixel of the display.
 The RGB color values are stored in a register rgb_reg and are updated every clock cycle based on the input signals.

The bit_addr register keeps track of the current bit address for reading the ASCII word bitmap.
the bit addr is delayed 2 cycles due to the rom data delay as it will take a one clock 
to get the char of the fifo memory and a second to get the data from the ascii rom

The module generates RGB color values based on the following conditions:

If video_on is low, output black color.
If cursor_on is high, output inverse color (black or white) based on the current bit value from the ASCII word bitmap.
If cursor_on is low, output green color for a high bit value in the ASCII word bitmap and black color for a low bit value.
The rgb_next register stores the next RGB color value to be output, based on the current state of the input signals.
 The rgb output is updated every clock cycle with the value of rgb_reg.

*/
//////////////////////////////////////////////////////////////////////////////////

module text_gen(
    input clk,         // clock input
    input video_on,    // video enable signal
    input [2:0] x,     // horizontal pixel position
    input [7:0] rom_data,   // ASCII data from ROM
    input cursor_on,   // cursor enable signal
    output  [11:0] rgb // output RGB color
);

    reg [11:0] rgb_reg;    // current RGB color value stored in register
    reg [11:0] rgb_next;   // next RGB color value
    reg ascii_bit;         // current bit value from ASCII word bitmap
    reg [2:0] bit_addr;    // current bit address for reading ASCII word bitmap
    reg [2:0] bit_addr_next;    // next bit address for reading ASCII word bitmap
    
    // register block  
   always@(posedge clk)
    begin
    rgb_reg<= rgb_next;
    bit_addr_next <= x;
    // delay the bit addr 2 cycles untill reading char and next reading ascii word bitmap
    bit_addr <= bit_addr_next;
    end
   
    // body
    always @* begin
        ascii_bit = rom_data[~bit_addr];    // read current bit from ASCII word bitmap
        
        if (~video_on) begin
            rgb_next = 12'h000;             // if video is disabled, output black color
        end
        else begin
            if (cursor_on) begin
                rgb_next = (ascii_bit) ? 12'h000 : 12'h0F0;   // if cursor is enabled, output inverse color
            end
            else begin
                rgb_next = (ascii_bit) ? 12'h0F0 : 12'h000;   // if cursor is disabled, output green color
            end
        end
    end
  
    assign rgb = rgb_reg;   // buffer  RGB color value to output
  
endmodule
