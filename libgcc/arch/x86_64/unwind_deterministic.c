#pragma ide diagnostic ignored "bugprone-reserved-identifier"
//
// Created by chorm on 2020-05-25.
//

#include <stddef.h>

struct TLSUnwindInfo{
    _Bool is_unwinding;
    const struct _ZN9__cxx_abi9type_info* unwind_rtti;
    void* unwind_allocation;


    _Alignas(_Alignof(max_align_t))char inline_alloc[1024];
};