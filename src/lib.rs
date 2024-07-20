use mobile_entry_point::mobile_entry_point;
use winit::{event_loop::EventLoopBuilder, window::{Window, WindowBuilder}};
use ambient;
#[mobile_entry_point]
pub extern "C" fn main() {
    //let event_loop = EventLoopBuilder::new().build();
    // let window = WindowBuilder::new().build(&event_loop).unwrap();

    // event_loop.run(move |event, _, _| {
    //     println!("{:?}", event);
    // });
    let mut app = ambient::IosApp::new();
    app.run(ambient::client::init,Box::new(||{
        ambient::shared::components::init().unwrap();
    }));
}
