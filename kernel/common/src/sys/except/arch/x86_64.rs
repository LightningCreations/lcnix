use crate::sys::types::ProcFrame;

use core::mem::MaybeUninit;

#[repr(u8)]
pub enum Interrupt{
    DivdeByZero = 0,
    Debug = 1,
    NMI = 2,

}

#[no_mangle]
pub extern"C" fn handle_exception(_code: Interrupt,_err_code: MaybeUninit<usize>, uframe: *const ProcFrame) -> *const ProcFrame{
    uframe
}