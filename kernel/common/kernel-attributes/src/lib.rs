use proc_macro::TokenStream;

#[proc_macro_attribute]
pub fn syscall(input: TokenStream,item: TokenStream) -> TokenStream{
    item
}