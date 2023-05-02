`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 10:56:01 PM
// Design Name: 
// Module Name: vga_sync_tb
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




module vga_sync_tb;

// Parameters
parameter H = 800;
parameter V = 525;
parameter HD = 640;
parameter VD = 480;
parameter HF = 16;
parameter HB = 48;
parameter HT = 96;
parameter VF = 10;
parameter VB = 33;
parameter VT = 2;

// Inputs
reg clk=0;
reg reset;

// Outputs
wire [$clog2(H)-1:0] p_x;
wire [$clog2(H)-1:0] p_y;
wire H_sync;
wire V_sync;
wire video_on;

// Instantiate the DUT
vga_sync#(.H(H),
  .V(V),
  .HD(HD),
  .VD(VD),
  .HF(HF),
  .HB(HB),
  .HT(HT),
  .VF(VF),
  .VB(VB),
  .VT(VT)) dut (
  .clk(clk),
  .reset_n(reset),
  .p_x(p_x),
  .p_y(p_y),
  .H_sync(H_sync),
  .V_sync(V_sync),
  .video_on(video_on)
  
);


// Clock generation
always #5 clk = ~clk;

// Reset generation
initial begin
  reset = 0; // Drive reset low to start
  #10 reset = 1; // Release reset after a delay
end
// Stimulus
initial begin
  // Wait for reset to complete
  @(posedge clk);
  @(posedge clk);

  // Verify initial state
  if (p_x !== 0) $error("Initial p_x value is incorrect");
  if (p_y !== 0) $error("Initial p_y value is incorrect");
  if (H_sync !== 0) $error("Initial H_sync value is incorrect");
  if (V_sync !== 0) $error("Initial V_sync value is incorrect");
  if (video_on !== 0) $error("Initial video_on value is incorrect");

  // Wait for one full frame
  repeat (V*H) @(posedge clk);

  // Verify end of frame
  if (p_x !== 0) $error("End of frame p_x value is incorrect");
  if (p_y !== 0) $error("End of frame p_y value is incorrect");
  if (H_sync !== 1) $error("End of frame H_sync value is incorrect");
  if (V_sync !== 1) $error("End of frame V_sync value is incorrect");
  if (video_on !== 0) $error("End of frame video_on value is incorrect");

  $display("Testbench complete");
//  $finish;
end

endmodule
