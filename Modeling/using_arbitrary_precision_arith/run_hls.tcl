#
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create a project
open_component -reset component_using_arbitrary_precision_arith -flow_target vivado

# Add design files
add_files cpp_ap_int_arith.cpp
# Add test bench & files
add_files -tb cpp_ap_int_arith_test.cpp
add_files -tb result.golden.dat

# Set the top-level function
set_top cpp_ap_int_arith

# ########################################################
# Create a solution
# Define technology and clock rate
set_part  {xcvu9p-flga2104-2-i}
create_clock -period 4

# Set variable to select which steps to execute
set hls_exec 2


csim_design
# Set any optimization directives
set_directive_interface -mode m_axi cpp_ap_int_arith out1 -depth 1
set_directive_interface -mode m_axi cpp_ap_int_arith out2 -depth 1
set_directive_interface -mode m_axi cpp_ap_int_arith out3 -depth 1
set_directive_interface -mode m_axi cpp_ap_int_arith out4 -depth 1
# End of directives

if {$hls_exec == 1} {
	# Run Synthesis and Exit
	csynth_design
	
} elseif {$hls_exec == 2} {
	# Run Synthesis, RTL Simulation and Exit
	csynth_design
	
	cosim_design
} elseif {$hls_exec == 3} { 
	# Run Synthesis, RTL Simulation, RTL implementation and Exit
	csynth_design
	
	cosim_design
	export_design
} else {
	# Default is to exit after setup
	csynth_design
}

exit

