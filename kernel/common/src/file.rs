

#[repr(transparent)]
pub struct Fd(u32);

pub mod syscall {
    use crate::file::Fd;
    use core::ffi::c_void;
    use crate::ptr::UserPtr;

    pub unsafe extern "C" fn sys_read(fd: Fd, ptr: UserPtr<c_void>, len: usize) -> isize {
        0
    }
}
