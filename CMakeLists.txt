project(lcnix CXX)
cmake_minimum_required(VERSION 3.10)

include_directories(include)

# The following lines are for satisfying CMAKE
# Remove in production
set(LCNIX_TARGET_ARCH x86_64)

add_subdirectory(kernel)
add_subdirectory(libm)

include(ExternalProject)
ExternalProject_Add(systemd
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/systemd
    CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/systemd && ${CMAKE_CURRENT_SOURCE_DIR}/systemd/configure --prefix=${CMAKE_CURRENT_BINARY_DIR}/systemd
    BUILD_COMMAND make -C ${CMAKE_CURRENT_SOURCE_DIR}/systemd
)
