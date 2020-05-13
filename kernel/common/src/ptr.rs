
#[repr(transparent)]
// This needs to be a userspace pointer.
pub struct UserPtr<T>(pub *mut T);

impl<T> Copy for UserPtr<T>{}
impl<T> Clone for UserPtr<T>{
    fn clone(&self) -> Self {
        *self
    }
}

#[repr(transparent)]
pub struct Unpaged<T>(pub *mut T);

impl<T> Copy for Unpaged<T>{}
impl<T> Clone for Unpaged<T>{
    fn clone(&self) -> Self {
        *self
    }
}