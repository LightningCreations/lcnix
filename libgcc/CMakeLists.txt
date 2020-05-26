
add_subdirectory(common)
add_subdirectory(arch/${LCNIX_TARGET_ARCH})

add_library(gcc-objects OBJECT $<TARGET_OBJECTS:gcc-common> $<TARGET_OBJECTS:gcc-arch-${LCNIX_TARGET_ARCH}>)