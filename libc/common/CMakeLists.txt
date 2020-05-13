

add_library(c-common OBJECT malloc.c exit.c ../include/stdlib.h ../include/stdint.h __cxa_exit.c ../include/unistd.h)
target_compile_options(c-common PRIVATE -nostdinc -fPIC)
