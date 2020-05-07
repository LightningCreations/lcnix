
pub mod types{
    mod arch;

    #[cfg(target_arch="x86_64")]
    pub use arch::x86_64::*;

    #[cfg(not(any(target_arch = "x86_64")))]
    compile_error!("This architecture is not yet supported");

    pub use crate::cap::cap_t;
}

pub mod except{
    mod arch;

    #[cfg(target_arch="x86_64")]
    pub use arch::x86_64::*;

}



pub mod disp;
