MODELSIM=$(HOME)/altera/13.0sp1/modelsim_ase/bin

HDL = hdl/tb_wbn2apb.sv \
      hdl/wbn_if.sv \
      hdl/apb_if.sv \
      hdl/wbn2apb.v

all: wbn2apb

wbn2apb: $(HDL)
	$(MODELSIM)/vlib work
	$(MODELSIM)/vlog $(HDL)
	$(MODELSIM)/vsim -c -do 'run -all; quit' tb_wbn2apb
