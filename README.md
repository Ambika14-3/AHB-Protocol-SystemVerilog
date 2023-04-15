# AHB-Protocol-SystemVerilog

Design and Implementation of AHB Protocol in SystemVerilog -

This is our project which we have done in the course of Integrated Circuits Design Laboratory at Indian Institue of Technology, Gandhinagar. 
In this work, there is 1 master and 4 slaves. 
The slaves are expected to be memory elements which uses the signal pins as desribed in the AHB protocols. 

The size of memory is 256 deep, 1 byte in width. 

There are multiple FSM designs of Master and Slave possible. We have used and adopted as shown in this repo. 
The request of a master is served with a delay of 2 clock cycles.

This work is a simplified version of AHB protocol and uses the signal pins apt for fulfilling the objective of 1 master with 4 slaves. Thourough testing is done by performing Single transaction write/read, wrap, increment write/read, and Unspecified increment write/read. 

The SystemVerilog Code is then Synthesized in the Genus and performance parameters like power, area and timing (critical path) are extracted in the text files present in the Result folder. 

Explanation of the work is done in the pdf present in the Docs folder. 


![image](https://user-images.githubusercontent.com/66430218/232239833-c1f0ce50-e094-4083-ae90-c1fda562ec70.png)

![image](https://user-images.githubusercontent.com/66430218/232239905-32391aed-06e6-4742-98a6-28af3c8e7e16.png)

