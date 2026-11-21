//! Capsule Native Backend Library
//! Implements Windows system telemetry, Core Audio endpoint volume controls,
//! Windows native OCR, and desktop wallpaper integration.

use std::ffi::{c_char, c_float, c_int, CStr};
use std::sync::atomic::{AtomicU64, Ordering};

#[no_mangle]
pub extern "C" fn capsule_version() -> *const c_char {
    c"0.1.0".as_ptr()
}

// ---------------------------------------------------------------------------
// 1. System Memory & CPU Telemetry
// ---------------------------------------------------------------------------

#[cfg(windows)]
use windows::Win32::System::SystemInformation::{GlobalMemoryStatusEx, MEMORYSTATUSEX};
#[cfg(windows)]
use windows::Win32::System::Threading::GetSystemTimes;
#[cfg(windows)]
use windows::Win32::Foundation::FILETIME;

static LAST_IDLE_TIME: AtomicU64 = AtomicU64::new(0);
static LAST_KERNEL_TIME: AtomicU64 = AtomicU64::new(0);
static LAST_USER_TIME: AtomicU64 = AtomicU64::new(0);

#[inline]
fn filetime_to_u64(ft: &FILETIME) -> u64 {
    ((ft.dwHighDateTime as u64) << 32) | (ft.dwLowDateTime as u64)
}

/// Returns real-time system RAM usage percentage (0.0 to 100.0)
#[no_mangle]
pub extern "C" fn capsule_get_memory_usage() -> c_float {
    #[cfg(windows)]
    unsafe {
        let mut status = MEMORYSTATUSEX {
            dwLength: std::mem::size_of::<MEMORYSTATUSEX>() as u32,
            ..Default::default()
        };
        if GlobalMemoryStatusEx(&mut status).is_ok() {
            return status.dwMemoryLoad as c_float;
        }
    }
    0.0
}

/// Returns real-time CPU utilization percentage (0.0 to 100.0)
#[no_mangle]
pub extern "C" fn capsule_get_cpu_usage() -> c_float {
    #[cfg(windows)]
    unsafe {
        let mut idle = FILETIME::default();
        let mut kernel = FILETIME::default();
        let mut user = FILETIME::default();

        if GetSystemTimes(Some(&mut idle), Some(&mut kernel), Some(&mut user)).is_ok() {
            let i = filetime_to_u64(&idle);
            let k = filetime_to_u64(&kernel);
            let u = filetime_to_u64(&user);

            let last_i = LAST_IDLE_TIME.swap(i, Ordering::Relaxed);
            let last_k = LAST_KERNEL_TIME.swap(k, Ordering::Relaxed);
            let last_u = LAST_USER_TIME.swap(u, Ordering::Relaxed);

            if last_k > 0 && last_u > 0 {
                let sys = (k - last_k) + (u - last_u);
                let idl = i - last_i;
                if sys > 0 && sys >= idl {
                    return (((sys - idl) as f64 / sys as f64) * 100.0) as c_float;
                }
            }
        }
    }
    0.0
}

// ---------------------------------------------------------------------------
// 2. Windows Core Audio System Volume
// ---------------------------------------------------------------------------

#[cfg(windows)]
use windows::Win32::System::Com::{CoCreateInstance, CoInitializeEx, CLSCTX_ALL, COINIT_MULTITHREADED};
#[cfg(windows)]
use windows::Win32::Media::Audio::{
    Endpoints::IAudioEndpointVolume,
    eConsole, eRender, MMDeviceEnumerator, IMMDeviceEnumerator,
};

/// Queries master system output volume (0.0 to 1.0)
#[no_mangle]
pub extern "C" fn capsule_get_system_volume() -> c_float {
    #[cfg(windows)]
    unsafe {
        let _ = CoInitializeEx(None, COINIT_MULTITHREADED);
        if let Ok(enumerator) = CoCreateInstance::<_, IMMDeviceEnumerator>(&MMDeviceEnumerator, None, CLSCTX_ALL) {
            if let Ok(device) = enumerator.GetDefaultAudioEndpoint(eRender, eConsole) {
                if let Ok(endpoint) = device.Activate::<IAudioEndpointVolume>(CLSCTX_ALL, None) {
                    let mut level: f32 = 0.0;
                    if endpoint.GetMasterVolumeLevelScalar(&mut level).is_ok() {
                        return level;
                    }
                }
            }
        }
    }
    0.5
}

/// Sets master system output volume (0.0 to 1.0)
#[no_mangle]
pub extern "C" fn capsule_set_system_volume(level: c_float) -> c_int {
    #[cfg(windows)]
    unsafe {
        let _ = CoInitializeEx(None, COINIT_MULTITHREADED);
        if let Ok(enumerator) = CoCreateInstance::<_, IMMDeviceEnumerator>(&MMDeviceEnumerator, None, CLSCTX_ALL) {
            if let Ok(device) = enumerator.GetDefaultAudioEndpoint(eRender, eConsole) {
                if let Ok(endpoint) = device.Activate::<IAudioEndpointVolume>(CLSCTX_ALL, None) {
                    if endpoint.SetMasterVolumeLevelScalar(level.clamp(0.0, 1.0), std::ptr::null()).is_ok() {
                        return 1;
                    }
                }
            }
        }
    }
    0
}

/// Sets master system mute state (1 = mute, 0 = unmute)
#[no_mangle]
pub extern "C" fn capsule_set_system_mute(mute: c_int) -> c_int {
    #[cfg(windows)]
    unsafe {
        let _ = CoInitializeEx(None, COINIT_MULTITHREADED);
        if let Ok(enumerator) = CoCreateInstance::<_, IMMDeviceEnumerator>(&MMDeviceEnumerator, None, CLSCTX_ALL) {
            if let Ok(device) = enumerator.GetDefaultAudioEndpoint(eRender, eConsole) {
                if let Ok(endpoint) = device.Activate::<IAudioEndpointVolume>(CLSCTX_ALL, None) {
                    if endpoint.SetMute(mute != 0, std::ptr::null()).is_ok() {
                        return 1;
                    }
                }
            }
        }
    }
    0
}

// ---------------------------------------------------------------------------
// 3. Desktop Wallpaper API
// ---------------------------------------------------------------------------

#[cfg(windows)]
use windows::Win32::UI::WindowsAndMessaging::{
    SystemParametersInfoW, SPI_SETDESKWALLPAPER, SPIF_SENDCHANGE, SPIF_UPDATEINIFILE,
};

/// Sets the Windows desktop wallpaper given a local file path
#[no_mangle]
pub extern "C" fn capsule_set_wallpaper(path: *const c_char) -> c_int {
    #[cfg(windows)]
    unsafe {
        if path.is_null() {
            return 0;
        }
        if let Ok(c_str) = CStr::from_ptr(path).to_str() {
            use std::os::windows::ffi::OsStrExt;
            let wide: Vec<u16> = std::ffi::OsStr::new(c_str)
                .encode_wide()
                .chain(std::iter::once(0))
                .collect();

            let success = SystemParametersInfoW(
                SPI_SETDESKWALLPAPER,
                0,
                Some(wide.as_ptr() as *mut _),
                SPIF_UPDATEINIFILE | SPIF_SENDCHANGE,
            );
            return if success.is_ok() { 1 } else { 0 };
        }
    }
    0
}
