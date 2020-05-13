
pub use crate::file::syscall::*;
use crate::ptr::UserPtr;
use core::mem::MaybeUninit;

pub unsafe trait SyscallParam: Copy{}

unsafe impl<T> SyscallParam for UserPtr<T>{}
unsafe impl SyscallParam for u8{}
unsafe impl SyscallParam for u16{}
unsafe impl SyscallParam for u32{}
unsafe impl SyscallParam for u64{}
unsafe impl SyscallParam for u128{}
unsafe impl SyscallParam for usize{}
unsafe impl SyscallParam for i8{}
unsafe impl SyscallParam for i16{}
unsafe impl SyscallParam for i32{}
unsafe impl SyscallParam for i64{}
unsafe impl SyscallParam for i128{}
unsafe impl SyscallParam for isize{}
unsafe impl<T: SyscallParam> SyscallParam for MaybeUninit<T>{}

pub unsafe trait Syscall{}

unsafe impl<R: SyscallParam> Syscall for unsafe extern"C" fn()->R{}
unsafe impl<R: SyscallParam,A: SyscallParam> Syscall for unsafe extern"C" fn(A)->R{}
unsafe impl<R: SyscallParam,A: SyscallParam,B: SyscallParam> Syscall for unsafe extern"C" fn(A,B)->R{}
unsafe impl<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam> Syscall
    for unsafe extern"C" fn(A,B,C)->R{}
unsafe impl<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam> Syscall
    for unsafe extern"C" fn(A,B,C,D)->R{}
unsafe impl<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam,E: SyscallParam> Syscall
    for unsafe extern"C" fn(A,B,C,D,E)->R{}
unsafe impl<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam,E: SyscallParam,F: SyscallParam> Syscall
    for unsafe extern"C" fn(A,B,C,D,E,F)->R{}


unsafe impl Syscall for *const (){} // To allow null syscalls

fn is_syscall<T: Syscall>(_: T){}

macro_rules! static_slice {
    {$($(#[$attr:meta])* $vis:vis static $ident:ident: [$ty:ty] = $array:expr;)*} => {
        $(
            $(#[$attr])* $vis static $ident: [$ty; $array.len()] = $array;
        )*
    };
}

#[repr(transparent)]
pub struct SyscallDecl(*const ());

unsafe impl Sync for SyscallDecl{} // Hack to work around rust's very stuborn type system.

macro_rules! parcount{
    ("0") => {{
        unsafe extern"C" fn __test<R: SyscallParam>() -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};

    (1) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam>(_: A) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    (2) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam,B: SyscallParam>(_: A,_: B) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    (3) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam>(_: A,_: B,_: C) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    (4) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam>(_: A,_: B,_: C,_: D) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    (5) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam,E: SyscallParam>(_: A,_: B,_: C,_: D,_: E) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    (6) => {{
        unsafe extern"C" fn __test<R: SyscallParam,A: SyscallParam,B: SyscallParam,C: SyscallParam,D: SyscallParam,E: SyscallParam,F: SyscallParam>(_: A,_: B,_: C,_: D,_: E,_:F) -> R{
            core::hint::unreachable_unchecked()
        }
        __test
    }};
    ($_:tt) => {compile_error!("Cannot have a syscall handler with more than 6 parameters")}
}

macro_rules! syscall_decl{
    (null) => {{
        SyscallDecl(core:ptr::null())
    }};
    ($val:expr, $pcount:tt) => {{
        fn __check(){
            is_syscall(if true{$val}else{parcount!($pcount)})
        }
        SyscallDecl($val as *const ())
    }}

}

static_slice!{
    #[link_section = ".syscall"]
    #[no_mangle]
    pub static __syscall: [SyscallDecl] = [
        syscall_decl!(sys_read,3),
        syscall_decl!(sys_write,3)
    ];
}