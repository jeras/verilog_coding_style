//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

interface wbn_if #(
  parameter string MODE = "NONE", // modes "MASTER", "SLAVE"
  parameter int    AW   = 32,     // address width
  parameter int    DW   = 32,     // data width
  parameter int    SW   = DW/8    // byte select width
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

generate

if (MODE == "MASTER") begin: m

  initial begin
    cyc = 1'b0;
  end

  task trn (
    input  logic          trn_wen,
    input  logic [AW-1:0] trn_adr,
    input  logic [SW-1:0] trn_sel,
    input  logic [DW-1:0] trn_dtw,
    output logic [DW-1:0] trn_dtr,
    output logic          trn_err
  );
    // start cycle
    cyc   = 1'b1;
    stb   = 1'b1;
    we    = trn_wen;
    adr   = trn_adr;
    sel   = trn_sel;
    dat_w = trn_dtw;
    // wait for acknowledge/error/retry response
    do @ (posedge clk);
    while (~(ack | err | rty));
    // read data and status
    trn_dtr = dat_r;
    trn_err = err | rty;
    cyc   = 1'b0;
    stb   = 1'b0;
  endtask: trn

end: m

endgenerate

endinterface: wbn_if
