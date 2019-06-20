set root_dir [file dirname [file dirname [file dirname [file normalize [info script]]]]]
set ip_name "benchmark"
set module_name "payload_generator"
cd $ip_name
open_project $module_name
set_top $module_name
add_files $root_dir/../../src/$ip_name/$module_name.cpp
add_files $root_dir/../../src/$ip_name/util.cpp
open_solution "solution1"
set_part {xczu19eg-ffvc1760-2-i} -tool vivado
create_clock -period 3.103 -name default
config_rtl -reset all
csynth_design
export_design
