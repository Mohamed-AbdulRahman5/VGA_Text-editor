`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 05:13:19 PM
// Design Name: 
// Module Name: fifo_tb
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


module tb_fifo;
    reg clk;
    reg reset_n;
    reg rd;
    reg fetch;
    reg wr;
    reg [7:0] data_in;
    reg [11:0] addr_r_in;
    reg [11:0] addr_w_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    reg [5:0] i;

    // Instantiate the fifo module
    fifo#(
        .addr_size(3),
        .word_width(8)
    ) DUT (
        .clk(clk),
        .reset_n(reset_n),
        .rd(rd),
        .fetch(fetch),
        .wr(wr),
        .data_in(data_in),
        .addr_r_in(addr_r_in),
        .addr_w_in(addr_w_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        rd = 0;
        fetch = 0;
        wr = 0;
        data_in = 0;
        addr_r_in = 0;
        addr_w_in = 0;
        

        // Apply reset
        #10 reset_n = 1;

        // Test case 1: Write and read data, check empty and full flags
        wr = 1;
        rd = 0;
        fetch = 0;
        for (i=0; i< 8; i=i+1) begin
            data_in = i;
            addr_w_in = i;
            #10;
        end
        wr = 0;
        rd = 1;
        for (i=0; i< 8; i=i+1) begin
            addr_r_in = i;
            #10;
            $display("Read data: %0d, Expected data: %0d", data_out, i);
        end

        // Test case 2: Check empty flag
        rd = 1;
        fetch = 0;
        wr = 0;
        #10;
        if (empty) $display("FIFO is empty");
        else $display("FIFO is not empty");

        // Test case 3: Fill the FIFO, check full flag
        wr = 1;
        rd = 0;
        fetch = 0;
        for (i=0; i< 8; i=i+1) begin
            data_in = i % 256;
            addr_w_in = i;
            #10;
        end
        if (full) $display("FIFO is full");
        else $display("FIFO is not full");

        // Test case 4: Read data while FIFO is full
        rd = 1;
        fetch = 0;
        wr = 0;
        for (i=0; i< 8; i=i+1) begin
            addr_r_in = i;
            #10;
            $display("Read data: %0d, Expected data: %0d", data_out, i % 256);
        end

        // Test case 5: Check empty flag after reading all data
        rd = 1;
        fetch = 0;
        wr = 0;
        #10;
        if (empty) $display("FIFO is empty");
        else $display("FIFO is not empty");
          
        // Test case 5: fetch the data to a  addr 
        @(negedge clk)
        rd = 0;
        fetch = 1;
        wr = 1;
        addr_w_in = 4;
        data_in = 22 ;
        @(negedge clk )
        rd = 0;
        fetch = 0;
        wr = 0;
        #10
         
        // Finish simulation
        $finish;
    end
endmodule