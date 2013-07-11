//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

interface apb_if #(
  parameter string MODE = "NONE", // modes "MASTER", "SLAVE"
  parameter int    AW   = 32,     // address width
  parameter int    DW   = 32,     // data width
  parameter int    SW   = DW/8    // byte select width
)(
  // system signals
  input logic clk,  // clock
  input logic rst   // reset
);

// AMBA 3 APB 2 master port (to drive an external slave)
logic          penable;  // transfer enable
logic          pwrite ;  // write enable
logic          pstrb  ;  // transfer strobe
logic [AW-1:0] paddr  ;  // address
logic [SW-1:0] psel   ;  // byte select
logic [DW-1:0] pwdata ;  // data write
logic [DW-1:0] prdata ;  // data read
logic          pready ;  // transfer ready
logic          pslverr;  // slave error

generate

if (MODE == "SLAVE") begin: s

  initial begin
    pready = 1'b0;
  end

  task trn (
    output logic          trn_wen,
    output logic [AW-1:0] trn_adr,
    output logic [SW-1:0] trn_sel,
    output logic [DW-1:0] trn_dtw,
    input  logic [DW-1:0] trn_dtr,
    input  logic          trn_err
  );
    wait (penable);
    prdata  = trn_dtr;
    pready  = 1'b1;
    pslverr = trn_err;
    wait (pstrb);
    @ (posedge clk);
    trn_wen = pwrite ;
    trn_adr = paddr  ;
    trn_sel = psel   ;
    trn_dtw = pwdata ;
  endtask: trn

end: s

endgenerate

endinterface: apb_if
