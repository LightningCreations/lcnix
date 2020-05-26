cmake_minimum_required(VERSION 3.15)
project(lcnix CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules" "${CMAKE_CURRENT_SOURCE_DIR}/lccc/cmake")


set(LCNIX_TARGET_ARCH ${CMAKE_SYSTEM_PROCESSOR} CACHE STRING "Sets the architecture to target with the lcnix build. This is an advanced operation. When cross-compiling you should use a Cross-compilation script that sets CMAKE_SYSTEM_PROCESSOR")


if(LCNIX_BOOTSTRAP_BUILD AND LCNIX_GNU_BUILD)
    message(FATAL_ERROR "Bootstrapping, and in-place GNU Build are mutually exclusive")
endif()

if(LCNIX_BOOTSTRAP_BUILD)
    message(STATUS "Bootstrapping lcnix from scratch")
    if(NOT DEFINED LCNIX_BOOTSTRAP_ROOT)
        set(LCNIX_BOOTSTRAP_ROOT "/mnt/lcnix")
    endif()
    set(LCNIX_GNU_BUILD "ON")
    set(LCCC_USE_INTERNAL_LIBCXX ON)
    set(LCCC_USE_INTERNAL_SYSLIBS ON)
    add_subdirectory(stage1)
endif()

if(NOT DEFINED LCNIX_BUILD_LCCC AND NOT LCNIX_CUSTOM_BUILD)
    set(LCNIX_BUILD_LCCC "ON")
endif()
if(NOT DEFINED LCNIX_BUILD_CMAKE AND NOT LCNIX_CUSTOM_BUILD)
    set(LCNIX_BUILD_CMAKE "ON")
endif()
if(NOT DEFINED LCNIX_BUILD_KERNEL AND NOT LCNIX_GNU_BUILD AND NOT LCNIX_CUSTOM_BUILD)
    set(LCNIX_BUILD_KERNEL ON)
endif()
if(NOT DEFINED LCNIX_BUILD_COREUTILS AND NOT LCNIX_CUSTOM_BUILD AND NOT LCNIX_BOOTSTRAP_BUILD)
    set(LCNIX_BUILD_COREUTILS ON)
endif()

if(NOT DEFINED LCNIX_BUILD_LCSH AND NOT LCNIX_CUSTOM_BUILD)
    set(LCNIX_BUILD_LCSH ON)
endif()

if(LCNIX_BUILD_KERNEL)
    if(LCNIX_GNU_BUILD)
        message(WARNING "Building lcnix kernel on GNU/Linux is not supported")
    endif()
    message(STATUS "Building lcnix kernel")
    set(LCNIX_LCCC_KERNEL_HEADERS ON)
    add_subdirectory(kernel)
    include_directories(include)
endif()

if(LCNIX_BUILD_LIBC)
    if(LCNIX_GNU_BUILD)
        message(WARNING "Building libc on GNU/Linux is not supported")
    endif()
    message(STATUS "Building libc and low-level libraries")
    # Enable LSB required low-level libraries, including libc
    add_subdirectory(libc) # Libc defines headers
    add_subdirectory(libm)
endif()

if(LCNIX_BUILD_LCCC)
    message(STATUS "Building LCCC Compiler")
    add_subdirectory(lccc)
endif()

if(LCNIX_BUILD_CMAKE)
    message(STATUS "Building builtin CMake")
    add_subdirectory(CMake)
endif()

if(LCNIX_BUILD_LCSH)
    message(STATUS "Building lcsh")
    add_subdirectory(lcsh)
endif()

if(LCNIX_BUILD_COREUTILS)
    message(STATUS "Building coreutils")
    add_subdirectory(lc-coreutils)
endif()


if(LCNIX_BUILD_SYSTEMD)
    message(STATUS "Building systemd")
    include(ExternalProject)
    ExternalProject_Add(systemd
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/systemd
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/systemd
        CONFIGURE_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/systemd/configure --prefix=${CMAKE_INSTALL_PREFIX} ${CMAKE_CURRENT_SOURCE_DIR}/systemd # Rdr can you wire this properly
        BUILD_COMMAND ninja
        INSTALL_COMMAND ninja install
    )
endif()

