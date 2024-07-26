use mobile_entry_point::mobile_entry_point;
#[mobile_entry_point]
pub extern "C" fn main() {
    use winit::{
        application::ApplicationHandler,
        event::WindowEvent,
        event_loop::{ActiveEventLoop, ControlFlow, EventLoop},
        window::WindowId,
    };

    struct App;

    impl ApplicationHandler for App {
        fn resumed(&mut self, event_loop: &ActiveEventLoop) {
            event_loop.set_control_flow(ControlFlow::Wait);
        }
        fn window_event(&mut self, event_loop: &ActiveEventLoop, id: WindowId, event: WindowEvent) {}
        fn suspended(&mut self, event_loop: &winit::event_loop::ActiveEventLoop) {
            event_loop.set_control_flow(ControlFlow::Wait);
        }
    }

    let event_loop = EventLoop::new().unwrap();

    event_loop.set_control_flow(ControlFlow::Wait);

    event_loop.run_app(&mut App).unwrap();
}
