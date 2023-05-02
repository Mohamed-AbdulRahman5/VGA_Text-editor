`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 05:13:25 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
       input clk,reset,
       input up, down, left, right,
       input rx,
       output [11:0]rgb,
       output full ,
       output H_sync,V_sync
    );
    
    
    
    
     localparam D_bits=9 ,B_bits =10 ,sb_tick =16, baud_final =650;
    /// decleration needded 
    wire video_on;
    wire [2:0] bit_addr;
    wire [7:0] rom_data;
    wire[9:0] p_x ,p_y;
    wire [10:0] rom_addr;
    wire [3:0] row_addr;
    wire cursor_on;
    wire fetch ;
    wire [7:0] char;
    wire[11:0] char_addr;
    wire[11:0] addr_w_in; 



    /// Instantiate UART module 
    UART #(
  .D_bits(D_bits),
  .B_bits(B_bits),
  .sb_tick(sb_tick)
) uart (
  .clk(clk),
  .reset(reset),
  .rx(rx),
  .rd_uart(video_on),
  .data_r(char),
  .rx_full(full),
  .baud_final(baud_final),
  .fetch(fetch),
  .addr_r_in(char_addr),
  .addr_w_in(addr_w_in)
);
    
    
   // move cusror module 
       cursor_move cursor_inst (
      .clk(clk),
      .reset(reset),
      .p_x(p_x[9:3]),
      .p_y(p_y[8:4]),
      .up(up),
      .down(down),
      .left(left),
      .right(right),
      .fetch(fetch),
      .cursor_on(cursor_on),
      .addr_w(addr_w_in));
    
    
    //Instantiate text_genenrator module
      text_gen my_text_gen (
      .clk(clk),
      .video_on(video_on),
      .x(p_x[2:0]),
      .rom_data(rom_data),
      .cursor_on(cursor_on),
      .rgb(rgb)
    );
    
      // Instantiate vga_sync module
    vga_sync #(.H(800), .V(525),.HD(640),.VD(480),.HF(16),.HB(48),.HT(96),.VF(10),.VB(33),.VT(2))
    my_vga_sync (
      .clk(clk),
      .reset(reset),
      .p_x(p_x),
      .p_y(p_y),
      .H_sync(H_sync),
      .V_sync(V_sync),
      .video_on(video_on)
    );
      // Instantiate ascii_rom module
    ascii_rom my_ascii_rom (
      .clk(clk),
      .addr(rom_addr),
      .data(rom_data)
    );
    
    
    /// 
    assign char_addr ={p_y[8:4], p_x[9:3]};
    assign row_addr = p_y[3:0];
    assign rom_addr ={char,row_addr} ;
    
endmodule
