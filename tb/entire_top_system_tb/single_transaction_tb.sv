`timescale 1ns/1ns


 
`define NON_SEQ     2'b10
`define SEQ 	    2'b11
`define BUSY 	    2'b01
`define IDLE        2'b00
 
`define OKAY  1'b0
`define ERROR 1'b1



module demo_singletrans_tb();

reg clk;
reg hresetn;
reg enable;


reg [31:0] in_hwdata;
reg [31:0] in_haddr; 
reg [2:0] in_hsize;
reg [2:0] in_hburst;
reg [1:0] in_hsel;
reg in_hwrite;
reg [1:0] in_htrans;
 
wire [31:0] out_hrdata;


initial begin
  clk = 0;
  hresetn = 1;
  enable=0;
  in_hsel = 2'bxx;
  in_haddr = 32'd1;
  in_hwrite = 1;
  in_hburst = 3'b001;

  in_hsize = 0;

  in_htrans = `NON_SEQ;


  in_hwdata = 32'd0;
  
  #10 $monitor("-------------------everything reset---------------------");

       hresetn = 0;
       
  #10 hresetn = 1;
  enable=1;
  single_trans(32'd1);
#1

$finish;


end


always #2 clk <= ~clk;

task write(input [31:0] addr, input [31:0] data);
begin
  repeat(2)
  @(posedge clk)
  in_haddr = addr;
  in_hwrite = 1'b1;
  in_hwdata = data;

end
endtask

task read(input [31:0] addr);
begin
  repeat(2)
  @(posedge clk)
  in_haddr = addr;
  in_hwrite = 1'b0;

end
endtask



task single_trans(input [31:0] addr);
begin
  in_hsel=2'bxx;
  enable=0;
  #4
  in_hsel=0;
  enable=1;
  in_hburst = 3'b000;
  in_htrans = `NON_SEQ;
  @(posedge clk);
  
  write(32'd1,32'd1);
  in_hwrite=1'b0;
  @(posedge clk);
  read(32'd1);

//   @(posedge clk);
////  in_htrans = `SEQ;
//  write(32'd1,32'd2);
//  write(32'd1,32'd3);
//  write(32'd1,32'd4);
//  in_hwrite=1'b0;
//  in_htrans = `NON_SEQ;
//   @(posedge clk);
//  read(32'd1);
//  in_hburst = 3'b000;
  
////  in_htrans = `SEQ;
//   @(posedge clk);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
//  read(32'd1);
end
endtask


top_ahb top_ahb1(
.clk(clk),
.hresetn(hresetn),
.enable(enable),


.in_hwdata(in_hwdata),
.in_haddr(in_haddr), 
.in_hsize(in_hsize),
.in_hburst(in_hburst),
.in_hsel(in_hsel),
.in_hwrite(in_hwrite),
.in_htrans(in_htrans),

.out_hrdata(out_hrdata)
);



endmodule
