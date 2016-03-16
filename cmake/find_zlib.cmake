

# Use system zlib on unix and Qt ZLIB on Windows
if(MSVC)

    # is Qt build with embeded zlib
    find_path(
        ZLIB_INCLUDE_DIRS zlib.h
        HINTS ${Qt5Core_INCLUDE_DIRS}
        PATH_SUFFIXES QtZlib
        NO_DEFAULT_PATH
        )
endif()

if((UNIX OR MINGW) OR (NOT ZLIB_INCLUDE_DIRS))

    find_package(ZLIB REQUIRED)

endif()
