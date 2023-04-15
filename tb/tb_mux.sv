`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2023 22:22:32
// Design Name: 
// Module Name: tb_mux
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



`timescale 1ns/1ns

module tb_mux;

reg [31:0] hrdata1, hrdata2, hrdata3, hrdata4;
reg hreadyout1, hreadyout2, hreadyout3, hreadyout4;
reg hresp1, hresp2, hresp3, hresp4;
reg [1:0] sel;
wire [31:0] hrdata;
wire hreadyout;
wire hresp;

initial begin
  hrdata1 = 32'd1;
  hrdata2 = 32'd2;
  hrdata3 = 32'd3;
  hrdata4 = 32'd4;
  hreadyout1 = 1'b1;
  hreadyout2 = 1'b0;
  hreadyout3 = 1'b1;
  hreadyout4 = 1'b0;
  hresp1 =1;
  hresp2 =0;
  hresp3 =0;
  hresp4 =1;
  sel = 2'b00;
  
  #2 sel = 2'b01;
  #2 sel = 2'b10;
  #2 sel = 2'b11;
end

mux dut(.*);

endmodule
