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
open_component -reset component_using_vectors -flow_target vivado

# Add design files
add_files example.cpp

# Add test bench & files
add_files -tb example_test.cpp -cflags "-std=gnu++14"

# Set the top-level function
set_top example

# ########################################################
# Create a solution

# Define technology and clock rate
set_part  {xcvu9p-flga2104-2-i}
create_clock -period 5

# Set variable to select which steps to execute
set hls_exec 2


csim_design

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
