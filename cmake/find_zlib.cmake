

find_package(ZLIB REQUIRED)


if(MSVC AND NOT ZLIB_INCLUDE_DIRS)
    
    find_path(
        ZLIB_INCLUDE_DIRS zlib.h
        HINTS ${Qt5Core_INCLUDE_DIRS}
        PATH_SUFFIXES QtZlib
        NO_DEFAULT_PATH
        )
    
endif()

