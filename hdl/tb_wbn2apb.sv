module tb_wbn2apb #(
  parameter integer AW = 32,  // address width
  parameter integer DW = 32,  // data width
  parameter integer SW = DW/8 // byte select width
);

// system signals
wire          clk,  // clock
wire          rst,  // reset
// Wishbone 3 slave port (to be driven by an external master)
wire          wbn_cyc  ,  // cycle
wire          wbn_we   ,  // write enable
wire          wbn_stb  ,  // transfer strobe
wire [AW-1:0] wbn_adr  ,  // address
wire [SW-1:0] wbn_sel  ,  // byte select
wire [DW-1:0] wbn_dat_w,  // data write
wire [DW-1:0] wbn_dat_r,  // data read
wire          wbn_ack  ,  // acknowledge
wire          wbn_err  ,  // error
wire          wbn_rty  ,  // retry
// AMBA 3 APB 2 master port (to drive an external slave)
wire          apb_penable,  // transfer enable
wire          apb_pwrite ,  // write enable
wire          apb_pstrb  ,  // transfer strobe
wire [AW-1:0] apb_paddr  ,  // address
wire [SW-1:0] apb_psel   ,  // byte select
wire [DW-1:0] apb_pwdata ,  // data write
wire [DW-1:0] apb_prdata ,  // data read
wire          apb_pready ,  // transfer ready
wire          apb_pslverr   // slave error

wbn2apb #(
  .AW (AW),
  .DW (DW),
  .SW (SW)
) dut (
  // system signals
  .clk          (clk),
  .rst          (rst),
  // Wishbone 3 slave port (to be driven by an external master)
  .wbn_cyc      (wbn_cyc  ),
  .wbn_we       (wbn_we   ),
  .wbn_stb      (wbn_stb  ),
  .wbn_adr      (wbn_adr  ),
  .wbn_sel      (wbn_sel  ),
  .wbn_dat_w    (wbn_dat_w),
  .wbn_dat_r    (wbn_dat_r),
  .wbn_ack      (wbn_ack  ),
  .wbn_err      (wbn_err  ),
  .wbn_rty      (wbn_rty  ),
  // AMBA 3 APB 2 master port (to drive an external slave)
  .apb_penable  (apb_penable),
  .apb_pwrite   (apb_pwrite ),
  .apb_pstrb    (apb_pstrb  ),
  .apb_paddr    (apb_paddr  ),
  .apb_psel     (apb_psel   ),
  .apb_pwdata   (apb_pwdata ),
  .apb_prdata   (apb_prdata ),
  .apb_pready   (apb_pready ),
  .apb_pslverr  (apb_pslverr)
);

endmodule
