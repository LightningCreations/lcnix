

add_library(ld-lcnix SHARED ld-lcnix.c $<TARGET_OBJECTS:ld-lcnix-${LCNIX_TARGET_ARCH}> $<TARGET_OBJECTS:crt>)
set_target_properties(ld-lcnix PROPERTIES PREFIX "" OUTPUT_NAME "ld-lcnix-${LCNIX_TARGET_ARCH}" SOVERSION "1.0")
target_link_libraries(ld-lcnix c-static)
target_link_options(ld-lcnix PRIVATE -nostdlib -Wl,-e,_start)