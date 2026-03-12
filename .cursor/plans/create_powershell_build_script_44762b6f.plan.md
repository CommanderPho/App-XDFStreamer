---
name: Create PowerShell Build Script
overview: Create a Windows PowerShell script in a `scripts` folder that automates the complete build process for XDFStreamer, including dependency setup (libxdf and liblsl) and the main application build.
todos: []
---

# Create PowerShell Build Script for XDFStreamer

## Overview

Create a PowerShell script (`scripts/build.ps1`) that automates the complete build process for XDFStreamer based on the instructions in README.md lines 89-144, plus the main app build steps.

## Implementation Details

### Script Location

- Create `scripts/build.ps1` in the App-XDFStreamer root directory
- Script will auto-detect project root from its own location (portable)

### Directory Structure

All dependencies and builds will be contained within the project folder:

```
App-XDFStreamer/
├── scripts/
│   └── build.ps1
├── EXTERNAL/
│   ├── libxdf/
│   │   └── build/
│   │       └── install/          # Local libxdf installation
│   └── liblsl/
│       └── build/
│           └── install/          # Local liblsl installation
└── build/                         # Main app build directory
    └── install/                   # Optional: local app installation
```

### Build Process

1. **Setup Phase**

- Auto-detect project root: `$PSScriptRoot/..` (parent of scripts folder)
- Create `EXTERNAL` directory if it doesn't exist
- Set error handling: `$ErrorActionPreference = "Stop"`

2. **Build libxdf**

- Navigate to `EXTERNAL` directory
- Clone `https://github.com/xdf-modules/libxdf` (with `--recursive`) if not already present
- Configure with CMake:
- Architecture: x64
- Install prefix: `{PROJECT_ROOT}/EXTERNAL/libxdf/build/install`
- Flags: `-DBUILD_SHARED_LIBS=ON -DXDF_NO_SYSTEM_PUGIXML=ON`
- Build and install Release configuration

3. **Build liblsl**

- Clone `https://github.com/sccn/liblsl` (with `--recursive`) if not already present
- Configure with CMake:
- Architecture: x64
- Install prefix: `{PROJECT_ROOT}/EXTERNAL/liblsl/build/install` (local installation)
- Build and install Release configuration (installs locally, not to system)

4. **Build Main Application**

- Return to project root
- Configure CMake with:
- Architecture: x64
- `-DLSL_INSTALL_ROOT="{PROJECT_ROOT}/EXTERNAL/liblsl/build/install/lib/cmake/LSL"` (local path)
- `-DXDF_INSTALL_ROOT="{PROJECT_ROOT}/EXTERNAL/libxdf/build/install/lib/cmake/libxdf"` (local path)
- `-DQt5_DIR` (may need to be configurable or detected via parameter/environment variable)
- `-DCMAKE_INSTALL_PREFIX="{PROJECT_ROOT}/build/install"` (optional: local install for app too)
- Build both Debug and Release configurations

### Script Features

- Error checking at each step
- Check if dependencies already exist before cloning
- Use forward slashes in paths for CMake compatibility
- Clear output messages for each build phase
- Handle both initial setup and rebuild scenarios

### Files to Create

- `scripts/build.ps1` - Main build script

### Considerations

- **Self-contained build**: All dependencies install to `EXTERNAL/{lib}/build/install` within the project folder
- **No system modifications**: Does not install to `C:/Program Files/` or other system locations
- **Portable**: Entire build is contained within the project directory
- Qt5_DIR path may need to be configurable via script parameter or environment variable (currently hardcoded in README as `L:/Qt/5.15.2/msvc2019_64/lib/cmake/Qt5`)
- Script assumes git and cmake are available in PATH
- May need to handle cases where dependencies are already built (check for existing directories)
- All paths use forward slashes for CMake compatibility and are relative to project root