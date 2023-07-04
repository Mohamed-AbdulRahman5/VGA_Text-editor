`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: mohamed abdulrahman 
/*
 * VGA synchronization circuit module
 *based on IBM standard 
 *
 * This module generates the necessary signals to drive a VGA display. It takes in a clock signal
 * (`clk`) and a reset signal (`reset`) and outputs several signals that control the display: the
 * current pixel location (`p_x` and `p_y`), the horizontal sync signal (`H_sync`), the vertical sync
 * signal (`V_sync`), and a video on/off signal (`video_on`).
 *
 * Parameters:
 *  - `H`: the total number of pixels per line (default: 800)
 *  - `V`: the total number of lines per frame (default: 525)
 *  - `HD`: the number of pixels per line displayed on the screen (default: 640)
 *  - `VD`: the number of lines displayed on the screen (default: 480)
 *  - `HF`: the number of pixels in the horizontal front porch (default: 16)
 *  - `HB`: the number of pixels in the horizontal back porch (default: 48)
 *  - `HT`: the number of pixels in the horizontal retrace (default: 96)
 *  - `VF`: the number of lines in the vertical front porch (default: 10)
 *  - `VB`: the number of lines in the vertical back porch (default: 33)
 *  - `VT`: the number of lines in the vertical retrace (default: 2)
 *
 * Inputs:
 *  - `clk`: the clock signal
 *  - `reset`: the reset signal (active low)
 *
 * Outputs:
 *  - `p_x`: the current pixel location (width: `$clog2(H)`)
 *  - `p_y`: the current line location (height: `$clog2(H)`)
 *  - `H_sync`: the horizontal sync signal
 *  - `V_sync`: the vertical sync signal
 *  - `video_on`: the video on/off signal
 */

// Define the module with the specified parameters and input/output ports
module vga_sync#(
  parameter H=800, // Total number of pixels per line (default: 800)
  parameter V=525, // Total number of lines per frame (default: 525)
  parameter HD=640, // Number of pixels per line displayed on the screen (default: 640)
  parameter VD=480, // Number of lines displayed on the screen (default: 480)
  parameter HF=16, // Number of pixels in the horizontal front porch (default: 16)
  parameter HB=48, // Number of pixels in the horizontal back porch (default: 48)
  parameter HT=96, // Number of pixels in the horizontal retrace (default: 96)
  parameter VF=10, // Number of lines in the vertical front porch (default: 10)
  parameter VB=33, // Number of lines in the vertical back porch (default: 33)
  parameter VT=2 // Number of lines in the vertical retrace (default: 2)
)(
  input clk, // Clock signal 100 MHz
  input reset, // Reset signal 
  output [$clog2(H)-1:0] p_x, // Current pixel location (width: `$clog2(H)`)
  output [$clog2(H)-1:0] p_y, // Current line location (height: `$clog2(H)`)
  output H_sync, // Horizontal sync signal
  output V_sync, // Vertical sync signal
  output video_on // Video on/off signal
);

  // Define registers to store the current pixel location and output signals
  reg [$clog2(H)-1:0] p_x_reg, p_y_reg;
  reg [$clog2(H)-1:0] p_x_next, p_y_next;
  reg H_sync_reg, V_sync_reg, video_on_reg;
  reg H_sync_next, V_sync_next, video_on_next;
  reg H_end, V_end;
  reg [1:0] counter;
  reg clk_25 ;

/// clock dividing section 
always @(posedge clk ) begin
  if (reset) begin
    counter <= 0;
    clk_25 <= 1'b0;
  end else begin
    counter <= counter + 1;
    clk_25  <= &counter;// to make the width of the clk_25 is 1 clock cycle 
  end
end

  // Update the registers on every clock edge and reset
  always @(posedge clk) begin
    if (reset) begin
      p_x_reg <= 0;
      p_y_reg <= 0;
      H_sync_reg <= 0;
      V_sync_reg <= 0;
      video_on_reg <= 0;
    end else if (clk_25) begin // make the divided clock as enable signal 
       p_x_reg <= p_x_next;
       p_y_reg <= p_y_next;
       H_sync_reg <= H_sync_next;
       V_sync_reg <= V_sync_next;
       video_on_reg <= video_on_next;
     end else begin
       p_x_reg <= p_x_reg;
       p_y_reg <= p_y_reg;
       H_sync_reg <= H_sync_reg;
       V_sync_reg <= V_sync_reg;
      video_on_reg <= video_on_reg;
  end
  end

  // Update the current pixel location and output signals on every clock edge
  always @* begin
    // Reset the status signals 
    H_end = 0;
    V_end = 0;
    // to avoid latches
    p_x_next = p_x_reg;
    p_y_next = p_y_reg;
      // Update the next pixel location based on the current pixel location and VGA timing parameters
    if (H_end) begin
      p_x_next = 0;
      if (V_end) begin
        p_y_next = 0;
      end else begin
        p_y_next = p_y_reg + 1;
      end
    end else begin
      p_x_next = p_x_reg + 1;
    end

    // Update the horizontal and vertical sync signals based on the current pixel location and VGA timing parameters
    H_sync_next = ((p_x_reg < (HD + HF - 1)) || (p_x_reg >= (HD + HF + HT - 1)));
    V_sync_next = ((p_y_reg < (VD + VF - 1)) || (p_y_reg >= (VD + VF + VT - 1)));

    // Update the video on/off signal based on the current pixel location and VGA timing parameters
    video_on_next = ((p_y_reg < VD) && (p_x_reg < HD));

    // Update the status signals based on the current pixel location
    H_end = (p_x_reg == H - 1);
    V_end = (p_y_reg == V - 1);
  end

  // Assign the output signals to their respective output ports
  // buffering the outputs 
  assign p_x = p_x_reg;
  assign p_y = p_y_reg;
  assign H_sync = H_sync_reg;
  assign V_sync = V_sync_reg;
  assign video_on = video_on_reg;

endmodule
