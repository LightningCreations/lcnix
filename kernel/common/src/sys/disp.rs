use core::fmt::{Formatter, Write, Error,Result};

extern"C"{
    #[no_mangle]
    pub fn kwrite(text: *const u8,sz: usize);
}

pub struct PrintkFormatter;

impl Write for PrintkFormatter{
    fn write_str(&mut self, s: &str) -> Result {
        for c in s.chars(){
            if (c as u32)&0x7f!=(c as u32){
                return Err(Error)
            }
        }
        unsafe{kwrite(s.as_ptr(),s.len())}
        Ok(())
    }
    fn write_char(&mut self, c: char) -> Result{
        if (c as u32)&0x7f!=(c as u32){
            Err(Error)
        }else{
            let u = c as u8;
            unsafe{kwrite(&u,1)};
            Ok(())
        }
    }
}