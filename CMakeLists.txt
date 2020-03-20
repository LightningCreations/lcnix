project(lcnix CXX)
cmake_minimum_required(VERSION 3.10)

include_directories(include)

# The following lines are for satisfying CMAKE
# Remove in production
set(LCNIX_TARGET_ARCH x86_64)

if(NOT DEFINED LCNIX_BOOTSTRAP_BUILD)
# By default, assume we are in an lcnix environment. Use -DLCNIX_BOOSTRAP_BUILD=ON to enable the switch
set(LCNIX_BOOTSTRAP_BUILD "OFF")
endif(NOT DEFINED LCNIX_BOOTSTRAP_BUILD)

add_subdirectory(kernel)
add_subdirectory(libm)

if(NOT LCNIX_BOOTSTRAP_BUILD)
include(ExternalProject)
ExternalProject_Add(systemd
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/systemd
    CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/systemd && ${CMAKE_CURRENT_SOURCE_DIR}/systemd/configure
    BUILD_COMMAND make -C ${CMAKE_CURRENT_SOURCE_DIR}/systemd
)
endif(NOT LCNIX_BOOTSTRAP_BUILD)

