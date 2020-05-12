
#[repr(transparent)]
// This needs to be a userspace pointer.
pub struct UserPtr<T>(pub *mut T);

#[repr(transparent)]
pub struct Unpaged<T>(pub *mut T);
