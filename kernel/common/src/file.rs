
use crate::sys::types::fd_t;
use crate::syscall::SyscallParam;

#[repr(transparent)]
#[derive(Copy,Clone)]
pub struct Fd(fd_t);

unsafe impl SyscallParam for Fd{}


pub mod syscall {
    use crate::file::Fd;
    use core::ffi::c_void;
    use crate::ptr::UserPtr;

    pub unsafe extern "C" fn sys_read(fd: Fd, ptr: UserPtr<c_void>, len: usize) -> isize {
        -1
    }
    pub unsafe extern"C" fn sys_write(fd: Fd,ptr: UserPtr<c_void>,len: usize) -> isize{
        -1
    }
    pub unsafe extern"C" fn sys_close(fd: Fd) -> isize{
        -1
    }

    pub unsafe extern"C" fn sys_dup(fd: Fd) -> Fd{
        fd
    }
}
