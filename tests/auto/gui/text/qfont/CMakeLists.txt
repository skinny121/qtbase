# Generated from qfont.pro.

#####################################################################
## tst_qfont Test:
#####################################################################

add_qt_test(tst_qfont
    SOURCES
        tst_qfont.cpp
    PUBLIC_LIBRARIES
        Qt::CorePrivate
        Qt::Gui
        Qt::GuiPrivate
)

# Resources:
set(testfont_resource_files
    "weirdfont.otf"
)

add_qt_resource(tst_qfont "testfont"
    PREFIX
        "/"
    FILES
        ${testfont_resource_files}
)


## Scopes:
#####################################################################

extend_target(tst_qfont CONDITION TARGET Qt::Widgets
    PUBLIC_LIBRARIES
        Qt::Widgets
)
