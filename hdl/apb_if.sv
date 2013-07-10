//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

interface apb_if #(
  parameter int AW = 32,  // address width
  parameter int DW = 32,  // data width
  parameter int SW = DW/8 // byte select width
)(
  // system signals
  input logic clk,  // clock
  input logic rst   // reset
);

// AMBA 3 APB 2 master port (to drive an external slave)
logic          apb_penable;  // transfer enable
logic          apb_pwrite ;  // write enable
logic          apb_pstrb  ;  // transfer strobe
logic [AW-1:0] apb_paddr  ;  // address
logic [SW-1:0] apb_psel   ;  // byte select
logic [DW-1:0] apb_pwdata ;  // data write
logic [DW-1:0] apb_prdata ;  // data read
logic          apb_pready ;  // transfer ready
logic          apb_pslverr;  // slave error

modport master (
  output apb_penable,
  output apb_pwrite ,
  output apb_pstrb  ,
  output apb_paddr  ,
  output apb_psel   ,
  output apb_pwdata ,
  input  apb_prdata ,
  input  apb_pready ,
  input  apb_pslverr
);

modport slave (
  input  apb_penable,
  input  apb_pwrite ,
  input  apb_pstrb  ,
  input  apb_paddr  ,
  input  apb_psel   ,
  input  apb_pwdata ,
  output apb_prdata ,
  output apb_pready ,
  output apb_pslverr
);

endinterface: apb_if
