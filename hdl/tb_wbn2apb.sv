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
wbn_if #(.MODE ("MASTER"), .AW (AW), .DW (DW)) wbn (.clk (clk), .rst (rst));
// AMBA 3 APB 2 master port (to drive an external slave)
apb_if #(.MODE ("SLAVE" ), .AW (AW), .DW (DW)) apb (.clk (clk), .rst (rst));

// bus cycle status signals
logic          trn_wen;
logic [AW-1:0] trn_adr;
logic [SW-1:0] trn_sel;
logic [DW-1:0] trn_dtw;
logic [DW-1:0] trn_dtr;
logic          trn_err;

//////////////////////////////////////////////////////////////////////////////
// clock, reset and stimuli
//////////////////////////////////////////////////////////////////////////////

always #5ns clk = ~clk;

initial begin
  repeat (4) @ (posedge clk);
  rst = 1'b0;
  repeat (4) @ (posedge clk);
  fork
    begin: m
      wbn.m.trn (1'b1, 32'h00001004, 4'hf, 32'h01234567, trn_dtr, trn_err);
    end: m
    begin: s
      apb.s.trn (trn_wen, trn_adr, trn_sel, trn_dtw, 32'h89abcdef, 1'b0);
    end: s
  join
  repeat (4) @ (posedge clk);
  $stop();
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
  .wbn_cyc      (wbn.cyc  ),
  .wbn_we       (wbn.we   ),
  .wbn_stb      (wbn.stb  ),
  .wbn_adr      (wbn.adr  ),
  .wbn_sel      (wbn.sel  ),
  .wbn_dat_w    (wbn.dat_w),
  .wbn_dat_r    (wbn.dat_r),
  .wbn_ack      (wbn.ack  ),
  .wbn_err      (wbn.err  ),
  .wbn_rty      (wbn.rty  ),
  // AMBA 3 APB 2 master port (to drive an external slave)
  .apb_penable  (apb.penable),
  .apb_pwrite   (apb.pwrite ),
  .apb_pstrb    (apb.pstrb  ),
  .apb_paddr    (apb.paddr  ),
  .apb_psel     (apb.psel   ),
  .apb_pwdata   (apb.pwdata ),
  .apb_prdata   (apb.prdata ),
  .apb_pready   (apb.pready ),
  .apb_pslverr  (apb.pslverr)
);

////////////////////////////////////////////////////////////////////////////////
// waveform related code
////////////////////////////////////////////////////////////////////////////////

initial begin
  $timeformat (-9,1," ns",0);
  $dumpfile ("wbn2apb.vcd");
  $dumpvars(0);
end

endmodule: tb_wbn2apb
