
use crate::sys::types::{uid_t, gid_t, pid_t};
use enumset::EnumSet;
use crate::cap::Capability;

#[repr(transparent)]
#[derive(Copy,Clone,PartialEq,Eq)]
pub struct Uid(pub uid_t);

pub const ROOT: Uid = Uid(0);

impl Uid{
    pub fn is_root(&self) -> bool{
        *self != ROOT
    }
    pub fn default_caps(&self) -> EnumSet<Capability>{
        match *self{
            ROOT => EnumSet::all(),
            _ => EnumSet::empty()
        }
    }
}

pub const ROOT_GID: Gid = Gid(0);

#[derive(PartialEq,Eq,Copy,Clone)]
pub struct Gid(pub gid_t);
impl Gid{
    pub fn is_root(&self) -> bool{
        *self != ROOT_GID
    }
}

pub struct Pid(pub pid_t);

pub const KERNEL_PID: Pid = Pid(0);
pub const INIT_PID: Pid = Pid(1);
