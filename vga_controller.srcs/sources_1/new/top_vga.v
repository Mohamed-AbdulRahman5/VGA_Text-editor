`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2023 01:43:58 AM
// Design Name: 
// Module Name: top_vga
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


module top_vga(
    // input ports
    input clk,       // clock signal
    input reset,     // reset signal
    input up,        // up pushbutton signal
    input down,      // down pushbutton signal
    input left,      // left pushbutton signal
    input right,     // right pushbutton signal
    input rx,        // video data signal

    // output ports
    output [11:0] rgb,   // RGB color output
    output full,         // frame buffer full signal
    output H_sync,       // horizontal sync signal
    output V_sync        // vertical sync signal
);

    // wire signals for debounced pushbuttons
    wire up_tick, down_tick, left_tick, right_tick;

    // instantiate VGA controller module
    vga_controller vga_ctrl_top(
        .clk(clk),
        .reset(reset),
        .up(up_tick),
        .down(down_tick),
        .left(left_tick),
        .right(right_tick),
        .rx(rx),
        .rgb(rgb),
        .full(full),
        .H_sync(H_sync),
        .V_sync(V_sync)
    );

    // instantiate debounce modules for pushbuttons
    debounce_chu up_pb(
        .clk(clk),
        .reset(reset),
        .sw(up),
        .db_tick(up_tick)
    );
    debounce_chu down_pb(
        .clk(clk),
        .reset(reset),
        .sw(down),
        .db_tick(down_tick)
    );
    debounce_chu right_pb(
        .clk(clk),
        .reset(reset),
        .sw(right),
        .db_tick(right_tick)
    );
    debounce_chu left_pb(
        .clk(clk),
        .reset(reset),
        .sw(left),
        .db_tick(left_tick)
    );
    
    
endmodule
