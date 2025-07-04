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

#Solution -1 shows the problem 
open_component -reset component_input_bypass_prob -flow_target vivado
set_top dut
add_files dut.cpp
add_files -tb test_dut.cpp
set_part {xqku115-rlf1924-1-i}
create_clock -period 10 -name default
csim_design
csynth_design
cosim_design

#solution-2 to the input bypassing task 
open_component -reset component_input_bypass_sol -flow_target vivado
set_top dut
add_files dut_sol.cpp
add_files -tb test_dut.cpp
set_part {xqku115-rlf1924-1-i}
create_clock -period 10 -name default
csim_design
csynth_design
cosim_design

