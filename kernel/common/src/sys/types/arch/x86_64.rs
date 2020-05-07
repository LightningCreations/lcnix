#![allow(non_camel_case_types)]

pub type id_t = i64;

pub type uid_t = id_t;
pub type gid_t = id_t;
pub type fd_t = id_t;
pub type pid_t = id_t;

pub type size_t = usize;
pub type ssize_t = isize;

#[cfg(target_feature = "avx2")]
pub type mm_reg = core::arch::x86_64::__mm256i;
#[cfg(not(target_feature="avx2"))]
pub type mm_reg = core::arch::x86_64::__mm128i;

#[repr(C)]
pub struct ProcFrame{
    pub cs: u64,
    pub fs: u64,
    pub gs: u64,
    pub _unused: u64,
    pub rsp: u64,
    pub rbp: u64,
    pub rax: u64,
    pub rbx: u64,
    pub rcx: u64,
    pub rdx: u64,
    pub rsi: u64,
    pub rdi: u64,
    pub r8: u64,
    pub r9: u64,
    pub r10: u64,
    pub r11: u64,
    pub r12: u64,
    pub r13: u64,
    pub r14: u64,
    pub r15: u64,
    pub mm0: mm_reg,
    pub mm1: mm_reg,
    pub mm2: mm_reg,
    pub mm3: mm_reg,
    pub mm4: mm_reg,
    pub mm5: mm_reg,
    pub mm6: mm_reg,
    pub mm7: mm_reg
}
