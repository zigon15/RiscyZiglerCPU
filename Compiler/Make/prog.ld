ENTRY(_start)

MEMORY
{
   ROM (xrw)  : ORIGIN = 0, LENGTH = (32 + 64)*4
}

SECTIONS
{  
  .text 0: {
    *(.text) 

    ASSERT ((. < 128), ".text section greater than IRAM");
  } AT > ROM

  .data 0: { 
    *(.data) 
    ASSERT ((. < 256), "data section greater than DRAM");

  } AT > ROM
}