
pub mod types{
    mod arch;

    #[cfg(target_arch="x86_64")]
    pub use arch::x86_64::*;

    #[cfg(not(any(target_arch = "x86_64")))]
    compile_error!("This architecture is not yet supported");

    pub use crate::cap::cap_t;
}

extern"C"{
    #[no_mangle]
    pub fn read8(port: u16) -> u8;
    #[no_mangle]
    pub fn read16(port: u16) -> u16;
    #[no_mangle]
    pub fn read32(port: u16) -> u32;
    #[no_mangle]
    pub fn write8(port: u16,val: u8);
    #[no_mangle]
    pub fn write16(port: u16,val: u16);
    #[no_mangle]
    pub fn write32(port: u16,val: u32);
}

pub mod disp;
