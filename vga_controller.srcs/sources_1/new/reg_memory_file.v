`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 04:25:37 AM
// Design Name: 
// Module Name: reg_memory_file
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


module reg_memory_file#(
parameter addr_size=4,
 word_width=8
)(
    input we_s,//write enable signal 
    input clk,
    input [addr_size-1:0] addr_r,// read address
    input [addr_size-1:0] addr_w,//write address
    input [word_width-1:0] data_w,// data to be written
   output  reg [word_width-1:0] data_r // data to be read
   );
    

    //describing a memory  
   reg [word_width-1:0] reg_mem [0: 2**addr_size -1];
   (* ram_style = "block" *)
   
      // iniaization for sim
       initial begin
       
       $readmemh("char.mem", reg_mem);
   end
    
   
   
   //write operation 
   
   always@(posedge clk) 
   begin
   if(we_s)
   reg_mem[addr_w] <= data_w;
   data_r <= reg_mem[addr_r];
  
   end
   
   // asyn read
   // assign data_r = reg_mem[addr_r];
    
endmodule
