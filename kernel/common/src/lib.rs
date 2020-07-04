#![no_std]

use core::fmt::Write;

use core::ffi::c_void;
use crate::sys::disp::PrintkFormatter;

extern"C"{
    #[no_mangle]
    pub fn init_syscall_handle();
    #[no_mangle]
    pub fn init_interrupts();
    #[no_mangle]
    pub fn halt() -> !;
}


#[cfg_attr(not(target="wc65c816"),link_section = ".text.init")]
#[cfg_attr(target="wc65c816",link_section = ".text.kinit")]
#[no_mangle]
pub unsafe extern"C" fn start_kernel(mb_struct: *const c_void) -> !{
    init_syscall_handle();
    init_interrupts();
    let _ = writeln!(&mut PrintkFormatter,"Test");
    halt()
}

pub mod kpanic;
pub mod proc;
pub mod syscall;
pub mod file;
pub mod ptr;
pub mod errno;
pub mod sys;
pub mod cap;
pub mod elf;
pub mod bus;
#[cfg(feature="lc_hypervisor")]
pub mod hypervisor;
mod alloc;