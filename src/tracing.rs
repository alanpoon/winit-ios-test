use std::fmt::Debug;

pub fn info_span(s:&str){
    println!("{}",s);
}
pub fn debug(s:&str){
    println!("{}",s);
}
pub fn debug2<T>(a:&str, s:T) where T:Debug{
    println!("{} {:?}",a,s);
}
pub fn info(s:&str){
    println!("{}",s);
}