
pub use crate::file::syscall::*;

#[repr(transparent)]
pub struct SyscallDecl(*const ());

unsafe impl Sync for SyscallDecl{}

macro_rules! static_slice {
    {$($(#[$attr:meta])* $vis:vis static $ident:ident: [$ty:ty] = $array:expr;)*} => {
        $(
            $(#[$attr])* $vis static $ident: [$ty; $array.len()] = $array;
        )*
    };
}

static_slice!{
    #[no_mangle]
    pub static __syscall: [SyscallDecl] = [SyscallDecl(sys_read as *const ())];
}