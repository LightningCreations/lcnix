

add_library(c-common OBJECT malloc.c)
target_compile_options(c-common PRIVATE -nostdinc)
