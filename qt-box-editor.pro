TEMPLATE = app
QTB_VERSION = "1.13dev"
TARGET = qt-box-editor-$${QTB_VERSION}
DEFINES += APP_VERSION=\\\"$${QTB_VERSION}\\\"
DESTDIR = .

DEPENDPATH += ./ \
    resource/images \
    resource

INCLUDEPATH += ./ \
    dialogs \
    src/include \
    src

QT += network svg

CONFIG(debug, debug|release) {
    CONFIG += debug warn_on
    DESTDIR = debug
    QT += testlib
    OBJECTS_DIR += build/debug
    MOC_DIR += build/debug
    UI_DIR += build/debug
    RCC_DIR += build/debug
} else {
    CONFIG += release warn_off
    DESTDIR = release
    OBJECTS_DIR += build/release
    MOC_DIR += build/release
    UI_DIR += build/release
    RCC_DIR += build/release
}

FORMS += \
    dialogs/ShortCutDialog.ui \
    dialogs/GetRowIDDialog.ui \
    dialogs/SettingsDialog.ui \
    dialogs/FindDialog.ui \
    dialogs/DrawRectangle.ui

SOURCES += src/main.cpp \
    src/MainWindow.cpp \
    src/ChildWidget.cpp \
    src/DelegateEditors.cpp \
    src/TessTools.cpp \
    dialogs/SettingsDialog.cpp \
    dialogs/GetRowIDDialog.cpp \
    dialogs/ShortCutsDialog.cpp \
    dialogs/FindDialog.cpp \
    dialogs/DrawRectangle.cpp

HEADERS += src/MainWindow.h \
    src/ChildWidget.h \
    src/Settings.h \
    src/TessTools.h \
    src/DelegateEditors.h \
    dialogs/SettingsDialog.h \
    dialogs/GetRowIDDialog.h \
    dialogs/ShortCutsDialog.h \
    dialogs/FindDialog.h \
    dialogs/DrawRectangle.h

RESOURCES = resources/application.qrc \
    resources/QBE-GNOME.qrc \
    resources/QBE-Faenza.qrc \
    resources/QBE-Oxygen.qrc \
    resources/QBE-Tango.qrc

win32 {
    # DESTDIR = ./win32
    CONFIG += embed_manifest_exe
    TMAKE_CXXFLAGS += -DQT_NODLL
    TMAKE_CXXFLAGS += -fno-exceptions -fno-rtti -static
    #QTPLUGIN += qsvg # image formats
    DEFINES += WINDOWS
    #QMAKE_LFLAGS.gcc += -static-libgcc # -static
    RC_FILE = resources/win.rc
    INCLUDEPATH += $$PWD/win32-external/include/
    LIBS += -lws2_32 -L$$PWD/win32-external/lib
}

win32:CONFIG(debug, debug|release) {
    TARGET = $$join(TARGET,,,d)
    LIBS += -ltesseract35d -lleptonica-1.76.0d
} else {
    LIBS += -ltesseract35 -lleptonica-1.76.0
}

unix:!macx {
    greaterThan(QT_MAJOR_VERSION, 5) {
      message(Qt $$[QT_VERSION] was detected.)
      QT += widgets
      INCLUDEPATH += /opt/include/
      LIBS += -L/opt/lib -ltesseract -llept
      QMAKE_CXXFLAGS += -std=c++11
      CONFIG += c++11
    }
}

# Libraries may be installed this way on Mac OS X:
# brew install leptonica
# brew install --training-tools --all-languages --HEAD https://gist.githubusercontent.com/fake-or-dead/8f1e817681847b689d2d/raw/915a5f6726a7aced6d75b902959fda1ae2d559c7/tesseract.rb
#
# TESSDATE_PREFIX in the Settings of the App is: /usr/local/share/
# Then close Settings and reopen Settings to select the language
macx {
    message(Starting OSX build...)
    QT += widgets
    INCLUDEPATH += /usr/local/include/
    LIBS += -L/usr/local/lib
}
