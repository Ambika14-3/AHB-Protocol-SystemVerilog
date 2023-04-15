`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2023 21:58:43
// Design Name: 
// Module Name: tb_decoder
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


module tb_decoder;
    
    reg [1:0] select;
    wire hsel1, hsel2, hsel3, hsel4;
    
    
    initial begin
         select = 2'b00;
      #2 select = 2'b01;
      #2 select = 2'b10;
      #2 select = 2'b11;
    end
    
    
    decoder dut(.* );
    

endmodule
