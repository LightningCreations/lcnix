//
// Created by chorm on 2020-05-02.
//

#ifndef __LCNIX_STDINT_H
#define __LCNIX_STDINT_H

#if __has_include_next(<stdint.h>)
// If we have a sytem or arch specific stdint, include that
// This is correct on SNES-Dev based architecutres as incuding the architecture's stdint.h also defines the qc base types
#include_next <stdint.h>
#else

// Otherwise, use the standard types

typedef unsigned char uint8_t;
typedef signed char int8_t;

typedef unsigned short uint16_t;
typedef signed short int16_t;

typedef unsigned int uint32_t;
typedef signed int int32_t;

typedef unsigned long long uint64_t;
typedef signed long long int64_t;

#define INT8_MIN INT8_C(-128)
#define INT16_MIN INT16_C(-32768)
#define INT32_MIN INT32_C(-2147483648)
#define INT64_MIN INT64_C(-9223372036854775808)


#define INT8_MAX INT8_C(127)
#define INT16_MAX INT16_C(32767)
#define INT32_MAX INT32_C(2147483647)
#define INT64_MAX INT64_C(9223372036854775807)


#define UINT8_MIN UINT8_C(0)
#define UINT16_MIN UINT16_C(0)
#define UINT32_MIN UINT32_C(0)
#define UINT64_MIN UINT64_C(0)


#define UINT8_MAX UINT8_C(255)
#define UINT16_MAX UINT16_C(65535)
#define UINT32_MAX UINT32_C(4294967295)
#define UINT64_MAX UINT64_C(18446744073709551615)

#ifdef __INT128_SIZE__
typedef unsigned _Int128 uint128_t;
typedef signed _Int128 int128_t;
#define INTMAX_C(val) INT128_C(val)
#define UINT128_MIN UINT128_C(0)
#define UINTMAX_MIN UINT128_MIN
#define INT128_MIN INT128_C(-170141183460469231731687303715884105728)
#define INTMAX_MIN INT128_MIN
#define INT128_MAX INT128_C(170141183460469231731687303715884105727)
#define INTMAX_MAX INT128_MAX
#define UINT128_MAX UINT128_C(340282366920938463463374607431768211455)
#define UINTMAX_MAX UINT128_MAX
typedef int128_t intmax_t;
typedef uint128_t uintmax_t;
#else
typedef int64_t intmax_t;
typedef uint64_t uintmax_t;
#define INTMAX_C(val) INT64_C(val)
#define INTMAX_MIN INT64_MIN
#define INTMAX_MAX INT64_MAX
#define UINTMAX_C(val) UINT64_C(val)
#define UINTMAX_MIN UINT64_MIN
#define UINTMAX_MAX UINT64_MAX
#endif

#define INT8_C(val) val##i8
#define INT16_C(val) val##i16
#define INT32_C(val) val##i32
#define INT64_C(val) val##i64







#endif

#endif //LCNIX_STDINT_H
