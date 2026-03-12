# XDFStreamer Build Script
# Self-contained build script that installs all dependencies locally within the project folder

param(
    [string]$Qt5_DIR = $env:Qt5_DIR,
    [switch]$SkipDependencies = $false,
    [string]$Config = "Release",
    [switch]$ArchivePrevious = $false
)

# Set error handling
$ErrorActionPreference = "Stop"

# Helper function: Convert Windows path to CMake-compatible forward-slash format
function ConvertTo-CMakePath {
    param([string]$Path)
    return $Path -replace '\\', '/'
}

# Helper function: Ensure path is in native Windows format
function Get-NativePath {
    param([string]$Path)
    $resolved = (Resolve-Path $Path -ErrorAction SilentlyContinue).Path
    if ($resolved) {
        return $resolved
    }
    return $Path -replace '/', '\'
}

# Auto-detect project root (parent of scripts folder) - keep in native Windows format
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# Ensure single string value (in case Resolve-Path returns multiple)
if ($ProjectRoot -is [array]) {
    $ProjectRoot = $ProjectRoot[0]
}
# Keep ProjectRoot in native Windows format for file operations

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "XDFStreamer Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Green
Write-Host ""

# Build paths in native Windows format (for file operations)
$ExternalDir = Join-Path $ProjectRoot "EXTERNAL"
$LibXdfDir = Join-Path $ExternalDir "libxdf"
$LibLslDir = Join-Path $ExternalDir "liblsl"
$LibXdfBuildDir = Join-Path $LibXdfDir "build"
$LibLslBuildDir = Join-Path $LibLslDir "build"
$LibXdfInstallPrefix = Join-Path $LibXdfDir "build" | Join-Path -ChildPath "install"
$LibLslInstallPrefix = Join-Path $LibLslDir "build" | Join-Path -ChildPath "install"
$BuildDir = Join-Path $ProjectRoot "build"

# Create CMake-compatible paths (forward slashes) for CMake arguments only
$ProjectRootCMake = ConvertTo-CMakePath $ProjectRoot
$ExternalDirCMake = ConvertTo-CMakePath $ExternalDir
$LibXdfDirCMake = ConvertTo-CMakePath $LibXdfDir
$LibLslDirCMake = ConvertTo-CMakePath $LibLslDir
$LibXdfInstallPrefixCMake = ConvertTo-CMakePath $LibXdfInstallPrefix
$LibLslInstallPrefixCMake = ConvertTo-CMakePath $LibLslInstallPrefix
$BuildDirCMake = ConvertTo-CMakePath $BuildDir

# Function to find 7z.exe
function Find-7Zip {
    $paths = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe",
        "$env:ProgramFiles\7-Zip\7z.exe",
        "$env:ProgramFiles(x86)\7-Zip\7z.exe"
    )
    
    # Check PATH
    $7zInPath = Get-Command 7z.exe -ErrorAction SilentlyContinue
    if ($7zInPath) {
        return $7zInPath.Path
    }
    
    # Check common installation paths
    foreach ($path in $paths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    return $null
}

# Archive previous build products if requested
if ($ArchivePrevious) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Archiving Previous Build Products..." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    # Find 7z.exe
    $7zPath = Find-7Zip
    if (-not $7zPath) {
        throw "7-Zip not found. Please install 7-Zip or add it to your PATH. Download from: https://www.7-zip.org/"
    }
    
    # Check if there are any build products to archive
    $itemsToArchive = @()
    if (Test-Path $BuildDir) {
        $itemsToArchive += $BuildDir
    }
    if (Test-Path $LibXdfBuildDir) {
        $itemsToArchive += $LibXdfBuildDir
    }
    if (Test-Path $LibLslBuildDir) {
        $itemsToArchive += $LibLslBuildDir
    }
    
    if ($itemsToArchive.Count -eq 0) {
        Write-Host "No previous build products found to archive." -ForegroundColor Yellow
    } else {
        # Generate archive filename with datetime
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $archiveName = "build_backup_$timestamp.7z"
        $archivePath = Join-Path $ProjectRoot $archiveName
        
        Write-Host "Creating archive: $archiveName" -ForegroundColor Yellow
        Write-Host "Archiving:" -ForegroundColor Yellow
        
        # Resolve all paths to ensure proper Windows format
        $itemsToArchiveResolved = @()
        foreach ($item in $itemsToArchive) {
            $resolvedPath = (Resolve-Path $item).Path
            $itemsToArchiveResolved += $resolvedPath
            Write-Host "  - $resolvedPath" -ForegroundColor White
        }
        
        # Build 7z arguments with resolved Windows paths
        $7zArgs = @("a", "-t7z", "-mx=9", "`"$archivePath`"")
        foreach ($item in $itemsToArchiveResolved) {
            $7zArgs += "`"$item`""
        }
        
        & $7zPath $7zArgs
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create archive"
        }
        
        $archiveSize = (Get-Item $archivePath).Length / 1MB
        Write-Host "Archive created successfully: $archiveName ($([math]::Round($archiveSize, 2)) MB)" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Create EXTERNAL directory if it doesn't exist
if (-not (Test-Path $ExternalDir)) {
    Write-Host "Creating EXTERNAL directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $ExternalDir -Force | Out-Null
}

