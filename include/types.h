/*
 * types.h
 *
 *  Created on: Mar. 11, 2020
 *      Author: connor
 */

#ifndef INCLUDE_TYPES_H_
#define INCLUDE_TYPES_H_


// Userspace and Kernel Space Header

#ifdef HAS_QC_INCLUDES
#include <qc/qc_ints.h>
// If we have them, include qcs ints header.
// This gets all the qc identifiers as well
#else
#include <stdint.h>
#endif

typedef uint32_t uid_t;
typedef uint32_t gid_t;
typedef int32_t  fd_t;
typedef uint32_t pid_t;


#endif /* INCLUDE_TYPES_H_ */
