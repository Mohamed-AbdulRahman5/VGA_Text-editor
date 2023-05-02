`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2023 05:24:29 PM
// Design Name: 
// Module Name: UART
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

/*The UART module is a UART (Universal Asynchronous Receiver/Transmitter) 
that receives serial data, stores it in a FIFO, and outputs the received data on demand.

 The module has the following inputs and outputs:

Inputs:

clk: The clock signal.
reset: The reset signal that clears the state of the UART.
rx: The serial input signal.
rd_uart: The read signal for the UART FIFO.
baud_final: The baud rate clock divider value.
fetch: The fetch signal for the FIFO. 
it forces the data to be written on a specific addr_w 
addr_r_in: The read address for the FIFO.
addr_w_in: The write address for the FIFO. 
the forced address which the data is fetched 
Outputs:

data_r: The received data from the UART FIFO.
rx_empty: A flag that indicates whether the UART FIFO is empty.
rx_full: A flag that indicates whether the UART FIFO is full.
rx_err: A flag that indicates whether a parity error has occurred in the UART receiver.
rx_done: A flag that indicates when the UART has finished receiving data.
fr_err: A flag that indicates whether a framing error has occurred in the UART receiver.
The module uses two sub-modules:

rx: A receiver module that receives serial data and detects errors.
fifo: A FIFO module that stores received data from the UART receiver.
The receiver module outputs the received data in data_out and sets the rx_done, rx_err, and fr_err flags as appropriate. 
The FIFO module stores the received data in data_out when the wr signal is set, and outputs the data stored at the read address addr_r_in on the data_r output.

The module also uses a timer module to generate the baud rate clock signal based on the baud_final input.*/
//////////////////////////////////////////////////////////////////////////////////


module UART#(parameter D_bits=9 ,
    parameter B_bits=10,
    parameter sb_tick =16
)( input clk,
             input reset,
             //reciever ports 
              input rx,
              input rd_uart,
             output [D_bits-2:0] data_r,
             output rx_empty,
             output rx_full,
             output rx_err,//error detection
             output rx_done,
             output fr_err ,
             // baud 
              input [B_bits-1:0] baud_final,
              //vga isignals
              input fetch,
              input [11:0] addr_r_in,
              input [11:0] addr_w_in

    );
     wire parity_bit;
    wire s_tick;
     wire tx_done;
     wire [D_bits-2:0] data_in, data_out ;  



    
    // the reciever fsm
    rx#(.D_bits(D_bits),.sb_tick (sb_tick) ) Uart_reciever 
    (.clk(clk) , 
     .reset(reset),
     .rx(rx),
     .s_tick(s_tick),
     .data_out(data_out),
     .rx_done(rx_done),
     .rx_err(rx_err),
     .fr_err(fr_err)
             );
        
      fifo#(
                   .addr_size(12),
                   .word_width(8)
               ) rx_fifo (
                   .clk(clk),
                   .reset(reset),
                   .rd(rd_uart),
                   .fetch(fetch),
                   .wr(rx_done),
                   .data_in(data_out),
                   .addr_r_in(addr_r_in),
                   .addr_w_in(addr_w_in),
                   .data_out(data_r),
                   .full(rx_full),
                   .empty(rx_empty)
               );
 
    
    
timer #( .bits(B_bits) ) baud_rate (
   .clk(clk) ,
 . enable(1'b1),
     .reset(reset),
   .final(baud_final),
     .tkl (s_tick)
    
    ); 
    
    
    
endmodule