# Build libxdf
if (-not $SkipDependencies) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Building libxdf..." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    Push-Location $ExternalDir
    
    # Clone libxdf if it doesn't exist
    if (-not (Test-Path $LibXdfDir)) {
        Write-Host "Cloning libxdf repository..." -ForegroundColor Yellow
        git clone --recursive https://github.com/xdf-modules/libxdf
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone libxdf repository"
        }
    } else {
        Write-Host "libxdf repository already exists, skipping clone." -ForegroundColor Green
    }
    
    Push-Location $LibXdfDir
    
    # Configure libxdf
    Write-Host "Configuring libxdf with CMake..." -ForegroundColor Yellow
    $cmakeArgs = @(
        "-S", ".",
        "-B", "build",
        "-A", "x64",
        "-DCMAKE_INSTALL_PREFIX=`"$LibXdfInstallPrefixCMake`"",
        "-DBUILD_SHARED_LIBS=ON",
        "-DXDF_NO_SYSTEM_PUGIXML=ON"
    )
    & cmake $cmakeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to configure libxdf"
    }
    
    # Build and install libxdf
    Write-Host "Building and installing libxdf (Release)..." -ForegroundColor Yellow
    & cmake --build build -j --config Release --target install
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to build libxdf"
    }
    
    Pop-Location
    Pop-Location
    
    Write-Host "libxdf build completed successfully!" -ForegroundColor Green
    Write-Host ""
}

# Build liblsl
if (-not $SkipDependencies) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Building liblsl..." -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    Push-Location $ExternalDir
    
    # Clone liblsl if it doesn't exist
    if (-not (Test-Path $LibLslDir)) {
        Write-Host "Cloning liblsl repository..." -ForegroundColor Yellow
        git clone --recursive https://github.com/sccn/liblsl
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone liblsl repository"
        }
    } else {
        Write-Host "liblsl repository already exists, skipping clone." -ForegroundColor Green
    }
    
    Push-Location $LibLslDir
    
    # Configure liblsl with local install prefix
    Write-Host "Configuring liblsl with CMake..." -ForegroundColor Yellow
    $cmakeArgs = @(
        "-S", ".",
        "-B", "build",
        "-A", "x64",
        "-DCMAKE_INSTALL_PREFIX=`"$LibLslInstallPrefixCMake`""
    )
    & cmake $cmakeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to configure liblsl"
    }
    
    # Build and install liblsl
    Write-Host "Building and installing liblsl (Release)..." -ForegroundColor Yellow
    & cmake --build build -j --config Release --target install
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to build liblsl"
    }
    
    Pop-Location
    Pop-Location
    
    Write-Host "liblsl build completed successfully!" -ForegroundColor Green
    Write-Host ""
}

# Build main application
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building XDFStreamer application..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Push-Location $ProjectRoot

# Prepare CMake arguments for main app
$cmakeArgs = @(
    "-S", ".",
    "-B", "build",
    "-A", "x64",
    "-DLSL_INSTALL_ROOT=`"$LibLslInstallPrefixCMake/lib/cmake/LSL`"",
    "-DXDF_INSTALL_ROOT=`"$LibXdfInstallPrefixCMake/lib/cmake/libxdf`""
)

# Add Qt5_DIR if provided
if ($Qt5_DIR) {
    $Qt5_DIR_CMake = ConvertTo-CMakePath $Qt5_DIR
    $cmakeArgs += "-DQt5_DIR=`"$Qt5_DIR_CMake`""
    Write-Host "Using Qt5_DIR: $Qt5_DIR_CMake" -ForegroundColor Yellow
} else {
    Write-Host "Warning: Qt5_DIR not specified. Set it via -Qt5_DIR parameter or Qt5_DIR environment variable." -ForegroundColor Yellow
}

# Add local install prefix for app
$AppInstallPrefix = Join-Path $ProjectRoot "build" | Join-Path -ChildPath "install"
$AppInstallPrefixCMake = ConvertTo-CMakePath $AppInstallPrefix
$cmakeArgs += "-DCMAKE_INSTALL_PREFIX=`"$AppInstallPrefixCMake`""

# Configure main application
Write-Host "Configuring XDFStreamer with CMake..." -ForegroundColor Yellow
& cmake $cmakeArgs
if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure XDFStreamer"
}

# Build both Debug and Release configurations
Write-Host "Building XDFStreamer (Debug)..." -ForegroundColor Yellow
& cmake --build build -j --config Debug
if ($LASTEXITCODE -ne 0) {
    throw "Failed to build XDFStreamer (Debug)"
}

Write-Host "Building XDFStreamer (Release)..." -ForegroundColor Yellow
& cmake --build build -j --config Release
if ($LASTEXITCODE -ne 0) {
    throw "Failed to build XDFStreamer (Release)"
}

Pop-Location

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Build outputs:" -ForegroundColor Yellow
Write-Host "  Debug:   $(Join-Path $BuildDir "Debug\XDFStreamer.exe")" -ForegroundColor White
Write-Host "  Release: $(Join-Path $BuildDir "Release\XDFStreamer.exe")" -ForegroundColor White
Write-Host ""
Write-Host "Dependencies installed locally:" -ForegroundColor Yellow
Write-Host "  libxdf: $LibXdfInstallPrefix" -ForegroundColor White
Write-Host "  liblsl: $LibLslInstallPrefix" -ForegroundColor White
Write-Host ""
