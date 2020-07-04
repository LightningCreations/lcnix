
enable_language(ASM)
if(LCNIX_HYPERVISOR_WRAPPER)
    add_subdirectory(hypervisor)
endif()

add_library(i386-loader OBJECT loader.s)
# set_target_properties(i386-loader PROPERTIES COMPILE_FLAGS "-m32")

add_library(lcnix-kernel-arch-x86_64 STATIC syscall_init.s bus.s gdt.c idt.c loader-64long.s $<TARGET_OBJECTS:i386-loader> halt.s isrs.s
        $<$<BOOL:${LCNIX_HYPERVISOR_WRAPPER}>:$<TARGET_OBJECTS:lcnix-x86_64-hypervisor-ext>>)


target_compile_options(lcnix-kernel-arch-x86_64 PRIVATE -ffreestanding)

