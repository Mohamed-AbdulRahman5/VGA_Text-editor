module timer #(parameter bits=10 )(
input clk ,
input enable,
input reset,
input [bits-1:0]final,
output tkl 

); 
 

reg   [bits:0 ] Q_next , Q_reg;
//counter register 
always @(posedge clk  )
 begin
 if(reset)
   Q_reg <= 0;
   else if(enable)
     Q_reg <= Q_next;
   end 
   
   //output logic
 assign   tkl = (Q_reg==final) ;
 //nex state logic 
 always @(*)
 Q_next <= tkl? 0: (Q_reg+1) ;
 
 endmodule 