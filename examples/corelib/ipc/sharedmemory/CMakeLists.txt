# Generated from sharedmemory.pro.

cmake_minimum_required(VERSION 3.14)
project(sharedmemory LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/corelib/ipc/sharedmemory")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(sharedmemory
    dialog.cpp dialog.h dialog.ui
    main.cpp
)
target_link_libraries(sharedmemory PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Widgets
)

install(TARGETS sharedmemory
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
