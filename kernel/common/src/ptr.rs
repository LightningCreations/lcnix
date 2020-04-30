
#[repr(transparent)]
// This needs to be a userspace pointer.
pub struct UserPtr<T>(*mut T);
