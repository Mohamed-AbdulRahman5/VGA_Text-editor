`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2023 12:49:09 AM
// Design Name: 
// Module Name: debounce_tb
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


module debounce_chu_tb;

	// Inputs
	reg clk;
	reg reset;
	reg sw;

	// Outputs
	wire db_level;
	wire db_tick;

	// Instantiate the Unit Under Test (UUT)
	debounce_chu uut (
		.clk(clk),
		.reset(reset),
		.sw(sw),
		.db_tick(db_tick)
	);

	// Clock period definitions
	parameter PERIOD = 200000000;//200 ms average bush

	// Initial stimulus
	initial begin
		// Initialize inputs
		clk = 0;
		reset = 1;
		sw = 0;

		// Wait for reset to finish
		#2
		reset = 0;

		// Test case 1: Press and release switch
		#PERIOD;
		sw = 1;
		#(PERIOD);
		sw = 0;
		#(PERIOD);

		// Test case 2: Press and hold switch
		sw = 1;
		#(PERIOD*10);

		// Test case 3: Press and release switch quickly
		sw = 1;
		#(PERIOD*0.5);
		sw = 0;
		#(PERIOD);
		sw = 1;
		#(PERIOD*0.5);
		sw = 0;
		#(PERIOD*10);

		// Test case 4: Press and release switch multiple times quickly
		sw = 1;
		#(PERIOD*0.2);
		sw = 0;
		#(PERIOD*0.2);
		sw = 1;
		#(PERIOD*0.2);
		sw = 0;
		#(PERIOD*0.2);
		sw = 1;
		#(PERIOD*0.2);
		sw = 0;
		#(PERIOD*0.2);
		sw = 1;
		#(PERIOD*0.2);
		sw = 0;
		#(PERIOD*10);

		// Finish simulation
		#(PERIOD*1);
		//$finish;
	end

	// Clock generation
	always # 5 clk <= ~clk;

endmodule
