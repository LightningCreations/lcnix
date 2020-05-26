
add_library(gcc-common OBJECT memcpy.c)
target_compile_options(gcc-common -ffreestanding)
target_link_options(gcc-common PUBLIC -nodefaultlibs)