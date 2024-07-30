use mobile_entry_point::mobile_entry_point;
use winit::{event_loop::EventLoopBuilder, window::{Window, WindowBuilder}};
use std::sync::Arc;
mod app;
mod gpu;
fn main(){
    let event_loop = EventLoopBuilder::new().build().unwrap();
    let window = WindowBuilder::new().build(&event_loop).unwrap();
    app::run2(event_loop, Arc::new(window));
}