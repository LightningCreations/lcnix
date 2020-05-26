//
// Created by chorm on 2020-05-12.
//

#include <stddef.h>

void* memcpy(void* restrict __dest,const void* restrict __src,size_t __len){
    for(size_t i = 0;i<__len;i++)
        ((char* restrict)__dest)[i] = ((const char* restrict)__src)[i];
    return __dest;
}

void* memmove(void* __dest,const void* __src,size_t __len){
    for(size_t i = 0;i<__len;i++)
        ((char* restrict)__dest)[i] = ((const char* restrict)__src)[i];
    return __dest;
}

int bcmp(const void* __a,const void* __b,size_t len) __attribute__((alias("memcmp")));

int memcmp(const void* __a,const void* __b,size_t __len){
    for(size_t i = 0;i<__len;i++){
        signed char diff = ((const signed char*)__a)[i]-((const signed char*)__b)[i];
        if(diff!=0)
            return diff;
    }
    return 0;
}

void* memset(void* __dest,int __val,size_t __len){
    for(size_t i = 0;i<__len;i++)
        ((unsigned char*)__dest)[i] = (unsigned char)__val;
    return __dest;
}