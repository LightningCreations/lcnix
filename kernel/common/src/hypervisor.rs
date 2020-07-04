
#[cfg(not(target_arch = "x86_64"))]
compile_error!("Presently, hypervisor support is only available for x86_64");


#[repr(u32)]
pub enum HypervisorType{
    None = 0,
    Unknown = 1,
    LCHypervisor = 2,
    // Add any others that we learn how below

}

extern"C"{
    pub fn running_hypervisor()->HypervisorType;
}