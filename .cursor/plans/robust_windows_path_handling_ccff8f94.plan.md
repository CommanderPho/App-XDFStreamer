---
name: Robust Windows Path Handling
overview: Refactor the build script to use robust Windows path handling by maintaining native Windows paths internally and converting to forward slashes only when needed for CMake, using proper PowerShell path functions consistently.
todos: []
---

# Robust Windows Path Handling

## Current Issues

1. **Inconsistent path formats**: Mixing forward slashes and backslashes throughout
2. **Join-Path with forward slashes**: Lines 29-36 use `Join-Path` with already-converted forward-slash paths, which is incorrect
3. **Missing parentheses**: Line 259 has `Join-Path` without parentheses before `-replace`
4. **Path resolution**: Converting to forward slashes before proper resolution
5. **Test-Path usage**: Using forward-slash paths with `Test-Path` (works but inconsistent)
6. **Push-Location**: Using forward-slash paths (works but inconsistent)
7. **Archive path handling**: Complex conversion logic that's error-prone

## Solution Strategy

### Core Principle

- **Maintain native Windows paths** (backslashes) internally for all file system operations
- **Convert to forward slashes** only when passing paths to CMake
- Use PowerShell's native path functions (`Join-Path`, `Resolve-Path`) with native Windows paths

### Implementation

1. **Create helper functions**:

   - `ConvertTo-CMakePath`: Converts Windows path to forward-slash format for CMake
   - `Get-NativePath`: Ensures path is in native Windows format

2. **Fix path initialization** (lines 14-36):

   - Keep `$ProjectRoot` in native Windows format initially
   - Use `Join-Path` with native paths
   - Create separate variables for CMake paths (forward slashes) vs Windows paths (backslashes)

3. **Fix all path operations**:

   - Use native Windows paths for: `Test-Path`, `New-Item`, `Push-Location`, `Resolve-Path`, file operations
   - Convert to forward slashes only for CMake arguments

4. **Fix archive path handling** (lines 64-127):

   - Use native Windows paths throughout
   - Simplify path resolution logic

5. **Fix line 259**:

   - Add parentheses around `Join-Path`
   - Use native path, then convert for CMake

## Files to Modify

- `scripts/build.ps1` - Comprehensive path handling refactor

## Detailed Changes

### Helper Functions (add after line 12)

```powershell
# Convert Windows path to CMake-compatible forward-slash format
function ConvertTo-CMakePath {
    param([string]$Path)
    return $Path -replace '\\', '/'
}

# Ensure path is in native Windows format
function Get-NativePath {
    param([string]$Path)
    $resolved = (Resolve-Path $Path -ErrorAction SilentlyContinue).Path
    if ($resolved) {
        return $resolved
    }
    return $Path -replace '/', '\'
}
```

### Path Variables (lines 14-36)

- Keep `$ProjectRoot` in native Windows format
- Create separate Windows path variables (for file operations)
- Create CMake path variables (forward slashes, for CMake only)

### All File Operations

- Use Windows path variables for `Test-Path`, `New-Item`, `Push-Location`, etc.
- Use CMake path variables only in CMake argument arrays

### Archive Section

- Simplify to use native Windows paths throughout
- Remove complex conversion logic

### Line 259 Fix

- Use native path with `Join-Path`, then convert for CMake