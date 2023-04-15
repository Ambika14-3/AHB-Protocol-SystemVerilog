`timescale 1ns/1ns


 
`define NON_SEQ     2'b10
`define SEQ 	    2'b11
`define BUSY 	    2'b01
`define IDLE        2'b00
 
`define OKAY  1'b0
`define ERROR 1'b1



module ahb_slave_tb();

reg hclk;
reg hresetn;
reg hsel;
reg [31:0] haddr;
reg hwrite;
reg [2:0] hsize;
reg [2:0] hburst;
//reg [3:0] hprot;
reg [1:0] htrans;
//reg hmastlock;
reg hready;
reg [31:0] hwdata;
//wire hreadyout;
wire hresp;
wire [31:0] hrdata;


initial begin
  hclk = 0;
  hresetn = 1;
  hsel = 0;
  haddr = 32'd0;
  hwrite = 1;
  hburst = 3'b001;
 // hprot = 0;
  hsize = 0;
  /////////////////////////////////
  htrans = `NON_SEQ;
  ////////////////////////////////////
 // hmastlock = 0;
//  hready = 1;
  hwdata = 32'd0;
  
  #10 $monitor("-------------------everything reset---------------------");

       hresetn = 0;
       
       
  #10 hresetn = 1;
  
  
//  repeat(2)
//  @(posedge hclk);
  
//   hsel = 1;
//  haddr = 0;
//  hwrite = 1'b1;
//  hwdata = 8;
//  hready = 1;
  
  
  
  //#20 ;
  
//  repeat(2)
//  @(posedge hclk);
  
