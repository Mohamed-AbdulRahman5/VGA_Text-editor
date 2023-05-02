

/*The cursor_move module defines a cursor that can be moved vertically and horizontally in a display.
 The module has the following inputs and outputs:

Inputs:

clk: The clock signal.
reset: The reset signal that clears the state of the module.
p_x: The current pixel x-coordinate.
p_y: The current pixel y-coordinate.
up, down, left, right: Movement control inputs.
Outputs:

fetch: A fetch signal that indicates whether the display should fetch data.
cursor_on: A signal that indicates whether the cursor should be displayed.
addr_w: The write address output.


The module uses registers to store the current cursor position and pixel position.
 The module also uses combinatorial logic to determine the next cursor position based on the movement control inputs.

The cursor_move module has three parts:

The top-level always block that updates the registers.
The vertical movement logic that determines the next cursor y-coordinate based on the movement control inputs.
The horizontal movement logic that determines the next cursor x-coordinate based on the movement control inputs.
The top-level always block updates the current cursor position and pixel position registers based on the next cursor position and current pixel position. 
The block also updates the fetch and cursor_on outputs based on the movement control inputs and the current and next cursor positions.

The vertical movement logic determines the next cursor y-coordinate based on the movement control inputs and the current cursor y-coordinate. 
If there is no movement (up and down are both low), the next cursor y-coordinate is the same as the current cursor y-coordinate. 
If up is high and the current cursor y-coordinate is not at the top edge, the next cursor y-coordinate is one less than the current cursor y-coordinate. 
If down is high and the current cursor y-coordinate is not at the bottom edge, the next cursor y-coordinate is one more than the current cursor y-coordinate.

The horizontal movement logic determines the next cursor x-coordinate based on the movement control inputs and the current cursor x-coordinate. 
If there is no movement (left and right are both low), the next cursor x-coordinate is the same as the current cursor x-coordinate.
 If left is high and the current cursor x-coordinate is not at the left edge, the next cursor x-coordinate is one less than the current cursor x-coordinate.
  If right is high and the current cursor x-coordinate is not at the right edge, the next cursor x-coordinate is one more than the current cursor x-coordinate.

The addr_w output is the concatenation of the current cursor y-coordinate and the current cursor x-coordinate. 
The fetch output is high if any of the movement control inputs are high.
 The cursor_on output is high if the current pixel position matches the current cursor position.

*/






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
