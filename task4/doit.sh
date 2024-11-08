#!/bin/sh
#~/Documents/iac/lab0-devtools/tools/attach_usb.sh
# cleanup
rm -rf obj_dir
rm -f counter.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall --cc --trace f1_lights.sv clktick.sv f1_fsm.sv delay.sv lfsr_7.sv --exe f1_lights_tb.cpp

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vf1_lights.mk Vf1_lights


# run executable simulation file
obj_dir/Vf1_lights
