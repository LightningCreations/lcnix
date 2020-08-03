#!/bin/bash

sysroot=/mnt/lfs
toolchain=lccc
stage=2
start_from=0
external_toolchain=no
parallel_jobs=auto
kernel=lcnix
kernel_config_file=no
verbose=no

root_path=$(dirname $0)
prg_name=$0

while (( $# ))
do
  case $1 in
    *=* )
      optval=`expr "X$1" : '[^=]*=\(.*\)'`;;
    *= )
      optval= ;;
    --disable-* | --without-* )
      optval=no ;;
    --* )
      optval=yes ;;
  esac

  case $1 in
    --sysroot=* )
      sysroot=${optval} ;;
    --toolchain=* )
      toolchain=${optval} ;;
    --stage=0 | --stage=1 | --stage=2 )
      stage=${optval} ;;
    --start-from=0 | --start-from=1 | --start-from=2 )
      start_from=${optval} ;;
    --build-stage=0 | --build-stage=1 | --build-stage=2 )
      stage=${optval}
      start_from=${optval} ;;
    --enable-external-toolchain=* | --enable-external-toolchain | --disable-external-toolchain )
      external_toolchain=${optval} ;;
    --with-parallel-jobs=* | --without-parallel-jobs )
      parallel_jobs=${optval} ;;
    --enable-kernel=* | --disable-kernel )
      kernel=${optval} ;;
    --with-kernel-config=* | --without-kernel_config )
      kernel_config_file=${optval} ;;
    --enable-verbose | --enable-verbose=* | --disable-verbose )
      verbose=${optval} ;;
    --help )
      printf 'Usage: %s [OPTIONS]...\n' $prg_name
      printf 'Bootstraps lcnix into /mnt/lfs or a specified sysroot\n'
      printf 'This program is path sensitive. The script must exist from the root of the lcnix source directory. It may be ran from any directory\n\n'
      printf 'Options:\n'
      printf '\t--sysroot=<path>: Installs to <path> instead of /mnt/lfs. Directory must be writable by the effective user id\n'
      printf '\t--toolchain=<toolchain>: Builds using <toolchain> instead of the default builtin lccc. Acceptable values are lccc and llvm\n'
      printf '\t--stage=<stage>: Builds <stage> and all preceeding stages, where stage is between 0 and 2. Defaults to 2\n'
      printf '\t--start-from=<stage>: Starts builds from <stage>, instead of stage 0. Accepts the same values as stage. \n'
      printf '\t--build-stage=<stage>: Same as --stage=<stage> --start-from=<stage> (that is, builds <stage>, and only <stage>)\n'
      printf '\t--enable-external-toolchain[=opt]: Configures whether to use an external toolchain build. Acceptable values are yes, auto, and no. Defaults to auto\n'
      printf '\t--disable-external-toolchain: Same as --enable-external-toolchain=no\n'
      printf '\t--with-parallel-jobs=<jobs|auto>: Builds each stage using the specified number of jobs, or 2*core count if auto is specified. Defaults to auto\n'
      printf '\t--without-parallel-jobs: Forces each stage to be built in serial. Same as --with-parallel-jobs=1\n'
      printf '\t--enable-kernel=<kernel>: Builds the specified kernel, instead of the lcnix kernel. Acceptable values are lcnix and linux.\n'
      printf '\t--disable-kernel: Do not build any kernel during stage2. Appropriate kernel headers MUST be on a standard search path before building either stage 1 or stage 2\n'
      printf '\t--with-kernel-config=<file>: Builds the kernel against the specified config file. Only meaningful when using --enable-kernel=linux\n'
      printf '\t--enable-verbose[=opt]: Prints verbose information about the operation. If opt is omitted, defaults to yes. Acceptable values are yes and no\n'
      printf '\t--disable-verbose: Disables verbose information. Same as --enable-verbose=no\n'
      printf '\t--help: Prints this message and exits\n'
      printf '\t--version: Prints version information and exits\n'
      printf '\n'
      printf 'Environment:\n'
      printf 'All Environment variables listed here can also be provided in the command arguments\n\n'
      printf '\tCC=<compiler>: Sets the full path to the C compiler used in the initial stage.\n\n'
      printf '\tCXX=<compiler>: Sets the full path to the C++ compiler used in the initial stage.\n\n'
      printf '\tGIT=<git>: Sets the full path to the git program to use.\n\n'
      printf '\tCMAKE=<cmake>: Sets the full path to the cmake program to use.\n\n'
      printf '\tMAKE=<make>: sets the full path to the make program to use.\n\n'
      exit 0 ;;
    --version )
      printf 'lcnix-bootstrap v1.0\n'
      printf 'Copyright (C) 2020 Lightning Creations\n'
      printf 'This program is a free software, released under the terms of the GNU GPLv3+ license\n'
      printf 'See README.md for details\n'
      exit 0 ;;
    CC=* )
      CC=${optval} ;;
    CXX=* )
      CXX=${optval} ;;
    CMAKE=* )
      CMAKE=${optval} ;;
    GIT=* )
      GIT=${optval} ;;
    MAKE=* )
      MAKE=${optval} ;;
    * )
      error Unrecongized Option $0.
      exit 1 ;;
  esac
  shift
