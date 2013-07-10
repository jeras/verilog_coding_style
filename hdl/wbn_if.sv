//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

interface wbn_if #(
  parameter int AW = 32,  // address width
  parameter int DW = 32,  // data width
  parameter int SW = DW/8 // byte select width
)(
  // system signals
  input logic clk,  // clock
  input logic rst   // reset
);

// Wishbone 3 slave port (to be driven by an external master)
logic          cyc  ;  // cycle
logic          we   ;  // write enable
logic          stb  ;  // transfer strobe
logic [AW-1:0] adr  ;  // address
logic [SW-1:0] sel  ;  // byte select
logic [DW-1:0] dat_w;  // data write
logic [DW-1:0] dat_r;  // data read
logic          ack  ;  // acknowledge
logic          err  ;  // error
logic          rty  ;  // retry

modport master (
  output cyc  ,
  output we   ,
  output stb  ,
  output adr  ,
  output sel  ,
  output dat_w,
  input  dat_r,
  input  ack  ,
  input  err  ,
  input  rty
);

modport slave (
  input  cyc  ,
  input  we   ,
  input  stb  ,
  input  adr  ,
  input  sel  ,
  input  dat_w,
  output dat_r,
  output ack  ,
  output err  ,
  output rty
);

endinterface: wbn_if
