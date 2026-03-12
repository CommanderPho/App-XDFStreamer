# XDF Streamer

XDF Streamer is a Qt C++ application that streams signals from [XDF](https://github.com/sccn/xdf) files to [lab streaming layer](https://github.com/sccn/labstreaminglayer).

![XDF Streamer](XdfStreamer.png "XDF Streamer")

## Download

You can find prebuilt distributions of XdfStreamer on [the releases page](https://github.com/labstreaminglayer/App-XDFStreamer/releases).

## Requirements

- __Qt__ >= 5.11
- [__liblsl__](https://github.com/sccn/liblsl/releases)
- [__libxdf__](https://github.com/xdf-modules/libxdf/releases)

## Build Instructions

If the dependencies are not installed to standard system folders then you will need to tell CMake where to find them. Add one or more of the following CMake arguments as needed:
* -DQt5_DIR=/volume/Qt/{platform}/lib/cmake/Qt5 
* -DLSL_INSTALL_ROOT=path/to/liblsl/unpack/
* -DXDF_INSTALL_ROOT=path/to/xdf/unpack/

If you are debugging or not intending to install to the system, then you need to change the install dir:
* -DCMAKE_INSTALL_PREFIX=${PWD}/build/install


## Pho Encountered Build Errors and Explanations/Fixes

```ps1
PS C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer> cmake --build build -j --config Debug
MSBuild version 17.14.23+b0019275e for .NET Framework

  1>Checking Build System
  Automatic MOC and UIC for target XDFStreamer
  Building Custom Rule C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/CMakeLists.txt
xdf.lib(xdf.obj) : error LNK2038: mismatch detected for '_ITERATOR_DEBUG_LEVEL': value '0' doesn't match value '2' in mocs_compilation_Debug.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
xdf.lib(xdf.obj) : error LNK2038: mismatch detected for 'RuntimeLibrary': value 'MD_DynamicRelease' doesn't match value 'MDd_DynamicDebug' in mocs_compilation_Debug.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
xdf.lib(pugixml.obj) : error LNK2038: mismatch detected for '_ITERATOR_DEBUG_LEVEL': value '0' doesn't match value '2' in mocs_compilation_Debug.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
xdf.lib(pugixml.obj) : error LNK2038: mismatch detected for 'RuntimeLibrary': value 'MD_DynamicRelease' doesn't match value 'MDd_DynamicDebug' in mocs_compilation_Debug.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
LINK : warning LNK4098: defaultlib 'MSVCRT' conflicts with use of other libs; use /NODEFAULTLIB:library [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\Debug\XDFStreamer.exe : fatal error LNK1319: 4 mismatches detected [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\build\XDFStreamer.vcxproj]
```
Happens either from the CLI or when trying to build in Visual Studio GUI -- indicates that the current `--config` (e.g. Debug or Release) doesn't match some previous libraries that have been built.

#### Building `liblsl`
```ps1
cd "C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\liblsl"
cmake --build build -j --config Debug --target install
cmake --build build -j --config Release --target install

```


#### Building `pugixml` is okay
```ps1
cd "C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\pugixml"
cmake --build build -j --config Debug --target install
cmake --build build -j --config Release


```

#### Building `libxdf`
```ps1
cd "C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf"
cmake -S . -B build -A x64 -DCMAKE_INSTALL_PREFIX="C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install" -DBUILD_SHARED_LIBS=ON -DXDF_NO_SYSTEM_PUGIXML=ON
cmake --build build -j --config Release
cmake --build build -j --config Debug
cmake --build build -j --config Release --target install
cmake --build build -j --config Debug --target install
```
#### ERROR:
```ps1
MSBuild version 17.14.23+b0019275e for .NET Framework

pugixml.lib(pugixml.obj) : error LNK2038: mismatch detected for '_ITERATOR_DEBUG_LEVEL': value '0' doesn't match value '2' in xdf.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf\build\xdf.vcxproj]
pugixml.lib(pugixml.obj) : error LNK2038: mismatch detected for 'RuntimeLibrary': value 'MD_DynamicRelease' doesn't match value 'MDd_DynamicDebug' in xdf.obj [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf\build\xdf.vcxproj]
LINK : warning LNK4098: defaultlib 'MSVCRT' conflicts with use of other libs; use /NODEFAULTLIB:library [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf\build\xdf.vcxproj]
C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf\build\Debug\xdf.dll : fatal error LNK1319: 2 mismatches detected [C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer\EXTERNAL\libxdf\build\xdf.vcxproj]
```
Fix: add the `-DXDF_NO_SYSTEM_PUGIXML=ON` argument so that the correct version of PUGIXML is built alongside the `libxdf` and then clear the build folder




### ---------------


## Pho Build 2025-09-09

```ps1
cd "C:/Users/pho/Desktop/LSL Tools/Pho LSL Repos/LSL_REPOS/App-XDFStreamer"
# cd "C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer"

mkdir EXTERNAL
cd .\EXTERNAL\


## libxdf
git clone --recursive https://github.com/xdf-modules/libxdf
# cmake -S . -B build -A x64 -DCMAKE_INSTALL_PREFIX="C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install" -DBUILD_SHARED_LIBS=ON
cmake -S . -B build -A x64 -DCMAKE_INSTALL_PREFIX="C:/Users/pho/Desktop/LSL Tools/Pho LSL Repos/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install" -DBUILD_SHARED_LIBS=ON -DXDF_NO_SYSTEM_PUGIXML=ON
cmake --build build -j --config Release --target install

  Generating Code...
  xdf.vcxproj -> C:\Users\pho\repos\EmotivEpoc\App-XDFStreamer\EXTERNAL\libxdf\build\Release\xdf.dll
  Building Custom Rule C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/CMakeLists.txt
  1>
  -- Install configuration: "Release"
  -- Installing: C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/include/xdf.h
  -- Installing: C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf/libxdfTargets.cmake
  -- Installing: C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf/libxdfTargets-release.cmake
  -- Installing: C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf/libxdfConfig.cmake

## liblsl
git clone --recursive https://github.com/sccn/liblsl
cmake -S . -B build -A x64
cmake --build build -j --config Release --target install


  lslver.vcxproj -> C:\Users\pho\repos\EmotivEpoc\App-XDFStreamer\EXTERNAL\liblsl\build\Release\lslver.exe
  Building Custom Rule C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/liblsl/CMakeLists.txt
  1>
  -- Install configuration: "Release"
  -- Installing: C:/Program Files/liblsl/lib/lsl.lib
  -- Installing: C:/Program Files/liblsl/bin/lsl.dll
  -- Installing: C:/Program Files/liblsl/include/lsl_c.h
  -- Installing: C:/Program Files/liblsl/include/lsl_cpp.h
  -- Installing: C:/Program Files/liblsl/include/lsl/common.h
  -- Installing: C:/Program Files/liblsl/include/lsl/inlet.h
  -- Installing: C:/Program Files/liblsl/include/lsl/outlet.h
  -- Installing: C:/Program Files/liblsl/include/lsl/resolver.h
  -- Installing: C:/Program Files/liblsl/include/lsl/streaminfo.h
  -- Installing: C:/Program Files/liblsl/include/lsl/types.h
  -- Installing: C:/Program Files/liblsl/include/lsl/xml.h
  -- Installing: C:/Program Files/liblsl/lib/cmake/LSL/LSLConfig.cmake
  -- Installing: C:/Program Files/liblsl/lib/cmake/LSL/LSLConfig-release.cmake
  -- Installing: C:/Program Files/liblsl/lib/cmake/LSL/LSLCMake.cmake
  -- Installing: C:/Program Files/liblsl/lib/cmake/LSL/LSLConfigVersion.cmake
  -- Installing: C:/Program Files/liblsl/bin/lslver.exe
```


```


cmake -S . -B build -A x64 -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL" -DXDF_INSTALL_ROOT="C:/Program Files/libxdf/lib/cmake/libxdf" -DQt5_DIR="L:\Qt\5.15.2\msvc2019_64\lib\cmake\Qt5" 

* -DQt5_DIR="L:\Qt\5.15.2\msvc2019_64\lib\cmake\Qt5" 
* -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL"
* -DXDF_INSTALL_ROOT="C:/Program Files/libxdf/lib/cmake/libxdf"
-Dpugixml_DIR="C:/Users/pho/Desktop/LSL Tools/Pho LSL Repos/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/pugixml"

cd "C:\Users\pho\Desktop\LSL Tools\Pho LSL Repos\LSL_REPOS\App-XDFStreamer"
cmake -S . -B build -A x64 -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL" -DXDF_INSTALL_ROOT="C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf" -DQt5_DIR="L:\Qt\5.15.2\msvc2019_64\lib\cmake\Qt5" 



cd "C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer"
cmake -S . -B build -A x64 -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL" -DXDF_INSTALL_ROOT="C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf" -DQt5_DIR="L:/Qt/5.15.2/msvc2019_64/lib/cmake/Qt5" 
<!-- cmake --build build -j --config Release --target install -->
cmake --build build -j --config Debug
cmake --build build -j --config Release


```