done

if [ ${parallel_jobs} = "auto" -o ${parallel_jobs} = "yes" ]
then
  parallel_jobs=$(($(getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN  2>/dev/null || echo 1)*2))
elif [ ${parallel_jobs} = "no" ]
then
  parallel_jobs=1
fi

build_directory=$(pwd -L)
source_directory=$(realpath ${build_directoy}/${root_path})

common_cmake_args=-DCMAKE_BUILD_TYPE=Release

# Toolchain hackyness to be
#

llvm_toolchain_git="https://github.com/llvm/llvm-project.git"
llvm_toolchain_stage0_cmake_args=-DLLVM_ENABLE_PROJECTS="clang;libcxx"
llvm_toolchain_stage1_cmake_args=
llvm_toolchain_is_internal=no
llvm_toolchain_cc_name=clang
llvm_toolchain_cxx_name=clang++
llvm_toolchain_as_name=clang
llvm_toolchain_rustc_name=rustc
llvm_toolchain_needs_external_rust=yes
llvm_toolchain_external_rust_git="https://github.com/rust-lang/rust.git"
llvm_toolchain_really_exists=1
llvm_toolchain_source_directory=${build_directory}/llvm-project
llvm_toolchain_external_rust_source_directory=${build_directory}/rust
llvm_toolchain_stage0_build_directory=${build_directory}/llvm-project/build-stage0
llvm_toolchain_stage1_build_directory=${build_directory}/llvm-project/build-stage1
llvm_toolchain_stage2_build_directory=${build_directory}/llvm-project/build-stage2


lccc_toolchain_git="https://github.com/LightningCreations/lccc.git"
lccc_toolchain_stage0_cmake_args=
lccc_toolchain_stage1_cmake_args=
lccc_toolchain_is_internal=yes
lccc_toolchain_cc_name=lccc
lccc_toolchain_cxx_name=lc++
lccc_toolchain_as_name=lccc
lccc_toolchain_rustc_name=lcrustc
lccc_toolchain_needs_external_rust=no
lccc_toolchain_really_exists=1
lccc_toolchain_source_directory=${build_directory}/lccc # Note: only used if an external toolchain is used
lccc_toolchain_stage0_build_directory=${build_directory}/lccc-stage0
lccc_toolchain_stage1_build_directory=${build_directory}/lccc-stage1
lccc_toolchain_stage2_build_directory=${build_directory}/lccc-stage2

_toolchain_git=${toolchain}_toolchain_git
toolchain_git=${!_toolchain_git}
_toolchain_stage0_cmake_args=${toolchain}_toolchain_stage0_cmake_args
toolchain_stage0_cmake_args=${!_toolchain_stage0_cmake_args}
_toolchain_stage1_cmake_args=${toolchain}_toolchain_stage1_cmake_args
toolchain_stage1_cmake_args=${!_toolchain_stage1_cmake_args}
_toolchain_is_internal=${toolchain}_toolchain_is_internal
toolchain_is_internal=${!_toolchain_is_internal}
_toolchain_cc_name=${toolchain}_toolchain_cc_name
toolchain_cc_name=${!_toolchain_cc_name}
_toolchain_cxx_name=${toolchain}_toolchain_cxx_name
toolchain_cxx_name=${!_toolchain_cxx_name}
_toolchain_rustc_name=${toolchain}_toolchain_rustc_name
toolchain_rustc_name=${!_toolchain_rustc_name}
_toolchain_external_rust_git=${toolchain}_toolchain_external_rust_git
toolchain_external_rust_git=${!_toolchain_external_rust_git}
_toolchain_really_exists=${toolchain}_toolchain_really_exists
toolchain_really_exists=${!_toolchain_really_exists}
_toolchain_source_directory=${toolchain}_toolchain_source_directory
toolchain_source_directory=${!_toolchain_source_directory}
_toolchain_external_rust_source_directory=${toolchain}_toolchain_external_rust_source_directory
toolchain_external_rust_source_directory=${!_toolchain_external_rust_source_directory}
_toolchain_stage0_build_directory=${toolchain}_toolchain_stage0_build_directory
toolchain_stage0_build_directory=${!_toolchain_stage0_build_directory}
_toolchain_stage1_build_directory=${toolchain}_toolchain_stage1_build_directory
toolchain_stage1_build_directory=${!_toolchain_stage1_build_directory}
_toolchain_stage2_build_directory=${toolchain}_toolchain_stage2_build_directory
toolchain_stage2_build_directory=${!_toolchain_stage2_build_directory}

# Kernel Stuff

linux_kernel_git="https://github.com/torvalds/linux.git"
linux_kernel_needs_config=yes
linux_kernel_really_exists=1

lcnix_kernel_needs_config=no
lcnix_kernel_really_exists=1

function error(){
  printf "%s" "$*" 2>&1
}

