#-------------------------------------------------
#
# Project created by QtCreator 2018-07-28T10:15:17
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = XdfStreamer
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        xdfstreamer.cpp \
    ../EXTERNAL/libxdf/pugixml/pugixml.cpp \
    ../EXTERNAL/libxdf/xdf.cpp

HEADERS += \
        xdfstreamer.h \
    ../EXTERNAL/libxdf/pugixml/pugiconfig.hpp \
    ../EXTERNAL/libxdf/pugixml/pugixml.hpp \
    ../EXTERNAL/libxdf/xdf.h \
    extern/include/lsl_c.h \
    extern/include/lsl_cpp.h

FORMS += \
        xdfstreamer.ui

contains(QT_ARCH, i386) {
    # 32‑bit: adjust paths/names if you ever build 32‑bit
    win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../EXTERNAL/liblsl/build/Release -llsl
    else:win32:CONFIG(debug, debug|release):   LIBS += -L$$PWD/../EXTERNAL/liblsl/build/Debug   -llsl
} else {
    # 64‑bit (current kit)
    CONFIG(release, debug|release): LIBS += -L$$PWD/../EXTERNAL/liblsl/build/Release -llsl
    else:CONFIG(debug, debug|release):   LIBS += -L$$PWD/../EXTERNAL/liblsl/build/Debug   -llsl
}

#win32:CONFIG(release, debug|release): LIBS += -L$$PWD/extern/bin/ -lliblsl32
#else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/extern/bin/ -lliblsl32-debug
#else:win64:CONFIG(release, debug|release): LIBS += -L$$PWD/extern/bin/ -lliblsl64
#else:win64:CONFIG(debug, debug|release): LIBS += -L$$PWD/extern/bin/ -lliblsl64-debug
#else:unix: LIBS += -L$$PWD/extern/bin/ -lliblsl32

INCLUDEPATH += $$PWD/extern/include
DEPENDPATH += $$PWD/extern/include

RC_ICONS = xdfstreamer.ico


# Headers (for Qt Creator to see pugixml API)
INCLUDEPATH += $$PWD/../EXTERNAL/pugixml/src

# Link against built pugixml.lib
win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../EXTERNAL/pugixml/build/Release -lpugixml
win32:CONFIG(debug, debug|release):   LIBS += -L$$PWD/../EXTERNAL/pugixml/build/Debug   -lpugixml

# liblsl headers from EXTERNAL (for Qt Creator browsing)
INCLUDEPATH += $$PWD/../EXTERNAL/liblsl/include

# libxdf headers from EXTERNAL (for Qt Creator browsing)
INCLUDEPATH += $$PWD/../EXTERNAL/libxdf