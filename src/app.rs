use std::time::Instant;
use log::debug;
use wgpu::{ColorTargetState, ColorWrites, InstanceFlags, PipelineCompilationOptions, PresentMode, SurfaceConfiguration, TextureViewDescriptor};
use winit::{
    event::{Event, WindowEvent},
    event_loop::{ControlFlow, EventLoop, EventLoopWindowTarget},
    window::Window,
};
use winit::dpi::PhysicalSize;
use raw_window_handle::{HasDisplayHandle, HasWindowHandle};
use std::sync::Arc;
const SHADER: &str = r#"
@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> @builtin(position) vec4<f32> {
    let x = f32(i32(in_vertex_index) - 1);
    let y = f32(i32(in_vertex_index & 1u) * 2 - 1);
    return vec4<f32>(x, y, 0.0, 1.0);
}

@fragment
fn fs_main() -> @location(0) vec4<f32> {
    return vec4<f32>(1.0, 0.0, 0.0, 1.0);
}
"#;

struct Renderer {
    render_pipeline: wgpu::RenderPipeline,
}

struct SurfaceState {
    surface: wgpu::Surface<'static>,
    view_format: wgpu::TextureFormat,
    alpha_mode: wgpu::CompositeAlphaMode,
}

struct App {
    instance: wgpu::Instance,
    renderer: Option<Renderer>,
    surface_state: Option<SurfaceState>,
    last_time: Instant,
    adapter: wgpu::Adapter,
    device: wgpu::Device,
    queue: wgpu::Queue,
}

