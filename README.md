# Riscy Zigler -> Multicycle RISC-V CPU
The aim of the Riscy Zigler CPU was to create a multicycle RiscV CPU mainly for my own learning.

![picture alt](/CpuSch/Sch.png "Riscy Zigler Execution Unit Schematic")

This [spread sheet](https://docs.google.com/spreadsheets/d/1mWK94z9eMsW_5bcy7o9rIBbRjxbbVYnMOb8QPpOwEwk/edit?usp=sharing) shows the current instructions implemented as well as various other helpfull information. It is a slight modified copy of the [spread sheet](https://docs.google.com/spreadsheets/d/1X9xBfaUgbxQuFZyJ2MIp71Ahj7ipkVSn2zBECM891wQ/edit) _Moppu_ posted in the _Digital Design HQ_ discord server for the RISC-V cpu project.



### Directories:
* **\Compiler** contains code that is used to assemble programs using the RISC-V GNU toolchain. It contains helper programs. At the moment there is only one which formats a binary file into text that can be copied straight into the ram verilog files.
* **\CpuSch** contains a kicad project of the CPU execution unit in schematic format as well as the sysmbol library which is used. I find doing this is helpfull as I can understand what is happening better when debugging.
* **\RTL** contains the code for the CPU as well as test benches.


