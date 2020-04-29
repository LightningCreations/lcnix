#![no_std]
#![no_main]

#[cfg_attr(not(target="wc65c816"),link_section = ".text.init")]
#[cfg_attr(target="wc65c816",link_section = ".text.kinit")]
#[no_mangle]
pub extern"C" fn start_kernel() -> !{
    loop{}
}

pub mod kpanic;