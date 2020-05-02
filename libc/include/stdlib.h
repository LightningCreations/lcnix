//
// Created by chorm on 2020-05-02.
//

#ifndef __LCNIX_STDLIB_H
#define __LCNIX_STDLIB_H

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

#ifdef __cplusplus
#if __cplusplus>201103L
#define NULL nullptr
#else
#define NULL 0
#endif
#else
#define NULL ((void*)0)
#endif


#endif //LCNIX_STDLIB_H
