use core::panic::PanicInfo;

#[panic_handler]
pub fn kernel_panic(panic: &PanicInfo) -> !{
    if let Some(&msg) = panic.payload().downcast_ref::<&'static str>(){

    }
    loop {}
}