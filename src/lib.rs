use mobile_entry_point::mobile_entry_point;
use winit::{event_loop::EventLoopBuilder, window::{Window, WindowBuilder}};
use std::sync::Arc;
mod app;

#[mobile_entry_point]
pub extern "C" fn main() {
    let event_loop = EventLoopBuilder::new().build().unwrap();
    let window = WindowBuilder::new().build(&event_loop).unwrap();
    app::run(event_loop, Arc::new(window));
}
