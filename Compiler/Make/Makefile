# makefile to create test.o

# assemble source file to create binary files
test.elf:test.s
	riscv64-unknown-elf-as test.s -o .\output\prog.elf
	riscv64-unknown-elf-ld -N -T .\prog.ld .\output\prog.elf -o .\output\ldProg.elf

	riscv64-unknown-elf-objcopy -O binary --only-section=.text .\output\ldProg.elf .\output\text.bin
	riscv64-unknown-elf-objcopy -O binary --only-section=.data .\output\ldProg.elf .\output\data.bin
	"..\HelperPrograms\AutoCopy\AutoCopy" .\output\text.bin

extData:
	"..\HelperPrograms\AutoCopy\AutoCopy" .\output\data.bin

dmpO:
	riscv64-unknown-elf-objdump -D .\output\prog.elf
	riscv64-unknown-elf-objdump -s -w --section=.data .\output\prog.elf

dmpExe:
	riscv64-unknown-elf-objdump -D .\output\ldProg.elf

# remove object files and backup files
#clean:
#	rm -i *.o *~