if [ ${stage} -lt ${start_from} ]
then
  error Cannot build up to stage-${stage} from stage-${start_from}
  exit 1
fi

if [ -z ${toolchain_really_exists} ]
then
  error Unrecongized toolchain "${toolchain}"
  exit 1
fi
if [ -n ${CC} ]
then
  stage0_cc=${CC}
elif [ -n $(which lccc) ]
then
  stage0_cc=$(which lccc)
elif [ -n $(which clang)]
then
  stage0_cc=$(which clang)
elif [ -n $(which gcc) ]
then
  stage0_cc=$(which gcc)
elif [ -n $(which cc) ]
then
  stage0_cc=$(which cc)
else
  error Could not find stage-0 c compiler, please ensure it is available in PATH, or set the CC environment variable
  exit 1
fi

if [ \! -x ${stage0_cc} ]
then
  error stage-0 c compiler cannot be executed \(OR CC was set to a program name\)
  exit 1
fi

if [ -n ${CXX} ]
then
  stage0_cxx=${CXX}
elif [ -n $(which lc++) ]
then
  stage0_cxx=$(which lc++)
elif [ -n $(which clang++) ]
then
  stage0_cxx=$(which clang++)
elif [ -n $(which g++) ]
then
  stage0_cxx=$(which g++)
elif [ -n $(which c++) ]
then
  stage0_cxx=$(which c++)
else
  error Could not find stage-0 C++ compiler, please ensure it is available in PATH, or set the CXX environment variable
fi

if [ \! -x ${stage0_cxx} ]
then
  error stage-0 c compiler cannot be executed
  exit 1
fi

if [ -n "${MAKE}" ]
then
  stage0_make=${MAKE}
elif [ -n "$(which make)" ]
then
  stage0_make=$(which make)
elif [ -n "$(which lcmake)" ]
then
  stage0_make=$(which lcmake)
else
  error Could not find make program, please ensure it is available in PATH, or set the MAKE environment variable
fi

if [ \! -x ${stage0_make} ]
then
  error Cannot execute make program
fi

stage0_as=${stage0_cc}

if [ -n "$(which git)" ]
then
  git="$(which git)"
elif [ -n "${GIT}" ]
then
  git=${GIT}
else
  error Could not find git program, pleas ensure it is available in PATH, or set the GIT environment variable
fi

if [ \! -x ${git} ]
then
  error Cannot execute git program
fi

if [ -n "${CMAKE}" ]
then
  stage0_cmake=${CMAKE}
elif [ -n "$(which cmake)" ]
then
  stage0_cmake=$(which cmake)
else
  error Could not find cmake program, please ensure it is available in PATH, or set the GIT Environment variable
fi

stage1_cmake=${stage0_cmake}
stage2_cmake=${stage0_cmake}

stage0_prefix=${sysroot}/stage0-tools
stage1_prefix=${sysroot}/tools
stage2_prefix=${sysroot}/usr

stage1_cc=${stage0_prefix}/bin/${toolchain_cc_name}
stage1_cxx=${stage0_prefix}/bin/${toolchain_cxx_name}
stage1_as=${stage0_prefix}/bin/${toolchain_as_name}

stage2_cc=${stage1_prefix}/bin/${toolchain_cc_name}
stage2_cxx=${stage1_prefix}/bin/${toolchain_cxx_name}

function begin_stage0(){
   pushd ${root_path}
   ${git} submodule update --init
   popd
   if [ ${toolchain_is_internal} = "no" -o ${force_external_toolchain} = "yes"]
   then
     ${git} clone --recursive ${toolchain_git} ${toolchain_source_directory}
   else
     toolchain_source_directory=${root_path}/${toolchain}
   fi
   ${CMAKE} ${common_cmake_args} ${toolchain_stage0_cmake_args}\
    -DCMAKE_C_COMPILER=${stage0_cc} -DCMAKE_CXX_COMPILER=${stage0_cxx}\
    -DCMAKE_ASM_COMPILER${stage0_as}\
    -DCMAKE_TOOLCHAIN_FILE=${root_path}/bootstrap-cmake/stage0.cmake \
    -DCMAKE_INSTALL_PREFIX=${stage0_prefix}\
     -S${toolchain_source_directory} -B${toolchain_stage0_build_directory}
}

function build_stage0(){
  ${CMAKE} --build ${toolchain_source_directory} --parallel ${parallel_jobs}
}

function end_stage0(){
  ${CMAKE} --install ${toolchain_source_directory}
}

function begin_stage1(){
  ${CMAKE} ${common_cmake_args} ${stage1_cmake_args} -DCMAKE_TOOLCHAIN_FILE=${root_path}/bootstrap-cmake/stage1_libc.cmake

}

function build_stage1(){

}

function end_stage1(){

}

for s in {${start_from}..${stage}}
do
  PATH=${stage${s}_path}
  CC=${stage${s}_cc}
  CXX=${stage${s}_cxx}
  CMAKE=${stage${s}_cmake}
  AS=${stage${s}_as}
  begin_stage${s}
  build_stage${s}
  end_stage${s}
done