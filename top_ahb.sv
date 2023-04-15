`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2023 09:07:57
// Design Name: 
// Module Name: top_ahb
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


module top_ahb(
input clk,
input hresetn,
input enable,


input [31:0] in_hwdata,
input [31:0] in_haddr, 
input [2:0] in_hsize,
input [2:0] in_hburst,
input [1:0] in_hsel,
input in_hwrite,
input [1:0] in_htrans,
 
//output logic [31:0] hwdata,
//output logic [31:0] haddr, 
//output logic [2:0] hsize,
//output logic [2:0] hburst,
//output logic [1:0]hsel,
//output logic hwrite,
//output logic [1:0] htrans,

output [31:0] out_hrdata
);

wire hresp;
wire hresp1;
wire hresp2;
wire hresp3;
wire hresp4;

wire hready;
wire hready1;
wire hready2;
wire hready3;
wire hready4;

wire [31:0] hrdata;
wire [31:0] hrdata1;
wire [31:0] hrdata2;
wire [31:0] hrdata3;
wire [31:0] hrdata4;

wire hsel1;
wire hsel2;
wire hsel3;
wire hsel4;

wire [31:0] hwdata;
wire [31:0] haddr; 
wire [2:0] hsize;
wire [2:0] hburst;
wire [1:0]hsel;
wire hwrite;
wire [1:0] htrans;     

ahb_master master(
.clk(clk),
.hresetn(hresetn),
.enable(enable),

.hresp(hresp),
.hready(hready),
.hrdata(hrdata),

.in_hwdata(in_hwdata),
.in_haddr(in_haddr),
.in_hsize(in_hsize),
.in_hburst(in_hburst),
.in_hsel(in_hsel),
.in_hwrite(in_hwrite),
.in_htrans(in_htrans),

.hwdata(hwdata),
.haddr(haddr),
.hsize(hsize),
.hburst(hburst),
.hsel(hsel),
.hwrite(hwrite),
.htrans(htrans),

.out_hrdata(out_hrdata)
);

mux mux1(
.hrdata_1(hrdata1),
.hrdata_2(hrdata2),
.hrdata_3(hrdata3),
.hrdata_4(hrdata4),

.hready_1(hready1),
.hready_2(hready2),
.hready_3(hready3),
.hready_4(hready4),

.hresp_1(hresp1),
.hresp_2(hresp2),
.hresp_3(hresp3),
.hresp_4(hresp4),

.sel(hsel),

.hrdata(hrdata),
.hready(hready),
.hresp(hresp)

);

decoder decoder1(
.hsel(hsel),
.hsel_1(hsel1),
.hsel_2(hsel2),
.hsel_3(hsel3),
.hsel_4(hsel4)
);
    
ahb_slave slave_1(
.clk(clk),
.hwdata(hwdata),
.haddr(haddr),
.hsize(hsize),
.hburst(hburst),
.hresetn(hresetn),
.hsel(hsel1),
.hwrite(hwrite),
//.hreadyout()
.htrans(htrans),

.hresp(hresp1),
.hready(hready1),
.hrdata(hrdata1)

);

ahb_slave slave_2(
.clk(clk),
.hwdata(hwdata),
.haddr(haddr),
.hsize(hsize),
.hburst(hburst),
.hresetn(hresetn),
.hsel(hsel2),
.hwrite(hwrite),
//.hreadyout()
.htrans(htrans),

.hresp(hresp2),
.hready(hready2),
.hrdata(hrdata2)

);

ahb_slave slave_3(
.clk(clk),
.hwdata(hwdata),
.haddr(haddr),
.hsize(hsize),
.hburst(hburst),
.hresetn(hresetn),
.hsel(hsel3),
.hwrite(hwrite),
//.hreadyout()
.htrans(htrans),

.hresp(hresp3),
.hready(hready3),
.hrdata(hrdata3)
 
);

ahb_slave slave_4(
.clk(clk),
.hwdata(hwdata),
.haddr(haddr),
.hsize(hsize),
.hburst(hburst),
.hresetn(hresetn),
.hsel(hsel4),
.hwrite(hwrite),
//.hreadyout()
.htrans(htrans),

.hresp(hresp4),
.hready(hready4),
.hrdata(hrdata4)

);


endmodule
