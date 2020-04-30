ENTRY(start_kernel)

SECTIONS {
    .text ALIGN(1024):{
        *(.text);
    }
    .text.init ALIGN(1024):{
        __text_init_start = .;
        KEEP(*(.text.init));
        __text_init_end = .;
    }
    .syscall ALIGN(1024):{
        KEEP(*(.syscall));
        __syscall_end = .;
    }
    .rodata ALIGN(1024):{
        *(.rodata);
    }
    .rodata.init ALIGN(1024):{
        __rodata_init_start = .;
        KEEP(*(.rodata.init));
        __rodata_init_end = .;
    }
    .data ALIGN(1024):{
        *(.data);
    }
    .data.init ALIGN(1024):{
        __data_init_start = .;
        KEEP(*(.data.init));
        __data_init_end = .;
    }
    .bss ALIGN(1024):{
        *(.bss)
        *(COMMON)
    }
}