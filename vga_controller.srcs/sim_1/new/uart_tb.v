`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2023 12:45:03 AM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(   );



 localparam D_bits=9 ,B_bits =10 ,sb_tick =16;
 
             reg clk,reset_n;            
             //reciever ports 
              reg rx;
              reg rd_uart;
              wire  [D_bits-2:0] data_r;
              wire rx_empty,rx_err, rx_done, fr_err ;
              wire rx_full ;
             // baud 
             reg [B_bits-1:0] baud_final;
             reg fetch;
             reg[11:0] addr_r_in=0 ;
             reg[11:0] addr_w_in =0;

UART #(
   .D_bits(D_bits),
   .B_bits(B_bits),
   .sb_tick(sb_tick)
) UART_TB (
   .clk(clk),
   .reset_n(reset_n),
   // reciever
   .rx(rx),
   .rd_uart(rd_uart),
   .data_r(data_r),
   .rx_empty(rx_empty),
   .rx_full(rx_full),
   .rx_err(rx_err),
   .rx_done(rx_done),
   .fr_err(fr_err),
   .baud_final(baud_final),
    //vga
   .fetch(fetch),
   .addr_r_in(addr_r_in),
   .addr_w_in(addr_w_in)
);



    
 initial
 begin 
   baud_final=650; // value for baud rate 9600
 clk=0;
 reset_n=1 ;
 rx=1;
 rd_uart=0;
 
 end   
  //reset block  
initial begin
  reset_n=0;
 @(negedge clk) reset_n=1;
 end   
//clock gen block
always #5 clk =~clk;



//reciever block

initial begin 

// freeze state
#5 rx =1;
// start bit
#10 rx =0;
// data bits 11100110 
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


end







    

endmodule
