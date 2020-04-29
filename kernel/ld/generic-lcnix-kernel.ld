
SECTIONS {
    ENTRY(start_kernel):
    .text{
        *(.text);
    }
    .text.init{
        KEEP(*(.text.init));
    }
    .rodata{
        *(.rodata);
    }
    .rodata.init{
        KEEP(*(.rodata.init));
    }
    .data{
        *(.data);
    }
    section .data.init{
        KEEP(*(.data.init));
    }
    section .bss{
        *(.bss)
        *(COMMON)
    }
}