

pub mod types {
    #![allow(non_camel_case_types)]

    pub type Elf32_Addr = u32;
    pub type Elf64_Addr = u64;

    pub const EI_NIDENT: usize = 16;
    pub const MAGIC: &[u8;4] = b"\x75ELF";

    pub const ELFCLASSNONE: u8 = 0;
    pub const ELFCLASS32: u8 = 1;
    pub const ELFCLASS64: u8 = 2;

    pub const ELFDATANONE: u8 = 0;
    pub const ELFDATA2LSB: u8 = 1;
    pub const ELFDATA2MSB: u8 = 2;

    pub const EV_NONE: u8 = 0;
    pub const EV_CURRENT: u8 = 1;

    pub struct ElfIdent{
        pub ei_magic: [u8;4],
        pub ei_class: u8,
        pub ei_data: u8,
        pub ei_version: u8,
        pub ei_osabi: u8,

    }

    #[repr(C)]
    pub struct Elf32_head{
        pub e_ident: [u8;EI_NIDENT],

    }

}