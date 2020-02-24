EESchema Schematic File Version 4
LIBS:KiCAD_RiscVCPU-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Symbols:ALU U?
U 1 1 5E43500F
P 6425 2500
F 0 "U?" H 6225 3200 39  0001 C CNN
F 1 "ALU" H 6425 3200 39  0000 C CNN
F 2 "" H 6375 2750 50  0001 C CNN
F 3 "" H 6375 2750 50  0001 C CNN
	1    6425 2500
	1    0    0    -1  
$EndComp
$Comp
L Symbols:ImmediateGen U?
U 1 1 5E4359EA
P 5200 2925
F 0 "U?" H 5200 3166 39  0001 C CNN
F 1 "ImmediateGen" H 5200 3075 39  0000 C CNN
F 2 "" H 5200 2925 50  0001 C CNN
F 3 "" H 5200 2925 50  0001 C CNN
	1    5200 2925
	1    0    0    -1  
$EndComp
$Comp
L Symbols:ProgramCounter U?
U 1 1 5E4363A6
P 3125 1850
F 0 "U?" H 3125 2091 39  0001 C CNN
F 1 "ProgramCounter" H 3125 2000 39  0000 C CNN
F 2 "" H 3025 1450 50  0001 C CNN
F 3 "" H 3025 1450 50  0001 C CNN
	1    3125 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 2875 4950 2875
Wire Wire Line
	4600 1950 4600 2200
Wire Wire Line
	4950 2200 4600 2200
Connection ~ 4600 2200
Text Notes 4625 1850 0    28   ~ 0
Inst[19:15]
Text Notes 4625 1950 0    28   ~ 0
Inst[24:20]
Text Notes 4625 2200 0    28   ~ 0
Inst[11:7]
Text Label 4900 2300 2    24   ~ 0
i_REGWriteSrc
Text Label 4950 2100 2    24   ~ 0
i_REGWriteEN
Text Notes 4625 2875 0    28   ~ 0
Inst[6:0]
Wire Wire Line
	4950 2975 4600 2975
Wire Wire Line
	4600 2975 4600 2875
Connection ~ 4600 2875
Text Label 6125 1900 2    24   ~ 0
i_ALUOpCode
Text Label 6075 2025 2    24   ~ 0
i_ALUSrcASel
Text Label 6075 2450 2    24   ~ 0
i_ALUSrcBSel
Wire Wire Line
	5975 2700 5925 2700
Wire Wire Line
	5975 2900 5925 2900
Text Label 5925 2700 0    39   ~ 0
4
Text Label 5925 2900 0    39   ~ 0
0
Wire Wire Line
	4800 2550 4525 2550
Wire Wire Line
	4525 2550 4525 3200
Connection ~ 4525 3200
Wire Wire Line
	4525 3200 6950 3200
Wire Wire Line
	5450 2925 5650 2925
Wire Wire Line
	5650 2925 5650 2800
Wire Wire Line
	5550 1950 5450 1950
Text Label 2825 1825 2    24   ~ 0
i_PCWrite
Text Label 6725 2000 0    24   ~ 0
o_ALUZero
Text Notes 3850 2475 0    24   ~ 0
ALUResult
Text Notes 3525 1900 0    24   ~ 0
PC\n
Text Notes 3950 2700 0    24   ~ 0
RD2
Text Notes 5925 2600 0    24   ~ 0
RD2
Text Notes 5925 2800 0    24   ~ 0
IMM
Text Notes 5850 2100 0    24   ~ 0
PrevPC
Text Notes 5900 2250 0    24   ~ 0
RD1
Text Notes 2650 1900 0    24   ~ 0
ALUResult
Wire Wire Line
	2650 1900 2825 1900
Text Label 4850 2750 2    24   ~ 0
o_Instruction
Wire Wire Line
	4600 1850 4950 1850
Wire Wire Line
	4850 2750 4600 2750
$Comp
L Symbols:IRam U?
U 1 1 5E46EF95
P 3775 1900
F 0 "U?" H 3775 2300 39  0001 C CNN
F 1 "IRam" H 3750 2025 39  0000 C CNN
F 2 "" H 3925 1850 50  0001 C CNN
F 3 "" H 3925 1850 50  0001 C CNN
	1    3775 1900
	1    0    0    -1  
