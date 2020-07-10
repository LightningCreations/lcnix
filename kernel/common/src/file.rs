
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

    pub unsafe extern "C" fn sys_read(_fd: Fd, _ptr: UserPtr<c_void>, _len: usize) -> isize {
        -1
    }
    pub unsafe extern"C" fn sys_write(_fd: Fd,_ptr: UserPtr<c_void>,_len: usize) -> isize{
        -1
    }
    pub unsafe extern"C" fn sys_close(_fd: Fd) -> isize{
        -1
    }

    pub unsafe extern"C" fn sys_dup(fd: Fd) -> Fd{
        fd
    }
}
