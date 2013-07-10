Verilog Coding Style
====================

The next list of coding style rules is based on common practices and on my experience.

List of Verilog HDL coding style rules.
 0. use spaces (not tabs), for indention
 1. hierarchically constructed signal names
 2. vertically aligned code
 3. short blocks of code
The reasoning behind each rule is explained below.

All the examples are written in *Verilog 2001/2005* and *SystemVerilog 2012*, using as many relevant features as possible. The most important feature (relevant to coding style) introduced in Verilog 2001 are *ANSI style headers*, and in SystemVerilog *structures* and *interfaces*. Here the importance is measured by how much this features affect the generic look of the code, and the listed features drastically reduce visible text redundancy.

Indention (Spaces vs. Tabs)
------------------------------

I am not going to discuss it. Many developers have strong personal preferences here, so lets just say I like my code to look the same on all editors, web interfaces, ...

The two largest public code-bases I know use a different indention size:
 1. OpenRisc CPU () is using 2 spaces
 2. The UVM library is using 3 spaces

I will explain this later, but since in RTL it is preferred to have short blocks of code (the whole block fitting on screen) the indention of 2 spaces is usually large enough to follow it from the `begin` to `end`.

Hierarchically Constructed Names
--------------------------------

This is the most important rule, since it will greatly affect usability.

Signal names should make it evident how signals are hierarchically grouped in a design. Related signals are grouped together by prepending the group name to the signal name. The same prepended name can also be used for other related signals not strictly in the group but should not be used for unrelated signals. Distinct signal groups with same or similar members should have different names prepended to them.

The main purpose of group names is to be able to search for related signals in a source file. There are two reasons why the group name is prepended instead of appended:
 1. the group is well visible in a vertically aligned list, it is also easy to edit the group name using vertical editing modes
 2. simulators list signals in alphabetic order, signals prepended with the same name are listed together

In the next example wishbone signals are prepended with the group denominator `wbn_`.

```Verilog
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
```

Note there are no appended strings describing if a signal is in input (`_i`) or an output (`_o`), they cause issues when copying vertical blocks of code to a different context (from a master port to a slave port).
This appendices are part of the Wishbone standard, but they do not make sense if the signals are not module ports, but instead are used to connect two modules on the same hierarchical level. The biggest issue with the Wishbone standard naming are the data signals. The input output naming does not make much sense on the interconnect level, while describing the data signals are write (`dat_w`) or read (`dat_r`) makes sense on any level. 

Such hierarchical order is also common with structures and classes in various languages, imaging replacing the separator `_` (underscore) with `.` (dot).

For those who think this rule is not important, please check a comment by Sir Tim Berners-Lee regarding his regrets about URL syntax.
http://www.w3.org/People/Berners-Lee/FAQ.html#etc

Vertical Code Alignment
-----------------------

Code for a group of related signals should be vertically aligned. The main reason here is the verbosity of Verilog code. It is very common to write multiple copies of the same or similar signals. In Verilog where there is no easy way to manipulate groups of signals (to use as ports, or in assignments), instead each element of the group must be written separately. SystemVerilog offers structures and interfaces which reduce this kind of verbosity. Another source of verbosity are port connections. While it is possible (like in C) to just list the ports in correct order, this is rarely used, instead ports are usually connected by name.

```verilog
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
```

Vertically aligned signal groups are easier to distinguish from other signal groups and typos are easier to see (for example wrong prefix in a column of same prefixes). It is possible to use vertical/block editing functionality (copy/paste, insert, ...).  If you do not use vertical editing, you probably should (this links are for VIM, but other editors also support it):
http://vimdoc.sourceforge.net/htmldoc/usr_04.html#04.4
http://vimdoc.sourceforge.net/htmldoc/visual.html#visual-mode

You can see from the example example, alignment is done to the left side, the right side should be filled with whitespace, separators `.`, `,`, `(`, `)`, `{`, `}`, `[`, `]`, ... and operators `+`, `-`, `*`, `=`, `<`, `>`, ... should also be aligned vertically.

Besides my code there are examples of verticel alignment in the UVM code.
http://uvm.git.sourceforge.net/git/gitweb.cgi?p=uvm/uvm;a=blob;f=distrib/examples/simple/registers/primer/reg_model.sv;h=6cf50e0cfbee10619229efc659c117e0c8a8df98;hb=refs/heads/UVM_1_2
http://uvm.git.sourceforge.net/git/gitweb.cgi?p=uvm/uvm;a=blob;f=distrib/examples/simple/registers/common/wishbone/driver.sv;h=8ad98ca927fe35958675844ba606da204dffa231;hb=refs/heads/UVM_1_2

Code Block Size
---------------

HDL RTL synthesizes into hardware where all combinatorial and sequential logic is running simultaneously inside a clock period. So in a simulator all blocks of code will get executed at the same time, not sequentially, line by line, as is common with computer languages. In a computer language a debugger can stop at a line of code inside the source, in HDL it is not as simple, at the same time many lines of code are executed at the same time.

In practice this means that in a large block of code, for example an always statement, the developer can not focus on a few consecutive lines of code, instead the relevant code can be all over the place.

So to avoid too much scrolling related code should be organized into smaller blocks, which can be read without scrolling.