//  hsel = 1;
// // haddr = addr;
// haddr = 0;
//  hwrite = 1'b0;
//  hready = 1;
  
  // burst: incr
  //burst_incr_wr();




  // basic write and read
 // basic_wr();

  // Wait state write and read
  //wr_wait_state();

  // burst: incr
  //burst_incr_wr();

  // burst wrap 4
  burst_wrap4(32'd1);

  // burst incr 4
 // burst_incr4();

#80 ;
$finish;


end


always #2 hclk <= ~hclk;
//----------------------------------------------------
// Normal write and read
//----------------------------------------------------
task write(input [31:0] addr, input [31:0] data);
begin
  repeat(2)
  @(posedge hclk)
  hsel = 1;
  haddr = addr;
  hwrite = 1'b1;
  hwdata = data;
  hready = 1;
  //@(posedge hclk)
//  hsel = 0;
end
endtask

task read(input [31:0] addr);
begin
  repeat(2)
  @(posedge hclk)
  hsel = 1;
  haddr = addr;
 //haddr = 0;
  hwrite = 1'b0;
  hready = 1;
 // @(posedge hclk)
 // hsel = 0;
end
endtask


//----------------------------------------------------
// Burst
//----------------------------------------------------

// Incr
task burst_incr_wr();
begin
  hburst = 3'b001;
  hsel= 1;
  htrans = `NON_SEQ;
  write(32'd1,32'd1);
  
   htrans = `SEQ;
  write(32'd1,32'd2);
  write(32'd1,32'd3);
  write(32'd1,32'd4);
  hburst = 3'b000;
  
//   repeat(3)
//  @(posedge hclk)
  hsel=0;
  #4
  hsel=1;
  htrans = `NON_SEQ;
  hburst = 3'b001;
  
  
  read(32'd1);
  
   htrans = `SEQ;
  read(32'd1);
  read(32'd1);
  read(32'd1);
  hburst = 3'b000;
end
endtask


//Wrap 4
task burst_wrap4(input [31:0] addr);
begin
//  // write
  htrans = `NON_SEQ;
  @(posedge hclk);
  
  write(32'd1,32'd1);
  
  hburst = 3'b010;
 // htrans = `NON_SEQ;
 // write(32'd1,32'd1);
  
  htrans = `SEQ;
   @(posedge hclk);
  write(32'd1,32'd2);
  write(32'd1,32'd3);
  write(32'd1,32'd4);
  write(32'd1,32'd5);
  write(32'd1,32'd6);
  write(32'd1,32'd7);
  write(32'd1,32'd8);
  write(32'd1,32'd9);
  write(32'd1,32'd10);
  
  //@(posedge hclk);
  
  htrans = `NON_SEQ;
   @(posedge hclk);
  read(32'd1);
  hburst = 3'b010;
  
  htrans = `SEQ;
   @(posedge hclk);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
  read(32'd1);
//  repeat(2)
//  @(posedge hclk)
  
//    hburst = 3'b010;
//  hsel = 1'b1;
//  hwrite = 1'b1;
//  haddr = addr;

//  hready = 1'b1;
//  @(posedge hclk)
//  hwdata = 32'd1;
//  @(posedge hclk)
//  hwdata = 32'd2;
//  @(posedge hclk)
//  hwdata = 32'd3;
//  @(posedge hclk)
//  hwdata = 32'd4;
//  @(posedge hclk)
//  hwdata = 32'd5;
//  @(posedge hclk)
//  hwdata = 32'd6;
//  @(posedge hclk)
//  hsel = 1'b0;
//  hwrite = 1'b0;
//  hburst = 3'b000;
  
//  // read
//  @(posedge hclk)
//  hburst = 3'b010;
//  hsel = 1'b1;
//  hwrite = 1'b0;
//  haddr = addr;
//  hready = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  hburst = 3'b000;
end
endtask

//// Incr 4
//task burst_incr4();
//begin
//  // write
//  @(posedge hclk)
//  hburst = 3'b011;
//  hsel = 1'b1;
//  hwrite = 1'b1;
//  haddr = 32'd1;
//  hready = 1'b1;
//  @(posedge hclk)
//  hwdata = 32'd1;
//  @(posedge hclk)
//  hwdata = 32'd2;
//  @(posedge hclk)
//  hwdata = 32'd3;
//  @(posedge hclk)
//  hwdata = 32'd4;
//  @(posedge hclk)
//  hsel = 1'b0;
//  hwrite = 1'b0;
//  hburst = 3'b000;
  
//  // read
//  @(posedge hclk)
//  hburst = 3'b011;
//  hsel = 1'b1;
//  hwrite = 1'b0;
//  haddr = 32'd1;
//  hready = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  @(posedge hclk)
//  hsel = 1'b1;
//  @(posedge hclk)
//  hsel = 1'b0;
//  hburst = 3'b000;
//end
//endtask


////----------------------------------------------------
//// Basic
////----------------------------------------------------
//task basic_wr();
//begin
//  hburst = 3'b000;
//  write(32'd0,32'd100);
  
//  repeat(6)
//  @(posedge hclk)
  
//  read(32'd0);
  
//  repeat(6)
//  @(posedge hclk)
//  ;
  
////  write(32'd1,32'd1);
////  read(32'd1);
////  write(32'd2,32'd2);
////  read(32'd2);
////  write(32'd3,32'd3);
////  read(32'd3);
////  write(32'd4,32'd4);
////  write(32'd5,32'd5);
////  write(32'd6,32'd6);
////  read(32'd4);
////  read(32'd5);
////  read(32'd6);
//end
//endtask

//task wr_wait_state();
//begin
//  hburst = 3'b000;
//  write_wait_state(32'd7,32'd7);
//  read_wait_state(32'd7);
//  write_wait_state(32'd8,32'd8);
//  read_wait_state(32'd8);
//  read_wait_state(32'd7);
//end
//endtask



//task write_wait_state(input [31:0] addr, input [31:0] data);
//begin
//  @(posedge hclk)
//  hsel = 1;
//  haddr = addr;
//  hwrite = 1'b1;
//  hwdata = data;
//  hready = 0;
//  @(posedge hclk)
//  hready = 0;
//  @(posedge hclk)
//  hready = 1;
//  @(posedge hclk)
//  hsel = 0;
//end
//endtask

//task read_wait_state(input [31:0] addr);
//begin
//  @(posedge hclk)
//  hsel = 1;
//  haddr = addr;
//  hwrite = 1'b0;
//  hready = 0;
//  @(posedge hclk)
//  hready = 0;
//  @(posedge hclk)
//  hready = 1;
//  @(posedge hclk)
//  hsel = 0;
//end
//endtask



ahb_slave uut(
  .clk(hclk),
  .hresetn(hresetn),
  .hsel(hsel),
  .haddr(haddr),
  .hwrite(hwrite),
  .hsize(hsize),
  .hburst(hburst),
 // .hprot(hprot),
  .htrans(htrans),
 // .hmastlock(hmastlock),
  .hready(hready),
  .hwdata(hwdata),
 // .hreadyout(hreadyout),
  .hresp(hresp),
  .hrdata(hrdata)
);

endmodule