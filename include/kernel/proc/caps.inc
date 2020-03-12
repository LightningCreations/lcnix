CAP_AUDIT_CONTROL,
CAP_AUDIT_READ,
CAP_AUDIT_WRITE,
CAP_BLOCK_SUSPEND,
CAP_CHOWN,
CAP_DAC_OVERRIDE,
CAP_DAC_READ_SEARCH,
CAP_FOWNER,
CAP_FSETID,
CAP_IPC_LOCK,
CAP_IPC_OWNER,
CAP_KILL,
CAP_LEASE,
CAP_LINUX_IMMUTABLE,
CAP_MAC_ADMIN,
CAP_MAC_OVERRIDE,
CAP_MKNOD,
CAP_NET_ADMIN,
CAP_NET_BIND_SERVICE,
CAP_NET_BROADCAST,
CAP_NET_RAW,
CAP_SETGID,
CAP_SETFCAP,
CAP_SETPCAP,
CAP_SETUID,
CAP_SYS_BOOT,
CAP_SYS_CHROOT,
CAP_SYS_MODULE,
CAP_SYS_NICE,
CAP_SYS_PACCT,
CAP_SYS_PTRACE,
CAP_SYS_RAWIO,
CAP_SYS_RESOURCE,
CAP_SYS_TIME,
CAP_SYS_TTY_CONFIG,
CAP_SYSLOG,
CAP_WAKE_ALARM,
// Below here are the various capabilities that CAP_SYS_ADMIN are split into
// For backwards compatability CAP_SYS_ADMIN implies all of the following

CAP_LCNIX_RES0,
CAP_LCNIX_RES1,
CAP_LCNIX_RES2,
CAP_LCNIX_RES3,
CAP_LCNIX_RES4,
CAP_LCNIX_RES5,
CAP_LCNIX_RES6,
CAP_LCNIX_RES7,

///
/// Mount Filesystems or Control Mounts
CAP_FSMOUNT,
/// Control System Quotas
CAP_QUOATA,
/// Perform Arbitrary IPC Operations otherwise prohibited
CAP_ADMIN_IPC,
///
/// Manipulate system variables dealing with Security,
/// Including security and trusted extended attributes
CAP_SYS_SEC,
///
/// Bypass certain system limits
CAP_SYS_LIMIT,

///
/// Control namespaces.
/// setns requires either CAP_SYS_ADMIN or CAP_NS_ADMIN in the target namespace
CAP_NS_ADMIN,
///
/// Various Privileged io calls
CAP_IO_ADMIN,
///
/// Networking Privileges previously implied by CAP_SYS_ADMIN
CAP_SYS_NET,

///
/// Arbitrary seccomp access, including via ptrace
CAP_SECCOMP,

/// Administrative Access to device drivers
CAP_DRV_ADMIN,

/// Anything not explicitly denoted to any of the above Capabilities as a privilege delagated from CAP_SYS_ADMIN
/// Falls here. If a File for lcnix absolutely needs any of these obscure system calls,
/// It is recommended to use CAP_SYSCALL_OBSCURE, rather than CAP_SYS_ADMIN, as this capability will not imply any of the above
CAP_SYSCALL_OBSCURE