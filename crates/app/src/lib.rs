use ambient_native_std::{
    asset_cache::{AssetCache, SyncAssetKeyExt,SyncAssetKey},
    asset_url::{ContentBaseUrlKey, UsingLocalDebugAssetsKey},
    download_asset::AssetsCacheOnDisk,
    download_asset::ReqwestClientKey,
};
use ambient_settings::SettingsKey;

pub mod client;
mod shared;

use ambient_physics::physx::PhysicsKey;
use anyhow::Context;
use serde::Deserialize;
use winit::event_loop::EventLoop;
use std::path::Path;
use ambient_network::native::client::ResolvedAddr;
use std::path::PathBuf;
#[cfg(target_os = "android")]
use winit::platform::android::activity::AndroidApp;
use ambient_audio::AudioStream;
use ambient_app::AppWrapper;
#[cfg(target_os = "android")]
pub fn new_main(eventloop:EventLoop<()>,android_app:AndroidApp){
    tracing::info!("start main..");
    ambient_dirs::init(android_app.clone());

    ambient_git_rev_init::init().expect("Should be called exactly once");

    shared::components::init().unwrap();

    let audio_bool = false;
    let audio_stream = if audio_bool {
        match AudioStream::new() {
            Ok(v) => Some(v),
            Err(err) => {
                tracing::error!("Failed to initialize audio stream: {err}");
                None
            }
        }
    } else {
        None
    };

    let is_debug = false;
    //box_init();

    tracing::info!("before event_loop");
    let  aw = AppWrapper::new_with_event_loop(eventloop);

    tracing::info!("after event_loop");


    // let status = aw.run_blocking(client::init2,android_app,Box::new(||{
    //     //shared::components::init().unwrap();

    // }));


}
use glam::{uvec2};
static mut QUIT:bool = false;
static mut LOADED:bool = false;
#[cfg(target_os="ios")]
pub fn new(){
    let mut rt = ambient_sys::task::make_native_multithreaded_runtime().unwrap();

    let runtime = rt.handle();
    let assets: AssetCache = AssetCache::new(runtime.clone());
    let _settings = SettingsKey.get(&assets);
    //box_c();
    let in_size: winit::dpi::PhysicalSize<u32> = self.window.clone().unwrap().inner_size();
    let width = in_size.width;
    let height = in_size.height;
    let headless = Some(uvec2(width, height));
    let scale_factor = self
    .window
    .as_ref()
    .map(|x| x.scale_factor() as f32)
    .unwrap_or(1.) as f64;
    tracing::info!("scale_factor {:?}",scale_factor);
    rt.block_on(async move {
        let mut app = AppBuilder::new()
            .ui_renderer(true)
            .with_asset_cache(assets)
            .headless(headless)
            .update_title_with_fps_stats(false)
            .build(window).await.unwrap();

        *app.world.resource_mut(window_scale_factor()) = scale_factor;

        i_c.call(&mut app,android_app_c).await;
        *app_.lock() = Some(app);
        unsafe{
            LOADED = true;
        }
        //use tokio::time::{sleep, Duration};
        let quit = unsafe{
            QUIT
        };
        use std::time::{Duration};
        use std::thread::sleep;
        loop{
            sleep(Duration::new(5,0));

        }
    });
}