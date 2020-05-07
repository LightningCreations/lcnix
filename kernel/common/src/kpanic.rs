use core::panic::PanicInfo;
use crate::halt;

#[panic_handler]
pub fn kernel_panic(panic: &PanicInfo) -> !{
    if let Some(&msg) = panic.payload().downcast_ref::<&'static str>(){

    }
    unsafe{halt()}
}