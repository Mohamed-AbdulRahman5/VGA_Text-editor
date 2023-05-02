module cursor_move (
   input clk, reset,                 // clock and reset inputs
   input [6:0] p_x,                    // current pixel x coordinate
   input [4:0] p_y,                    // current pixel y coordinate
   input up, down, left, right,        // movement control inputs
   output reg fetch,                       // fetch signal output
   output reg cursor_on,                   // cursor-on signal output
   output [11:0] addr_w                // address write output
);
  
    reg [6:0] cur_x_reg, p_x_1; // current cursor x coordinate and pixel coordinate registers
    reg [6:0] cur_x_next;              // next cursor x coordinate register
    reg [4:0] cur_y_reg, p_y_1; // current cursor y coordinate and pixel coordinate registers
    reg [4:0] cur_y_next;              // next cursor y coordinate register
    wire fetch_next;
    wire cursor_on_next;
    
    parameter MAX_X = 80;   // 640 pixels / 8 data bits = 80, maximum x coordinate
    parameter MAX_Y = 30;   // 480 pixels / 16 data rows = 30, maximum y coordinate
  
  
    always @(posedge clk ) begin
        if (reset) begin
            cur_x_reg <= 0;           // reset cursor x coordinate
            cur_y_reg <= 0;           // reset cursor y coordinate
            p_x_1 <= 0;               // reset pixel x coordinate register 1
            p_y_1 <= 0;               // reset pixel y coordinate register 1
            fetch <=0;
            cursor_on <=0;
        end
        else begin
            cur_x_reg <= cur_x_next;   // update cursor x coordinate
            cur_y_reg <= cur_y_next;   // update cursor y coordinate
            p_x_1 <= p_x;             // update pixel x coordinate register 1
            p_y_1 <= p_y;             // update pixel y coordinate register 1
            fetch <= fetch_next;
            cursor_on <=cursor_on_next;
        end
    end
  
  
    // move vertical logic
    always @(*) begin
        case ({down, up})
            2'b00: cur_y_next = cur_y_reg;                       // no movement
            // move up
            2'b01: begin 
                     if (cur_y_reg == 0) 
                         cur_y_next = cur_y_reg;                  // already at top, no movement
                     else 
                         cur_y_next = cur_y_reg - 1;              // move up
                   end
            // move down        
            2'b10: begin 
                     if (cur_y_reg == MAX_Y-1) 
                         cur_y_next = cur_y_reg;                  // already at bottom, no movement
                     else 
                         cur_y_next = cur_y_reg + 1;              // move down
                   end         
            2'b11: cur_y_next = cur_y_reg;                        // no movement
        endcase
    end
  
  
    // move Horizontal logic
    always @(*) begin
        case ({right, left})
            2'b00: cur_x_next = cur_x_reg;                       // no movement
            // move left
            2'b01: begin 
                     if (cur_x_reg == 0) 
                         cur_x_next = cur_x_reg;                  // already at left edge, no movement
                     else 
                         cur_x_next = cur_x_reg - 1;              // move left
                   end
            // move right        
            2'b10: begin 
                     if (cur_x_reg == MAX_X-1) 
                         cur_x_next = cur_x_reg;                  // already at right edge, no movement
                     else 
                         cur_x_next = cur_x_reg + 1;              // move right
                   end         
            2'b11: cur_x_next = cur_x_reg;                        // no movement
        endcase
    end
  
  
    //output signals
    // the address write 
    assign addr_w = {cur_y_reg, cur_x_reg};                       // update address write output
    assign fetch_next = up | down | left | right;                      // update fetch output
    assign cursor_on_next = (p_y_1 == cur_y_reg) && (p_x_1 == cur_x_reg); // update cursor-on output
  
endmodule