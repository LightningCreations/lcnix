#!/bin/bash

sysroot=/mnt/lfs
toolchain=lccc
stage=2
start_from=0
external_toolchain=no
parallel_jobs=auto
kernel=lcnix
kernel_config_file=no

root_path=$(dirname $0)

shift

while [ -n $0 ]
do
  case $0 in
    *=* )
      optval=`expr "X$0" : '[^=]*=\(.*\)'`;;
    *= )
      optval= ;;
    --disable-* | --without-* )
      optval=no ;;
    --* )
      optval=yes ;;
  esac

  case $0 in
    --sysroot=* )
      sysroot=${optval} ;;
    --toolchain=* )
      toolchain=${optval} ;;
    --stage=0 | --stage=1 | --stage=2 )
      stage=${optval} ;;
    --start-from=0 | --start-from=1 | --start-from=2 )
      start_from=${optval} ;;
    --enable-external-toolchain=* | --enable-external-toolchain | --disable-external-toolchain )
      external_toolchain=${optval} ;;
    --with-parallel-jobs=* | --without-parallel-jobs )
      parallel_jobs=${optval} ;;
    --enable-kernel=* | --disable-kernel )
      kernel=${optval} ;;
    --with-kernel-config=* | --without-kernel_config )
      kernel_config_file=${optval} ;;
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
    --* )
      error Unrecongized Option $0.
      exit 1 ;;
  esac
  shift
done

if [ ${parallel_jobs} = "auto" -o ${parallel_jobs} = "yes" ]
then
  parallel_jobs=$(($(getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN  2>/dev/null || echo 1)*2))
elif [ ${parallel_jobs}]

common_cmake_args=-DCMAKE_BUILD_TYPE=Release

llvm_toolchain_git="https://github.com/llvm-project/llvm.git"
llvm_toolchain_stage0_cmake_args=-DLLVM_ENABLE_PROJECTS="clang;libcxx"
llvm_toolchain_stage1_cmake_args=
llvm_toolchain_is_internal=no
llvm_toolchain_cc_name=clang
llvm_toolchain_cxx_name=clang++
llvm_toolchain_as_name=clang
llvm_toolchain_really_exists=1

lccc_toolchain_git="https://github.com/LightningCreations/lccc.git"
lccc_toolchain_stage0_cmake_args=
lccc_toolchain_stage1_cmake_args=
lccc_toolchain_is_internal=yes
lccc_toolchain_cc_name=lccc
lccc_toolchain_cxx_name=lc++
lccc_toolchain_as_name=lccc
lccc_toolchain_rustc_name=lcrustc
lccc_toolchain_really_exists=1

external_toolchain_dir=toolchain-src-${toolchain}


linux_kernel_git="https://github.com/torvalds/linux.git"
linux_kernel_needs_config=yes
linux_kernel_really_exists=1

lcnix_kernel_really_exists=1

function error(){
  echo "$@" 2>&1
}

if [ ${stage} -lt ${start_from} ]
then
  error Cannot build up to stage-${stage} from stage-${start_from}
  exit 1
fi

if [ -z ${${toolchain}_toolchain_really_exists} ]
then
  error Unrecongized toolchain "${toolchain}"
  exit 1
fi
if [ -n ${CC} ]
  stage0_cc=${CC}
elif [ -n $(which lccc) ]
  stage0_cc=$(which lccc)
elif [ -n $(which clang)]
  stage0_cc=$(which clang)
elif [ -n $(which gcc) ]
  stage0_cc=$(which gcc)
elif [ -n $(which cc) ]
  stage0_cc=$(which cc)
else
  error Could not find stage-0 c compiler, please ensure it is available in PATH, or set the CC environment variable
  exit 1
fi

if [ -n ${CXX} ]
  stage0_cxx=${CXX}
elif [ -n $(which lc++) ]
  stage0_cxx=$(which lc++)
elif [ -n $(which clang++) ]
  stage0_cxx=$(which clang++)
elif [ -n $(which g++) ]
  stage0_cxx=$(which g++)
elif [ -n $(which c++) ]
  stage0_cxx=$(which c++)
else
  error Could not find stage-0 C++ compiler, please ensure it is available in PATH, or set the CXX environment variable
fi

if[ -n ${MAKE} ]
then
  stage0_make=${MAKE}
elif [ -n $(which make) ]
then
  stage0_make=$(which make)
elif [ -n $(which lcmake) ]
then
  stage0_make=$(which lcmake)
else
  error Could not find make program, please ensure it is available in PATH, or set the MAKE environment variable
fi

stage0_as=${stage0_cc}

if [ -z ${GIT} ]
then
  git=$(which git)
else
  git=${GIT}
fi

if [ -z ${CMAKE} ]
then
  stage0_cmake=$(which cmake)
else
  stage0_cmake=${CMAKE}
fi

stage1_cmake=${stage0_cmake}
stage2_cmake=${stage0_cmake}

stage0_prefix=${sysroot}/stage0-tools
stage1_prefix=${sysroot}/tools
stage2_prefix=${sysroot}/usr

stage1_cc=${stage0_prefix}/bin/${${toolchain}_toolchain_cc_name}
stage1_cxx=${stage0_prefix}/bin/${${toolchain}_toolchain_cxx_name}
stage1_as=${stage0_prefix}/bin/${${toolchain}_toolchain_as_name}

stage2_cc=${stage1_prefix}/bin/${${toolchain}_toolchain_cc_name}
stage2_cxx=${stage1_prefix}/bin/${${toolchain}_toolchain_cxx_name}

function begin_stage0(){
   pushd ${root_path}
   ${git} submodule update --init
   popd
   if [ ${${toolchain}_toolchain_is_internal} = "no" -o ${force_external_toolchain} = "yes"]
   then
     ${git} clone --recursive ${${toolchain}_toolchain_git} ${external_toolchain_dir}
   else
     ${external_toolchain_dir}=${root_path}/${toolchain}
   fi
   ${CMAKE} ${common_cmake_args} ${${toolchain}_toolchain_stage0_cmake_args} -DCMAKE_C_COMPILER=${stage0_cc} -DCMAKE_CXX_COMPILER=${stage0_cxx} -DCMAKE_ASM_COMPILER${stage0_as}\
    -DCMAKE_TOOLCHAIN_FILE=${root_path}/bootstrap-cmake/stage0.cmake \
    -DCMAKE_INSTALL_PREFIX=${stage0_prefix} -S${external_toolchain_dir} -B./${toolchain}_build
}

function build_stage0(){
  ${CMAKE} --build ${toolchain}_build --parallel ${parallel_jobs}
}

function end_stage0(){
  ${CMAKE} --install ${toolchain}_build
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