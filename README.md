# AHB-Protocol-SystemVerilog

Design and Implementation of AHB Protocol in SystemVerilog.

In this work, there is 1 master and 4 slaves. 
The slaves are expected to be memory elements which uses the signal pins as desribed in the AHB protocols. 

The size of memory is 256 deep, 1 byte in width. 

There are multiple FSM designs of Master and Slave possible. We have used and adopted as shown in this repo. 
The request of a master is served with a delay of 2 clock cycles.

This work is a simplified version of AHB protocol. 
