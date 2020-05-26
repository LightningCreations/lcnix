
add_library(gcc-arch-x86_64 OBJECT unwind_deterministic.c)
target_compile_options(gcc-arch-x86_64 -ffreestanding)
target_link_options(gcc-arch-x86_64 PUBLIC -nodefaultlibs)