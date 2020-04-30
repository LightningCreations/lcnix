#![no_std]
#![no_main]

extern"C"{
    #[no_mangle]
    pub fn init_syscall_handle();
}

#[cfg_attr(not(target="wc65c816"),link_section = ".text.init")]
#[cfg_attr(target="wc65c816",link_section = ".text.kinit")]
#[no_mangle]
pub unsafe extern"C" fn start_kernel() -> !{
    init_syscall_handle();

    loop{}
}

pub mod kpanic;
pub mod proc;
pub mod syscall;
pub mod file;
pub mod ptr;