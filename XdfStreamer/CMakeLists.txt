# Minimal CMake build to import the existing Qt/qmake project
# This mirrors XdfStreamer.pro so the project can be opened as a CMake build.

cmake_minimum_required(VERSION 3.16)
project(XdfStreamer LANGUAGES CXX)

# Qt settings
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Try Qt6 first, then fall back to Qt5
find_package(Qt6 COMPONENTS Widgets QUIET)
if(NOT Qt6_FOUND)
    find_package(Qt5 REQUIRED COMPONENTS Widgets)
endif()

# Source files (mirrors .pro)
set(SRC
    main.cpp
    xdfstreamer.cpp
    ../EXTERNAL/libxdf/pugixml/pugixml.cpp
    ../EXTERNAL/libxdf/xdf.cpp
    xdfstreamer.ui
)

# Create the executable; WIN32 to avoid console window on Windows
add_executable(XdfStreamer WIN32 ${SRC})

# Include directories (match qmake project)
target_include_directories(XdfStreamer PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/extern/include
    ${CMAKE_CURRENT_LIST_DIR}/../EXTERNAL/liblsl/include
    ${CMAKE_CURRENT_LIST_DIR}/../EXTERNAL/libxdf
    ${CMAKE_CURRENT_LIST_DIR}/../EXTERNAL/libxdf/pugixml
)

# Link against Qt Widgets
if(Qt6_FOUND)
    target_link_libraries(XdfStreamer PRIVATE Qt6::Widgets)
else()
    target_link_libraries(XdfStreamer PRIVATE Qt5::Widgets)
endif()

# Link against liblsl built in the EXTERNAL tree.
# The qmake project uses different output dirs for Debug/Release.
# Adjust these paths if your liblsl build directory differs.
set(LSL_BUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/../EXTERNAL/liblsl/build)
target_link_directories(XdfStreamer PRIVATE
    $<IF:$<CONFIG:Debug>,${LSL_BUILD_DIR}/Debug,${LSL_BUILD_DIR}/Release>
)
target_link_libraries(XdfStreamer PRIVATE lsl)

# Icon: If you have a .rc file for the icon, add it here. The .pro references xdfstreamer.ico
# You can integrate it later with a resource script if desired.

# Notes:
# - We compile pugixml from source as done in the .pro. Do not also link a prebuilt pugixml lib.
# - If your environment provides an installed liblsl, you can replace the manual link directories
#   with find_library/find_package usage.
