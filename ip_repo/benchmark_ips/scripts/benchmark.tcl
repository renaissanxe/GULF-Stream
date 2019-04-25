set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "GULFStream_benchmark"
source ${project_dir}/scripts/util.tcl

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name

set_property ip_repo_paths "${project_dir}/../" [current_project]
update_ip_catalog -rebuild

addip payload_generator payload_generator_0
addip payload_validator payload_validator_0
addip PSInterface PSInterface_0
addip util_vector_logic util_vector_logic_0
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_0]

make_bd_pins_external  [get_bd_pins payload_validator_0/ap_clk]
make_bd_pins_external  [get_bd_pins payload_generator_0/ready_V]
make_bd_pins_external  [get_bd_pins payload_generator_0/m_axis_data_V]
make_bd_pins_external  [get_bd_pins payload_generator_0/m_axis_keep_V]
make_bd_pins_external  [get_bd_pins payload_generator_0/m_axis_last_V]
make_bd_pins_external  [get_bd_pins payload_generator_0/m_axis_valid_V]
make_bd_pins_external  [get_bd_pins payload_validator_0/s_axis_data_V]
make_bd_pins_external  [get_bd_pins payload_validator_0/s_axis_keep_V]
make_bd_pins_external  [get_bd_pins payload_validator_0/s_axis_last_V]
make_bd_pins_external  [get_bd_pins payload_validator_0/s_axis_valid_V]
make_bd_pins_external  [get_bd_pins PSInterface_0/ip_V]
make_bd_pins_external  [get_bd_pins PSInterface_0/gateway_V]
make_bd_pins_external  [get_bd_pins PSInterface_0/netmask_V]
make_bd_pins_external  [get_bd_pins PSInterface_0/mac_V]
make_bd_intf_pins_external  [get_bd_intf_pins PSInterface_0/s_axi_AXILiteS]
set_property name clk [get_bd_ports ap_clk_0]
foreach port [get_bd_ports *_V_0] {
        set_property name [regsub "_V_0" [regsub "/" $port ""] ""] $port
}
set_property name AXILITE_Config [get_bd_intf_ports s_axi_AXILiteS_0]

connect_bd_net [get_bd_ports clk] [get_bd_pins PSInterface_0/ap_clk]
connect_bd_net [get_bd_ports clk] [get_bd_pins payload_generator_0/ap_clk]
connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins PSInterface_0/ap_rst_n]
connect_bd_net [get_bd_pins PSInterface_0/rst_V] [get_bd_pins payload_generator_0/ap_rst]
connect_bd_net [get_bd_pins PSInterface_0/rst_V] [get_bd_pins payload_validator_0/ap_rst]
connect_bd_net [get_bd_pins PSInterface_0/rst_V] [get_bd_pins util_vector_logic_0/Op1]
connect_bd_net [get_bd_pins PSInterface_0/start_V] [get_bd_pins payload_generator_0/start_V]
connect_bd_net [get_bd_pins PSInterface_0/pkt_num_V] [get_bd_pins payload_generator_0/packet_num_V]
connect_bd_net [get_bd_pins payload_generator_0/payload_len_V] [get_bd_pins PSInterface_0/pkt_len_V]
connect_bd_net [get_bd_pins payload_validator_0/latency_sum_V] [get_bd_pins PSInterface_0/latency_sum_V]
connect_bd_net [get_bd_pins payload_validator_0/time_elapse_V] [get_bd_pins PSInterface_0/rx_timeElapse_V]
connect_bd_net [get_bd_pins payload_generator_0/time_elapse_V] [get_bd_pins PSInterface_0/tx_timeElapse_V]
connect_bd_net [get_bd_pins payload_generator_0/counter_out_V] [get_bd_pins payload_validator_0/counter_in_V]
connect_bd_net [get_bd_pins payload_validator_0/packet_num_V] [get_bd_pins PSInterface_0/pkt_num_V]
connect_bd_net [get_bd_pins payload_generator_0/done_V] [get_bd_pins PSInterface_0/tx_done_V]
connect_bd_net [get_bd_pins payload_validator_0/done_V] [get_bd_pins PSInterface_0/rx_done_V]
connect_bd_net [get_bd_pins payload_validator_0/error_V] [get_bd_pins PSInterface_0/rx_error_V]
connect_bd_net [get_bd_pins payload_validator_0/curr_cnt_V] [get_bd_pins PSInterface_0/rx_cnt_V]

assign_bd_address [get_bd_addr_segs {PSInterface_0/s_axi_AXILiteS/Reg }]
save_bd_design

make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v

ipx::package_project -root_dir $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name} -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]

ipx::remove_bus_interface user_GULF_stream_config [ipx::current_core]
ipx::add_bus_interface payload_m_axis [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property display_name payload_m_axis [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property physical_name m_axis_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property physical_name m_axis_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property physical_name m_axis_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property physical_name m_axis_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]
set_property physical_name ready [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces payload_m_axis -of_objects [ipx::current_core]]]

ipx::add_bus_interface payload_s_axis [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:aximm_rtl:1.0 [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:aximm:1.0 [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property display_name payload_s_axis [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces payload_s_axis -of_objects [ipx::current_core]]]

ipx::add_bus_interface GULFStream_config [ipx::current_core]
set_property abstraction_type_vlnv clarkshen.com:user:GULF_stream_config_rtl:1.0 [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property bus_type_vlnv clarkshen.com:user:GULF_stream_config:1.0 [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property display_name GULFStream_config [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
ipx::add_port_map myIP [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property physical_name ip [ipx::get_port_maps myIP -of_objects [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]]
ipx::add_port_map myMac [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property physical_name mac [ipx::get_port_maps myMac -of_objects [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]]
ipx::add_port_map netmask [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property physical_name netmask [ipx::get_port_maps netmask -of_objects [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]]
ipx::add_port_map gateway [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]
set_property physical_name gateway [ipx::get_port_maps gateway -of_objects [ipx::get_bus_interfaces GULFStream_config -of_objects [ipx::current_core]]]

ipx::associate_bus_interfaces -busif payload_s_axis -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif payload_m_axis -clock clk [ipx::current_core]

set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property ip_repo_paths "${project_dir}/../../" [current_project]
update_ip_catalog
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}_1.0.zip [ipx::current_core]
close_project
exit