$EndComp
$Comp
L Symbols:DRam U?
U 1 1 5E46F828
P 4225 2500
F 0 "U?" H 4225 2741 39  0001 C CNN
F 1 "DRam" H 4225 2666 39  0000 C CNN
F 2 "" H 4225 2500 50  0001 C CNN
F 3 "" H 4225 2500 50  0001 C CNN
	1    4225 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 3200 3800 3200
Wire Wire Line
	4800 2475 4425 2475
Wire Wire Line
	4025 2475 3800 2475
Wire Wire Line
	3800 2475 3800 3200
Connection ~ 3800 3200
Wire Wire Line
	3800 3200 4525 3200
Wire Wire Line
	3925 3100 3925 2700
Wire Wire Line
	3925 2700 4025 2700
Wire Wire Line
	3925 3100 5550 3100
Wire Wire Line
	2650 1900 2650 3200
Connection ~ 4600 1950
Wire Wire Line
	4600 1950 4950 1950
Text Label 4025 2625 2    24   ~ 0
i_DRamWE
Wire Wire Line
	3425 1825 3450 1825
$Comp
L Symbols:RegisterFile U?
U 1 1 5E436910
P 5200 2150
F 0 "U?" H 5125 1785 39  0001 C CNN
F 1 "RegisterFile" H 5150 2550 39  0000 C CNN
F 2 "" H 5200 2150 50  0001 C CNN
F 3 "" H 5200 2150 50  0001 C CNN
	1    5200 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 1950 5550 2600
Wire Wire Line
	5650 2800 5975 2800
Wire Wire Line
	5975 2600 5550 2600
Connection ~ 5550 2600
Wire Wire Line
	5550 2600 5550 3100
Wire Wire Line
	5625 1850 5625 2250
Wire Wire Line
	5625 2250 5975 2250
Wire Wire Line
	6725 1900 6950 1900
Wire Wire Line
	6950 1900 6950 3200
Connection ~ 4600 2750
Wire Wire Line
	4600 2750 4600 2875
Wire Wire Line
	4600 2200 4600 2750
Wire Wire Line
	5450 1850 5625 1850
Wire Wire Line
	4800 2400 4475 2400
Wire Wire Line
	3425 1900 3475 1900
Wire Wire Line
	3475 1900 3475 2300
Wire Wire Line
	3475 2300 4475 2300
Wire Wire Line
	4475 2300 4475 2400
$Comp
L Symbols:IReg U?
U 1 1 5E496570
P 4325 1875
F 0 "U?" H 4300 2075 39  0001 C CNN
F 1 "IReg" H 4300 2025 39  0000 C CNN
F 2 "" H 4200 1725 50  0001 C CNN
F 3 "" H 4200 1725 50  0001 C CNN
	1    4325 1875
	1    0    0    -1  
$EndComp
Wire Wire Line
	3575 1900 3475 1900
Connection ~ 3475 1900
Wire Wire Line
	4600 1850 4600 1950
Wire Wire Line
	4600 1850 4550 1850
Connection ~ 4600 1850
Wire Wire Line
	3975 1900 4100 1900
Text Label 4100 1825 2    24   ~ 0
i_IRegWR
Text Notes 4625 2550 0    24   ~ 0
ALUResult
Text Notes 4725 2475 0    24   ~ 0
DRd
Text Notes 4750 2400 0    24   ~ 0
PC\n
Wire Wire Line
	3475 1900 3475 1675
Wire Wire Line
	3475 1675 5700 1675
Wire Wire Line
	5700 1675 5700 2175
Wire Wire Line
	5700 2175 5975 2175
Wire Wire Line
	5975 2100 5775 2100
Wire Wire Line
	5775 2100 5775 1600
Wire Wire Line
	5775 1600 3450 1600
Wire Wire Line
	3450 1600 3450 1825
Text Notes 5925 2175 0    24   ~ 0
PC\n
$EndSCHEMATC
