use specs::prelude::*;
use wgpu::{ColorTargetState, ColorWrites, InstanceFlags, PipelineCompilationOptions, PresentMode, SurfaceConfiguration, TextureViewDescriptor};
pub struct  Gpu;
// pub struct Gpu {
//     pub surface: Option<wgpu::Surface<'static>>,
//     pub device: Arc<wgpu::Device>,
//     pub queue: Arc<wgpu::Queue>,
//     pub swapchain_format: Option<TextureFormat>,
//     pub swapchain_mode: Option<PresentMode>,
//     pub adapter: wgpu::Adapter,
//     /// If this is true, we don't need to use blocking device.polls, since they are assumed to be polled elsewhere
//     pub will_be_polled: bool,
//     pub view:Option<Arc<Window>>,
// }
impl Component for Gpu {
    type Storage = VecStorage<Self>;
}
