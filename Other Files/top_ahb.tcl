#Cd to ....../fifo_vls design_database_45nm/synthesis
#Launch Genus using the command: genus -legacy_ui 

#Start typing in the commands from rc_script.tcl one at a time 
#Or To source the whole script file, source <filename.tcl>

#Step1: Set library paths
#rm designs/*    
set_attr init_lib_search_path ../lib/
set_attr hdl_search_path ../rtl/
set_attr library uk65lscllmvbbr_120c25_tc_ccs.lib

#Step 2: Read netlist
read_hdl -sv ahb_master.sv
read_hdl -sv ahb_slave.sv
read_hdl -sv decoder.sv
read_hdl -sv mux.sv
read_hdl -sv top_ahb.sv


set top_module top_ahb.sv

#Step 3: Elaborate/connect all modules
elaborate

# elaborate looks for undefined modules in the directories specified through the -libpath option

#gui_show 
#Check schematic by clicking on + --> Close --> Hide GUI (do not hit exit)
#Step 4: Read constraints
read_sdc ../constraints/top_ahb.sdc
#This is part of sdc: create_clock -name clk -period 2 -waveform {0 1} [get_ports "clk"] --> 2--> ns
#Slack is in ps


#Step 4: Synthesise the  design to generic gates and set the effort level
set_attr syn_generic_effort high
syn_generic

#gui_show
#suspend - to stop here and observe the results


#syn_map: Maps  the  design  to  the  cells  described in the supplied technology library and performs logic optimization.
syn_map

#Step 5: Report results before optimisation
#report_power >power.txt
#gui_show
report_gates 
#suspend

#Step 6: Optimise and run synthesis- key step
#Performs  gate  level  optimization to improve timing on critical paths
set_attr syn_opt_effort high
syn_opt

#Step 7: Report results after optimisation
report_gates 
report_power > power.txt

#Step 8 Check design for timing errors
check_design > design_check.txt
#suspend

#Step 9: Write out synthesised netlist and constraints- important output
write_hdl > hdl_synthesis.v
write_sdc > ./reports/area_opt/top_ahb_demo4.sdc  

#Step 10: Report final results
report_gates > gates.txt
report_area > area.txt
report_power > power.txt
report_timing > timing.txt
#suspend  --> Change constraints --clock, redo read_hdc, syn_generic, syn_map, syn_opt and report_timing --> to check slack.


write_hdl > top_ahb_demo4_netlist.v
write_sdc > top_ahb_demo4.sdc  
write_sdf > top_ahb_demo4.sdf 

#suspend
#write_template -simple -outfile simple_template.txt
#write_template -power -outfile template_power.tcl
#write_template -area -outfile template_area.tcl
#write_template -full -outfile template_full.tcl
#write_template -retime -outfile template_retime.tcl

#Hit quit to exit Genus. Do not do Ctrl+C, you will be holding up licenses
