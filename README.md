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

## Pho Build 2025-09-09

```ps1
# cd "C:/Users/pho/Desktop/LSL Tools/Pho LSL Repos/LSL_REPOS/App-XDFStreamer"
cd "C:\Users\pho\repos\EmotivEpoc\LSL_REPOS\App-XDFStreamer"

mkdir EXTERNAL
cd .\EXTERNAL\

git clone --recursive https://github.com/xdf-modules/libxdf
# cmake -S . -B build -A x64 -DCMAKE_INSTALL_PREFIX="C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install" -DBUILD_SHARED_LIBS=ON
cmake -S . -B build -A x64 -DCMAKE_INSTALL_PREFIX="C:/Users/pho/Desktop/LSL Tools/Pho LSL Repos/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install" -DBUILD_SHARED_LIBS=ON
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


C:\Users\pho\Desktop\LSL Tools\Pho LSL Repos\LSL_REPOS\App-XDFStreamer
cmake -S . -B build -A x64 -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL" -DXDF_INSTALL_ROOT="C:/Users/pho/repos/EmotivEpoc/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf" -DQt5_DIR="L:\Qt\5.15.2\msvc2019_64\lib\cmake\Qt5" 



C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer
cmake -S . -B build -A x64 -DLSL_INSTALL_ROOT="C:/Program Files/liblsl/lib/cmake/LSL" -DXDF_INSTALL_ROOT="C:/Users/pho/repos/EmotivEpoc/LSL_REPOS/App-XDFStreamer/EXTERNAL/libxdf/build/install/lib/cmake/libxdf" -DQt5_DIR="L:/Qt/5.15.2/msvc2019_64/lib/cmake/Qt5" 




```
