
extern "C" {
    pub fn read8(port: u16) -> u8;
    pub fn read16(port: u16) -> u16;
    pub fn read32(port: u16) -> u32;
    pub fn write8(port: u16,val: u8);
    pub fn write16(port: u16,val: u16);
    pub fn write32(port: u16,val: u32);
}

pub trait BusReadable: Sized{
    unsafe fn read(port: u16) -> Self;
}

impl BusReadable for u8{
    unsafe fn read(port: u16) -> Self {
        read8(port)
    }
}

impl BusReadable for u16{
    unsafe fn read(port: u16) -> Self {
        read16(port)
    }
}

impl BusReadable for u32{
    unsafe fn read(port: u16) -> Self {
        read32(port)
    }
}

impl BusReadable for i8{
    unsafe fn read(port: u16) -> Self {
        read8(port) as i8
    }
}

impl BusReadable for i16{
    unsafe fn read(port: u16) -> Self {
        read16(port) as i16
    }
}

impl BusReadable for i32{
    unsafe fn read(port: u16) -> Self {
        read32(port) as i32
    }
}

pub trait BusWritable{
    unsafe fn write(&self,port: u16);
    #[inline]
    unsafe fn write_consume(self,port: u16) where Self:Sized{
        self.write(port)
    }
}

impl BusWritable for u8{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write8(port,*self)
    }
}

impl BusWritable for u16{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write16(port,*self)
    }
}

impl BusWritable for u32{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write32(port,*self)
    }
}

impl BusWritable for i8{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write8(port,*self as u8)
    }
}

impl BusWritable for i16{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write16(port,*self as u16)
    }
}

impl BusWritable for i32{
    #[inline]
    unsafe fn write(&self, port: u16) {
        write32(port,*self as u32)
    }
}

impl<T: BusWritable> BusWritable for [T]{
    unsafe fn write(&self, port: u16) {
        for v in self{
            v.write(port)
        }
    }
}

impl<T: BusWritable + ?Sized> BusWritable for &'_ T{
    unsafe fn write(&self, port: u16) {
        (**self).write(port)
    }
}

impl<T: BusWritable + ?Sized> BusWritable for &'_ mut T{
    unsafe fn write(&self, port: u16) {
        (**self).write(port)
    }
}

