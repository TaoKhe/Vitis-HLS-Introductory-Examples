Description
===========

This C++ design illustrates the instantiation of the AMD/Xilinx LogiCORE FFT from the Vivado IP catalog into Vitis HLS. This example is a single 1024 point forward FFT.

The code micro-architecture uses dataflow with 3 processes : 
* a datamover to read the input data,
* a process to call the FFT itself,
* a datamover to write-out the output data. 


```
     +--(fft_top)------------------------------------------------------------+
     |                                                                       |
in --+--> [inputdatamover]--(xn)-->[myfftwrapper]--(xk)-->[outputdatamover]--+--> out
     |                                                                       |
     +-----------------------------------------------------------------------+
```

The FFT C++ instantiation supports two access modes: arrays or stream via hls::stream<>; those are the types you can define the variables "xn" and "xk" in the above diagram. In the two example designs we provide, the top level function arguments (the input "in" and output "out") have the same data types as the internal variables. 

The two design variations are referenced in the table below. If you integrate the FFT into a dataflow region you may not need the datamovers.


|   Design name    | Top level interfaces | Internal data types |
|:----------------:|:--------------------:|:-------------------:|
| interface_array  |         array        |         array       |
| interface_stream |        stream        |        stream       |

The design example has been tested with version 2025.1 of Vitis HLS.

Design Files
============
Each design variations has the following files:

data        : directory with input and expected data used by the testbench
fft_tb.cpp  : C testbench; calls 20 times the top function
fft_top.cpp : top C function fft_top
ffp_top.h   : header file for the example 
run_hls.tcl : script to run synthesis, simulation and export IP
run.py	    : script to run csimulation, csynthesis and cosimulation using vitis
README      : a small readme file which refers to this readme.md

Running the Example
===================
In a terminal, set up the Vitis tools, navigate into the directory and run the command: 
```
$ vitis-run --mode hls --tcl run_hls.tcl
```
To open the HLS component in Vitis Unified IDE after running the Tcl script:
```
$ vitis -w .
```
Alternatively run Python script with Vitis
```
$ vitis -s run.py
```
To open the HLS component in Vitis Unified IDE after running the Python script:
```
$ vitis -w w
```

Performance
===========

## Throughput
After running the design example, you can check the throughput in the GUI by opening the co-simulation report and verifying the II numbers for the top-level function fft_top which will be in the range 1025 - 1027 clock cycles which is expected for the 1024 point FFT; you can also open the timeline trace or the Vivado waveform if you enabled the dump trace option.
On the command line you can grep the output of the latency report, for example 
```
$ for d in interface_* ; do echo $d ; grep THROUGHPUT $d/comp*/hls/sim/report/verilog/lat.rpt ; done
interface_array
$MAX_THROUGHPUT = "1027"
$MIN_THROUGHPUT = "1026"
$AVER_THROUGHPUT = "1026"
interface_stream
$MAX_THROUGHPUT = "1025"
$MIN_THROUGHPUT = "1024"
$AVER_THROUGHPUT = "1024"
```

## Frequency
The constraint is 2.5 ns (i.e. 400 MHz) for a Virtex Ultrascale device (xcvu9p-flga2104-2-i); Using the export flow, we can check what frequency is achieved when run with the out-of-context implementation option. 
Different frequencies will be achieved if you change the target part and/or the clock period or, the design.

```
================================================================
== Vivado Place & Route Results
================================================================
+ General Information:
    * Version:         2025.1 (Build 6135595 on May 19 2025)
    * Project:         component_interface_array
    * Solution:        hls (Vivado IP Flow Target)
    * Product family:  virtexuplus
    * Target device:   xcvu9p-flga2104-2-i

================================================================
== Place & Route Resource Summary
================================================================
LUT:              3317
FF:               4703
DSP:              12
BRAM:             7
URAM:             0
SRL:              979


================================================================
== Place & Route Timing Summary
================================================================
* Timing was met
+----------------+-------------+
| Timing         | Period (ns) |
+----------------+-------------+
| Target         | 2.500       |
| Post-Synthesis | 1.569       |
| Post-Route     | 2.324       |
+----------------+-------------+

```

Points to Note 
===============
You will see:
- in the tcl script setup: -start_fifo_depth 4 is used,
- a wrapper around the fft call is sometimes used to improve the performance.