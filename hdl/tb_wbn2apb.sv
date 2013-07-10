//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module tb_wbn2apb #(
  parameter int AW = 32,  // address width
  parameter int DW = 32,  // data width
  parameter int SW = DW/8 // byte select width
);

//////////////////////////////////////////////////////////////////////////////
// local signals
//////////////////////////////////////////////////////////////////////////////

// system signals
logic          clk = 1;  // clock
logic          rst = 1;  // reset
// Wishbone 3 slave port (to be driven by an external master)
logic          wbn_cyc  ;  // cycle
logic          wbn_we   ;  // write enable
logic          wbn_stb  ;  // transfer strobe
logic [AW-1:0] wbn_adr  ;  // address
logic [SW-1:0] wbn_sel  ;  // byte select
logic [DW-1:0] wbn_dat_w;  // data write
logic [DW-1:0] wbn_dat_r;  // data read
logic          wbn_ack  ;  // acknowledge
logic          wbn_err  ;  // error
logic          wbn_rty  ;  // retry
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

//////////////////////////////////////////////////////////////////////////////
// clock, reset and stimuli
//////////////////////////////////////////////////////////////////////////////

always #5ns clk = ~clk;

initial begin
  repeat (4) @ (posedge clk);
  rst = 1'b0;
  repeat (4) @ (posedge clk);
  $finish();
end

//////////////////////////////////////////////////////////////////////////////
// DUT instance
//////////////////////////////////////////////////////////////////////////////

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
