`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2023 11:01:45 PM
// Design Name: 
// Module Name: rx
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


module rx#(parameter D_bits=9 ,
    parameter sb_tick =16
)(          input clk,  reset_n,
            input rx,
            input s_tick,
            output[D_bits-2:0] data_out,
            output reg rx_done,
            output reg rx_err,// parity error
            output reg fr_err//framing error

    );
    
    localparam  idle = 0, start = 1,
                    data = 2, stop = 3;
  reg [D_bits - 2:0] b_reg, b_next;   // the register of the data shifted in    without the parity                               
 reg [1:0] state_reg, state_next; // the track of state
 reg [$clog2(D_bits)-1 :0] n_reg, n_next;// number of bits shifted in+ parity bit 
 reg [$clog2(sb_tick) - 1:0] s_reg, s_next;   //baud rate 
 reg parity_reg,parity_next;// generated parity inside rx
 
 
 
 // states reg 
 always@(posedge clk, negedge reset_n)begin 
        if (~reset_n)
         begin
             state_reg <= idle;
             s_reg <= 0;
             n_reg <= 0;
             b_reg <= 0;
             parity_reg <=0;
             rx_done <= 1'b0; 
             fr_err <= 1'b0;
             rx_err <= 1'b0;
         end
        else  begin
                 state_reg <= state_next;
                 s_reg <= s_next;
                 n_reg <= n_next;
                 b_reg <= b_next;
                 parity_reg <=parity_next;
              end
    end
    
    // next logic
    always@(*) begin
     state_next <= state_reg;
     parity_next <= parity_reg;
           s_next <= s_reg;
           n_next <= n_reg;
           b_next <= b_reg;
           rx_done <= 1'b0; 
           fr_err <= 1'b0;
           rx_err <= 1'b0;
         
     case(state_reg)
        idle:    
          if(~rx) begin
        
            state_next <= start;
            parity_next<=0;
             s_next<=0;
                    end
            else      state_next <= state_reg;    
          
        start:
          if(s_tick) 
            if(s_reg==7) 
            if(~rx) begin
               s_next <=0;
               n_next<=0;
               state_next <= data;
               end
            else   state_next = idle;
            else s_next <=s_reg+1;
            else  state_next <= state_reg;
        data:    
          if(s_tick) begin    
            if(s_reg==15) begin 
             if(n_reg==D_bits-1)
              begin
                rx_err <= ~(parity_reg== rx);
                 n_next<=0;
                 s_next<=0;
                 state_next <=stop;
                    end
             else begin    s_next<=0;
                 b_next <= {rx,b_reg[D_bits-2:1]};//shifting right  
                 parity_next <= parity_reg ^ rx;  
                  n_next <=n_reg+1;  end//else for n_reg != d_bits            
             end
            else s_next <=s_reg+1;//else for s_reg=!15
              end 
              else  state_next <= state_reg;
        stop:
            if(s_tick)
              if(s_reg == sb_tick-1)
               begin
              if(~rx) fr_err <= 1'b1;
              else  fr_err <= 1'b0;
              state_next <= idle;
              rx_done <= 1'b1;
              
               end
             
               else  s_next <= s_reg+1;
               else  state_next <= state_reg;
             default:
                           state_next <= idle;
       endcase   
      end
    
    assign data_out= b_reg;
    
    
endmodule
