`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2023 11:46:18 PM
// Design Name: 
// Module Name: fifo
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


module fifo#(
parameter addr_size=12,
 word_width=8
)(
     input clk,
     input reset,
     input rd,
     input fetch,
     input wr, 
     input  [word_width-1:0] data_in,
     input  [addr_size-1:0] addr_r_in,
     input  [addr_size-1:0] addr_w_in,//write address
     output [word_width-1:0] data_out,
     output full,
     output empty

    );
    
          //declaration needed  
      wire [addr_size-1:0] addr_w ;
      wire we_enable , rd_enable ;
      
   
    
    fifo_control #(
        .addr_size (addr_size),
        .word_width (word_width)
      ) fifo_inst (
        .clk (clk),
        .reset (reset),
        .rd (rd),
        .wr (wr),
        .fetch(fetch),
        .addr_w_in(addr_w_in),
        .addr_r (addr_r_in),
        .addr_w (addr_w),
        .full (full),
        .empty (empty),
        .we_enable(we_enable),
        .rd_enable(rd_enable)
      );
    
    
     reg_memory_file#(addr_size,word_width) fifo_memory (.we_s(we_enable), .clk(clk),.addr_r(addr_r_in),
             .addr_w(addr_w),.data_w(data_in),.data_r(data_out) ); 
             


endmodule
