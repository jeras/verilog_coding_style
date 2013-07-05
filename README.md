Verilog Coding Style
====================

The next list of coding style rules is based on common practices and on my experience.

List of Verilog HDL coding style rules.
0. use spaces (not tabs), for indention
1. hierarchically constructed signal names
2. vertically alligned code
3. short blocks of code
The reasoning behind each rule is explained below.

All the examples are written in *Verilog 2001/2005* and *SystemVerilog 2012*, using as many relevant features as possible. The most inportant feature (relevant to coding style) introduced in Verilog 2001 are *ANSI style headers*, and in SystemVerilog *structures* and *interfaces*. Here the importance is measured by how much this features affect the generic look of the code, and the listed features drasticly reduce visible text redundancy.

Indention (Spaces vs. Tabs)
------------------------------

I am not going to discuss it. Many developers have strong personal preferences here, so lets just say I like my code to look the same on all editors, web interfaces, ...

The two largest public codebases I know use a different indention size:
1. OpenRisc CPU () is using 2 spaces
2. The UVM library is using 3 spaces

I will explain this later, but since in RTL it is prefered to have short blocks of code (the whole block fitting on screen) the indention of 2 spaces is usually large enough to follow it from the `begin` to `end`.

Hierarchically Constructed Names
--------------------------------

This is the most important rule, since it will gretely affect usability.

Signal names should make it evident how signals are hierarchically grouped in a design. Related signals are grouped together by prepending the group name to the signal name. The same prepended name can also be used for other related signals not strictly in the group but should not be used for unrelated signals. Distinct signal groups with same or similar members should have different names prepended to them.

The main purpose of group names is to be able to search for related signals in a source file. There are two reasons why the group name is prepended instead of appended:
1. the group is well visible in a vertically alligned list, it is also easy to edit the group name using vertical editing modes
2. simulators list signals in alphabetic order, signals prepened with the same name are listed together

In the next example wishbone signals are prepended with the group denominator `wbn_`.

    wire          wbn_cyc  ,  // cyc_i -- cycle
    wire          wbn_we   ,  // we_i  -- write enable
    wire          wbn_stb  ,  // stb_i -- strobe
    wire [AW-1:0] wbn_adr  ,  // adr_i -- address
    wire [SW-1:0] wbn_sel  ,  // sel_i -- byte select
    wire [DW-1:0] wbn_dat_w,  // dat_i -- data write
    wire [DW-1:0] wbn_dat_r,  // dat_o -- data read
    wire          wbn_ack  ,  // ack_o -- acknowledge
    wire          wbn_err  ,  // err_o -- error
    wire          wbn_rty  ,  // rty_o -- retry

Note there are no appended strings describing if a signal is in input (`_i`) or an output (`_o`), they cause issues when copying vertical blocks of code to a different context (from a master port to a slave port).
This appendices are part of the Wishbone standard, but they do not make sense if the signals are not module ports, but instead are used to connect two modules on the same hierarchical level. The biggest issue with the Wishbone standard naming are the data signals. The input output naming does not make much sense on the interconnect level, while describibg the data signals are write (`dat_w`) or read (`dat_r`) makes sense on any level. 

Such hierarchical order is also common with structures and classes in various languages, imaging replacing the separator `_` (underscore) with `.` (dot).

Fot those who think this rule is not important, please check a comment by Sir Tim Berners-Lee regarding URL.
http://www.w3.org/People/Berners-Lee/FAQ.html#etc

Vertical Code Alignment
-----------------------

Code for a group of related signals should be vertically alligned. The main reason here is the verbosity of Verilog code, where there is no way to manipulate (use as ports, or in assignments) groups of signals, instead each element of the group must be written separately. SystemVerilog offers structures and interfaces which reduce this kind of verbosity. Another source of verbosity are port connections. While it is possible like in C to just list the ports in correct order, this is rarely used, instead ports are usually connected by name.

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


Code Block Size
---------------

HDL RTL synthesizes into hardware where all combinatorial and sequential logic is running simultaneously inside a clock period. So in a simulator all lines of code will get executed at the same time, not line by line, as is common with computer languages. In a computer language a debugger stops a line of code inside the source,

In practice this means that in a large block of code, for example an always statement, the developer can not focus on a few lines of code inside a longe