impl App {
    async fn new() -> Self {
        let instance = wgpu::Instance::new(wgpu::InstanceDescriptor {
            backends: if cfg!(not(target_os = "android")) {
                wgpu::Backends::METAL
            } else {
                wgpu::Backends::METAL
            },
            dx12_shader_compiler: wgpu::Dx12Compiler::Dxc {
                dxc_path: None,
                dxil_path: None,
            },
            flags:InstanceFlags::all(),
            gles_minor_version:wgpu::Gles3MinorVersion::Automatic
        });
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                power_preference: wgpu::PowerPreference::default(),
                force_fallback_adapter: false,
                compatible_surface: None,
            })
            .await
            .expect("Failed to find an appropriate adapter");

        // Create the logical device and command queue
        let limits = wgpu::Limits::downlevel_webgl2_defaults();
        let (device, queue) = adapter
            .request_device(
                &wgpu::DeviceDescriptor {
                    label: None,
                    required_features: adapter.features(),
                    required_limits:adapter.limits(),
                    memory_hints:wgpu::MemoryHints::Performance
                },
                None,
            )
            .await
            .expect("Failed to create device");
        Self {
            instance,
            device,
            adapter,
            queue,
            renderer: None,
            surface_state: None,
            last_time: Instant::now(),
        }
    }

    async fn create_renderer(&mut self) {
        let shader = self.device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: None,
            source: wgpu::ShaderSource::Wgsl(SHADER.into()),
        });

        let pipeline_layout = self.device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: &[],
            push_constant_ranges: &[],
        });

        let render_pipeline = self.device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
            label: None,
            layout: Some(&pipeline_layout),
            vertex: wgpu::VertexState {
                module: &shader,
                entry_point: "vs_main",
                buffers: &[],
                compilation_options:PipelineCompilationOptions::default()
            },
            fragment: Some(wgpu::FragmentState {
                module: &shader,
                entry_point: "fs_main",
                targets: &[Some(ColorTargetState {
                    format: self.surface_state.as_ref().unwrap().view_format,
                    blend: None,
                    write_mask: ColorWrites::all(),
                })],
                compilation_options:PipelineCompilationOptions::default()
            }),
            primitive: wgpu::PrimitiveState::default(),
            depth_stencil: None,
            multisample: wgpu::MultisampleState::default(),
            multiview: None,
            cache:None
        });

        self.renderer = Some(Renderer {
            render_pipeline,
        });
    }

    fn setup_swapchain(&mut self, size: PhysicalSize<u32>,scale_factor:f64) {
        println!("size {:?} scale_factor {:?}",size, scale_factor);
        let surface_state = self.surface_state.as_ref().unwrap();
        let surface_configuration = SurfaceConfiguration {
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            format: surface_state.view_format,
            width:size.width,
            //width: size.width * scale_factor as u32,
            //height: size.height ,
            height:2048,
            present_mode: PresentMode::Fifo,
            alpha_mode: surface_state.alpha_mode,
            view_formats: vec![surface_state.view_format],
            desired_maximum_frame_latency:60
        };
        surface_state.surface.configure(&self.device, &surface_configuration);
    }

    fn resumed(&mut self, window:Arc<Window>) {

        let surface = unsafe {
            self.instance.create_surface(window.clone())
        }.unwrap();
        // let surface: wgpu::Surface =  self.instance.create_surface(&window).unwrap();
        let cap = surface.get_capabilities(&self.adapter);
        self.surface_state = Some(SurfaceState {
            surface,
            view_format: cap.formats[0],
            alpha_mode: cap.alpha_modes[0],
        });

        self.setup_swapchain(window.inner_size(),window.scale_factor());
        pollster::block_on(self.create_renderer());
    }

    fn suspended(&mut self) {
        self.renderer.take();
        self.surface_state.take();
    }

    fn resize(&mut self, window_size: PhysicalSize<u32>,scale_factor:f64) {
        self.setup_swapchain(window_size, scale_factor);
    }

    fn render(&mut self) {
        if let (Some(surface_state), Some(renderer)) = (&self.surface_state, &self.renderer) {
            let render_texture = surface_state.surface.get_current_texture().unwrap();
            let render_texture_view = render_texture.texture.create_view(&TextureViewDescriptor::default());

            let mut encoder = self.device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor { label: None });
            {
                let t = (self.last_time.elapsed().as_secs_f64() / 5.0).sin();
                let mut rpass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                    label: None,
                    color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                        view: &render_texture_view,
                        resolve_target: None,
                        ops: wgpu::Operations {
                            load: wgpu::LoadOp::Clear(wgpu::Color {
                                r: 0.0,
                                g: t,
                                b: 1.0 - t,
                                a: 1.0,
                            }),
                            store: wgpu::StoreOp::Store,
                        },
                    })],
                    depth_stencil_attachment: None,
                    timestamp_writes:None,
                    occlusion_query_set:None
                });
                rpass.set_pipeline(&renderer.render_pipeline);
                rpass.draw(0..3, 0..1);
            }

            self.queue.submit(Some(encoder.finish()));

            render_texture.present();
        }
    }
}

pub fn run<T: std::fmt::Debug>(mut event_loop: EventLoop<T>,window:Arc<Window>) {
    let mut app = pollster::block_on(App::new());
    let mut once = Arc::new(std::sync::Mutex::new(false));
    let _ = event_loop.run(move |event, event_loop| {
        match event {
            Event::WindowEvent {
                event: WindowEvent::Resized(size),
                ..
            } => {
                debug!("resized");
                if *once.lock().unwrap(){
                    app.resize(size,window.scale_factor());
                }
            }
            Event::Resumed => {
                debug!("resumed");
                println!("resumed");
                if !*once.lock().unwrap(){
                    app.resumed(window.clone());
                    app.render();
                }
                
                *once.lock().unwrap() = true;
            }
            Event::Suspended => {
                debug!("suspended");

                app.suspended();
            }
            Event::WindowEvent{
                event:WindowEvent::RedrawRequested,
                ..
            } => {
                debug!("main events cleared");
                println!("main events cleared");
                if *once.lock().unwrap(){
                    app.render();
                }
            }
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                ..
            } => {
                debug!("quit");
                println!("quit");
                event_loop.exit();
            }
            e => {
                debug!("other event {:?}", e);
            }
        }
    });
}