`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2023 01:12:28 AM
// Design Name: 
// Module Name: cursor_tb
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


module tb_cursor_move;

    // Inputs
    reg clk;
    reg reset_n;
    reg [6:0] p_x=0;
    reg [4:0] p_y=0;
    reg up, down, left, right;
    
    // Outputs
    wire fetch;
    wire cursor_on;
    wire [11:0] addr_w;
    
    // Instantiate the module to be tested
    cursor_move dut (
        .clk(clk),
        .reset_n(reset_n),
        .p_x(p_x),
        .p_y(p_y),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .fetch(fetch),
        .cursor_on(cursor_on),
        .addr_w(addr_w)
    );
    
    // Clock generation
    always #10 clk = ~clk;
    
    // x movemetn generation
   
     always @(posedge clk) begin if(reset_n)  p_x = p_x+1;  end
     
      always #1580 begin if(reset_n) p_y = p_y+1; end
    // Initialize inputs
    initial begin
        clk = 1;
        reset_n = 0;
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #100
         reset_n = 1;

    
    // Test scenario
   
        // Move cursor right by one pixel
        up = 0;
        down = 0;
        left = 0;
        right = 1;
        #20;
         // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;       
        // Move cursor right by one pixel
        up = 0;
        down = 0;
        left = 0;
        right = 1;
        #20;
        // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;        
        // Move cursor right by one pixel
        up = 0;
        down = 0;
        left = 0;
        right = 1;
        #20;
         // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;                       
        // Move cursor down by one pixel
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        #20;
         // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;       
        // Move cursor down by one pixel
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        #20;
        // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;        
        // Move cursor down by one pixel
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        #20;
        // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;        
        // Move cursor down by one pixel
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        #20;
        // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;        
        // Move cursor down by one pixel
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        #20;
         // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;                             
        // Move cursor up by one pixel
        up = 1;
        down = 0;
        left = 0;
        right = 0;
        #20;
        
        // Steady cursor movement
        up = 0;
        down = 0;
        left = 0;
        right = 0;
        #20;
        
        // End of test
       // $finish;
    end
    
endmodule
