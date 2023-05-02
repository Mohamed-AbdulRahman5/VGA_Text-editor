`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 05:36:53 PM
// Design Name: 
// Module Name: vga_tb
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
/*The tb_vga_controller module is a testbench for the vga_controller module. 
The testbench instantiates the vga_controller module and applies stimuli to its inputs to verify its functionality. 
The testbench also generates a clock signal and a reset signal.

The tb_vga_controller module declares the following signals:

clk: a reg signal for the clock signal.
reset: a reg signal for the reset signal.
rgb: a wire signal for the RGB output.
H_sync: a wire signal for the horizontal sync output.
V_sync: a wire signal for the vertical sync output.
rx: a reg signal for the serial input.
up, down, left, right: reg signals for the cursor control inputs.
full: a wire signal for the full output.


The testbench initializes the signals and applies a reset signal to the vga_controller module.
 The rx signal is then set to 1 to freeze the state of the cursor.
  The cursor is then moved to the right by one pixel and a delay of 10ns is applied.

The testbench then begins serial communication by setting rx to 0 to indicate the start bit, 
followed by a series of 8 bits representing the ASCII code for the character '6' and '9', respectively.
 A parity bit of 0 is appended to each character, followed by a stop bit of 1.

After the serial communication, the cursor is moved down by one pixel and a delay of 10ns is applied.
 The testbench then sends the ASCII code for the character 'N' twice using the same serial communication method.

Finally, the testbench generates a vcd file and dumps the variables for waveform analysis.

Overall, this testbench verifies the functionality of the vga_controller module by applying stimuli
 to its inputs and verifying the expected outputs.
*/

// 
//////////////////////////////////////////////////////////////////////////////////



module tb_vga_controller;

  // Declare signals
  reg clk=0;
  reg reset=0;
  //reg [6:0] char;
  wire [11:0] rgb;
  wire H_sync;
  wire V_sync;
  reg rx;
  reg up,down,left,right ;
  wire full;
  // Instantiate vga_controller module
  vga_controller my_vga_controller (
   .clk(clk),
  .reset(reset),
  .up(up),
  .down(down),
  .left(left),
  .right(right),
  .rx(rx),
  .rgb(rgb),
  .full(full),
  .H_sync(H_sync),
  .V_sync(V_sync)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Testbench stimulus
  initial begin
    // Initialize signals
     
    clk = 0;
    
         up = 0;
    down = 0;
    left = 0;
    right = 0;
   // char = 7'h00;
   @(posedge clk)
      reset = 1;
    // Apply reset
    @(posedge clk) reset = 0;
    
// freeze state
@(posedge clk) rx =1;


            // Move cursor right by one pixel
            @(posedge clk)
            up = 0;
            down = 0;
            left = 0;
            right = 1;
            @(posedge clk)
            // Steady cursor movement
            up = 0;
            down = 0;
            left = 0;
            right = 0;
            #10;

// start bit
#10 rx =0;
// 104160 ns is the duration of the single bit
#104160 
// char is 00110110
rx= 0; //lsb first
#104160  
rx= 1;
#104160  
rx= 1;
#104160  
rx= 0;
#104160 
rx= 1;
#104160  
rx= 1;
#104160 
rx= 0;
#104160 
rx= 0;
//parity bit 
#104160  
rx= 0; 
// stop bit 
#104160  
rx= 1;
#104160



 
// start bit
#10 rx =0;
#104160 
// char is 00111001
rx= 1; //lsb first
#104160  
rx= 0;
#104160  
rx= 0;
#104160  
rx= 1;
#104160 
rx= 1;
#104160  
rx= 1;
#104160 
rx= 0;
#104160 
rx= 0;
//parity bit 
#104160  
rx= 0; 
// stop bit 
#104160  
rx= 1;
#104160 
            // Move cursor down by one pixel
          @(posedge clk)
            up = 0;
            down = 1;
            left = 0;
            right = 0;
            @(posedge clk)
            // Steady cursor movement
            up = 0;
            down = 0;
            left = 0;
            right = 0;
            #10;
// start bit
#10 rx =0;
#104160 
// char is 01001110
rx= 0; //lsb first
#104160  
rx= 1;
#104160  
rx= 1;
#104160  
rx= 1;
#104160 
rx= 0;
#104160  
rx= 0;
#104160 
rx= 1;
#104160 
rx= 0;
//parity bit 
#104160  
rx= 0; 
// stop bit 
#104160  
rx= 1;
#104160
// start bit
#10 rx =0;
#104160 
// char is 01001110
rx= 0; //lsb first
#104160  
rx= 1;
#104160  
rx= 1;
#104160  
rx= 1;
#104160 
rx= 0;
#104160  
rx= 0;
#104160 
rx= 1;
#104160 
rx= 0;
//parity bit 
#104160  
rx= 0; 
// stop bit 
#104160  
rx= 1;


   
      $dumpfile("vga.vcd"); 
  $dumpvars(0, tb_vga_controller); 
    
  end
  

  
  

endmodule