HDL = hdl/tb_wbn2apb.sv \
      hdl/wbn_if.sv \
      hdl/apb_if.sv \
      hdl/wbn2apb.v

all: wbn2apb

wbn2apb: $(HDL)
	vlib work
	vlog $(HDL)
	vsim -c -do 'run -all; quit' tb_wbn2apb
