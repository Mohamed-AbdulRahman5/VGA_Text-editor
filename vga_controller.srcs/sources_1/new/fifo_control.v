`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 12:12:10 AM
// Design Name: 
// Module Name: fifo_control
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
/*
The fifo_control module is a synchronous FIFO controller that handles read and write operations to a memory buffer.
 The module has the following inputs and outputs:


Inputs:

clk: The clock signal.
reset: The reset signal that clears the FIFO buffer and resets the module to its initial state.
rd: The read enable signal that enables the read operation.
wr: The write enable signal that enables the write operation.
fetch: The fetch signal that indicates a new data word is ready to be written into the FIFO buffer.
addr_w_in: The input address for the next write operation.
addr_r: The current read address.
Outputs:

addr_w: The next write address.
full: The full flag that indicates the FIFO buffer is full.
empty: The empty flag that indicates the FIFO buffer is empty.
we_enable: The write enable signal that controls the write operation.
rd_enable: The read enable signal that controls the read operation.
The fifo_control module has a memory buffer with a fixed size determined by the addr_size parameter.
 The word_width parameter specifies the width of each data word.

The module implements a state machine to handle the read and write operations. 
The state machine has four states, which correspond to the four possible combinations of the rd and wr inputs:


rd=0, wr=0: Idle state. The module waits for a read or write operation to be enabled.
rd=0, wr=1: Write state. The module writes the data word at the current write address and increments the write address.
 If the FIFO buffer is full, the write operation is disabled.
rd=1, wr=0: Read state. The module reads the data word at the current read address and increments the read address. 
If the FIFO buffer is empty, the read operation is disabled.
rd=1, wr=1: Error state. This state should not occur and is ignored by the module.
The fifo_control module also keeps track of the full and empty flags to indicate the state of the FIFO buffer. 
The we_enable and rd_enable signals are generated based on the full and empty flags and the wr and rd inputs.
*/
//////////////////////////////////////////////////////////////////////////////////


module fifo_control
#(
parameter addr_size=4,
 word_width=8
)(
input clk,                         // clock input
input reset,                       // reset input
input rd,                          // read enable input
input wr,                          // write enable input
input fetch,                       // fetch input
input [addr_size-1:0] addr_w_in,   // write address input
input [addr_size-1:0] addr_r,      // read address input
output [addr_size-1:0] addr_w,     // write address output
output reg full,                   // full flag output
output reg empty,                  // empty flag output
output we_enable,                  // write enable output
output rd_enable                   // read enable output
    );
    
    reg [addr_size:0] next_addr_w, next_addr_r ;
    reg [addr_size:0] addr_w_buff ;
    reg  addr_r_c ;
    wire full_buff, empty_buff;
    
    
    always@(posedge clk) begin
    if(reset) begin
     addr_w_buff <=0;
     full <=0;
     empty <=1;
     addr_r_c <=0;
    end
    else begin   
    full <=full_buff;
    empty <=empty_buff;
    addr_r_c <=next_addr_r[addr_size];
    if(fetch)
         addr_w_buff <=addr_w_in ;
    else addr_w_buff <= next_addr_w; 
    end
    end 
    
    
    ///nest state logic
    
    always@(*)begin
    next_addr_w =addr_w_buff;
   next_addr_r ={addr_r_c,addr_r};   
 
    case({wr,rd})
    2'b00: begin
     next_addr_w =addr_w_buff;
    next_addr_r ={addr_r_c,addr_r};
 
        end
    2'b01: begin
                     if(~empty) begin   // FIFO not empty
                         next_addr_r={addr_r_c,addr_r}+1;
                         next_addr_w =addr_w_buff;
                    end
                    end
     2'b10: begin
                 if(~full) begin 
                        // FIFO not full
                      next_addr_w = addr_w_buff+1;
                      next_addr_r ={addr_r_c,addr_r};
                                    end
              end
    2'b11:begin 
             if(~empty)    // FIFO not empty
                next_addr_r={addr_r_c,addr_r}+1;      
                 else  next_addr_r ={addr_r_c,addr_r};                         
                   if(~full)    // FIFO not full
                   next_addr_w= addr_w_buff+1;
                   else next_addr_w =addr_w_buff;
                             end
    default : begin    next_addr_w =addr_w_buff;
                        next_addr_r ={addr_r_c,addr_r}; end                      
    endcase
    end
    
    
    ///
   ///write and read enable condition 
     assign empty_buff = (next_addr_r == addr_w_buff) ? 1:0;
     assign full_buff = (addr_r_c != next_addr_w[addr_size])&&(next_addr_w[addr_size-1:0] == addr_r)? 1:0;
     assign we_enable =wr&(!full);
     assign  rd_enable=rd&(!empty) ;
     
     
     
     // output
      assign addr_w= addr_w_buff[addr_size-1:0];
endmodule
