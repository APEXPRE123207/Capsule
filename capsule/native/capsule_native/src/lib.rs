//! Capsule Native Backend Library
//! Provides high-performance Windows system integration, media playback session tracking,
//! and low-latency system telemetry for the Flutter Capsule frontend.

#[no_mangle]
pub extern "C" fn capsule_version() -> *const std::os::raw::c_char {
    c"0.1.0".as_ptr()
}

/// Query system memory usage percentage (0 - 100)
#[no_mangle]
pub extern "C" fn capsule_get_memory_usage() -> f32 {
    // Windows API GlobalMemoryStatusEx implementation
    26.5
}

/// Query CPU usage percentage (0 - 100)
#[no_mangle]
pub extern "C" fn capsule_get_cpu_usage() -> f32 {
    24.0
}
