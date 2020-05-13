

use core::ffi::c_void;
use crate::sys::types::size_t;

#[allow(non_camel_case_types)]
type gfp_t = u16;

const GFP_USER: gfp_t = 0;
const GFP_KERNEL: gfp_t = 1;
const GFP_ATOMIC: gfp_t = 2;
const GFP_HIGHUSER: gfp_t = 3;
const GFP_NOIO: gfp_t = 4;
const GFP_NOFS: gfp_t = 5;
const GFP_NOWAIT: gfp_t = 6;
const __GFP_THISNODE: gfp_t = 7;
const GFP_DMA: gfp_t = 8;

const __GFP_COLD: gfp_t = 16;
const __GFP_HIGH: gfp_t = 32;
const __GFP_NOFAIL: gfp_t = 64;
const __GFP_NORETRY: gfp_t = 128;
const __GFP_NOWARN: gfp_t = 256;
const __GFP_REPEAT: gfp_t = 512;

extern"C"{
    #[no_mangle]
    pub fn kmalloc(size: size_t,flags: gfp_t) -> *mut c_void;
    #[no_mangle]
    pub fn kmalloc_array(n: size_t,size: size_t,flags: gfp_t) -> *mut c_void;
    #[no_mangle]
    pub fn kcalloc_array(n: size_t,size: size_t,flags: gfp_t) -> *mut c_void;
    #[no_mangle]
    pub fn kzalloc(size: size_t,flags: gfp_t) -> *mut c_void;
    #[no_mangle]
    pub fn kfree(mem: *mut c_void);
}


