
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
    .data.init{
        KEEP(*(.data.init));
    }
    .bss{
        *(.bss)
        *(COMMON)
    }
}