cmake_minimum_required(VERSION 3.15)
project(lcnix CXX)

enable_testing()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules" "${CMAKE_CURRENT_SOURCE_DIR}/lccc/cmake")


set(LCNIX_TARGET_ARCH ${CMAKE_SYSTEM_PROCESSOR} CACHE STRING "Sets the architecture to target with the lcnix build. This is an advanced operation. When cross-compiling you should use a Cross-compilation script that sets CMAKE_SYSTEM_PROCESSOR")

set(LCNIX_BUILD_TYPE "lcnix" CACHE STRING "Sets the type of build for lcnix (gnu, lcnix, bootstrap, or custom)")
set_property(CACHE LCNIX_BUILD_TYPE PROPERTY STRINGS gnu lcnix bootstrap custom)

if(LCNIX_BUILD_TYPE EQUAL "boostrap")
    message(STATUS "Bootstrapping lcnix from scratch")
    if(NOT DEFINED LCNIX_BOOTSTRAP_ROOT)
        set(LCNIX_BOOTSTRAP_ROOT "/mnt/lcnix")
    endif()
    set(LCNIX_GNU_BUILD "ON")
    set(LCNIX_USE_INTERNAL_SYSLIBS)
    set(LCCC_USE_INTERNAL_LIBCXX ON)
    set(LCCC_USE_INTERNAL_SYSLIBS ON)
    add_subdirectory(stage1)
endif()

set(LCNIX_BUILD_LCCC_INIT OFF)
set(LCNIX_BUILD_LCSH_INIT OFF)
set(LCNIX_BUILD_LCONF_INIT OFF)
set(LCNIX_BUILD_LIBC_INIT OFF)
set(LCNIX_BUILD_COREUTILS_INIT OFF)
set(LCNIX_BUILD_CMAKE_INIT OFF)
set(LCNIX_BUILD_KERNEL_INIT OFF)

if(NOT LCNIX_BUILD_TYPE STREQUAL "custom")
    set(LCNIX_BUILD_LCCC_INIT ON)
    set(LCNIX_BUILD_LCSH_INIT ON)
    set(LCNIX_BUILD_LCONF_INIT ON)
    set(LCNIX_BUILD_COREUTILS_INIT ON)
    set(LCNIX_BUILD_BINUTILS_INIT ON)
    set(LCNIX_BUILD_LCMAKE_INIT ON)
endif()
if(LCNIX_BUILD_TYPE STREQUAL "bootstrap")
    set(LCNIX_BUILD_CMAKE_INIT ON)
    set(LCNIX_BUILD_KERNEL_INIT ON)
    set(LCNIX_BUILD_LIBC_INIT ON)
endif()
if(LCNIX_BUILD_TYPE STREQUAL "lcnix")
    set(LCNIX_BUILD_KERNEL_INIT ON)
endif()

option(LCNIX_BUILD_LCCC      "Builds lccc"  ${LCNIX_BUILD_LCCC_INIT})
option(LCNIX_BUILD_LCSH      "Builds lcsh"  ${LCNIX_BUILD_LCSH_INIT})
option(LCNIX_BUILD_LCONF     "Builds lconf"        ${LCNIX_BUILD_LCONF_INIT})
option(LCNIX_BUILD_COREUTILS "Builds lc-coreutils" ${LCNIX_BUILD_COREUTILS_INIT})
option(LCNIX_BUILD_CMAKE     "Builds cmake" ${LCNIX_BUILD_CMAKE_INIT})
option(LCNIX_BUILD_KERNEL    "Builds the kernel" ${LCNIX_BUILD_KERNEL_INIT})
option(LCNIX_BUILD_LIBC      "Builds libc" ${LCNIX_BUILD_LIBC_INIT})
option(LCNIX_BUILD_BINUTILS  "Builds lc-binutils" ${LCNIX_BUILD_BINUTILS_INIT})
option(LCNIX_BUILD_LCMAKE    "Builds lc-make" ${LCNIX_BUILD_LCMAKE_INIT})

if(LCNIX_BUILD_KERNEL)
    message(STATUS "Building lcnix kernel")
    set(LCNIX_LCCC_KERNEL_HEADERS ON)
    add_subdirectory(kernel)
    include_directories(include)
endif()

if(LCNIX_BUILD_LIBC)
    message(STATUS "Building libc and low-level libraries")
    # Enable LSB required low-level libraries, including libc
    add_subdirectory(libc) # Libc defines headers
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

if(LCNIX_BUILD_LCONF)
    message(STATUS "Building lconf")
    add_subdirectory(lconf)
endif()

if(LCNIX_BUILD_BINUTILS)
    message(STATUS "Building binutils")
    add_subdirectory(lc-binutils)
endif()

if(LCNIX_BUILD_LCMAKE)
    message(STATUS "Building lc-make")
    add_subdirectory(lc-make)
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

