module wbn2apb #(
  parameter integer AW = 32,  // address width
  parameter integer DW = 32,  // data width
  parameter integer SW = DW/8 // byte select width
)(
  // system signals
  input  wire          clk,  // clock
  input  wire          rst,  // reset
  // Wishbone 3 slave port (to be driven by an external master)
  input  wire          wbn_cyc  ,  // cycle
  input  wire          wbn_we   ,  // write enable
  input  wire          wbn_stb  ,  // transfer strobe
  input  wire [AW-1:0] wbn_adr  ,  // address
  input  wire [SW-1:0] wbn_sel  ,  // byte select
  input  wire [DW-1:0] wbn_dat_w,  // data write
  input  wire [DW-1:0] wbn_dat_r,  // data read
  output wire          wbn_ack  ,  // acknowledge
  output wire          wbn_err  ,  // error
  output wire          wbn_rty  ,  // retry
  // AMBA 3 APB 2 master port (to drive an external slave)
  output wire          apb_penable,  // transfer enable
  output wire          apb_pwrite ,  // write enable
  output wire          apb_pstrb  ,  // transfer strobe
  output wire [AW-1:0] apb_paddr  ,  // address
  output wire [SW-1:0] apb_psel   ,  // byte select
  output wire [DW-1:0] apb_pwdata ,  // data write
  input  wire [DW-1:0] apb_prdata ,  // data read
  input  wire          apb_pready ,  // transfer ready
  input  wire          apb_pslverr   // slave error
);

endmodule
