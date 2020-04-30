
enable_language(C)

add_subdirectory(arch/${LCNIX_TARGET_ARCH})
add_subdirectory(common)

add_library(c-static STATIC $<TARGET_OBJECTS:c-arch-${LCNIX_TARGET_ARCH}> $<TARGET_OBJECTS:c-common>)
add_library(c-shared SHARED $<TARGET_OBJECTS:c-arch-${LCNIX_TARGET_ARCH}> $<TARGET_OBJECTS:c-common>)
set(LCNIX_LIBC_VER "0.1")

set_target_properties(c-static PROPERTIES OUTPUT_NAME c)
set_target_properties(c-shared PROPERTIES OUTPUT_NAME c SOVERSION ${LCNIX_LIBC_VER})

