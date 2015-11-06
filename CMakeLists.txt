cmake_minimum_required(VERSION 3.0.2)

project (QuaZip VERSION 0.7.1)

option(BUILD_WITH_QT4 "Build QuaZip with Qt4 no matter if Qt5 was found" OFF)

if( NOT BUILD_WITH_QT4 )
    # try Qt5 first, and prefer that if found
    find_package(Qt5 REQUIRED COMPONENTS Core)
endif()

if (Qt5Core_FOUND)
    set(QUAZIP_LIB_VERSION_SUFFIX 5)
    # if there is no QT_ROOT, try to deduce it from Qt QtCore include
    if ("${QT_ROOT}" STREQUAL "")
        set(QT_ROOT ${QT_QTCORE_INCLUDE_DIR}/../..)
    endif()
    macro(qt_wrap_cpp)
        qt5_wrap_cpp(${ARGN})
    endmacro()
else()
    set(qt_min_version "4.5.0")
    find_package(Qt4 REQUIRED)
    set(QT_USE_QTGUI false)
    include(${QT_USE_FILE})
    include_directories(${QT_INCLUDES})
    set(QTCORE_LIBRARIES ${QT_QTCORE_LIBRARY})

    macro(qt_wrap_cpp)
        qt4_wrap_cpp(${ARGN})
    endmacro()
endif()

# Use system zlib on unix and Qt ZLIB on Windows
if(UNIX OR MINGW)
    find_package(ZLIB REQUIRED)
else()
    # is Qt build with embeded zlib
    find_path(
        ZLIB_INCLUDE_DIR zlib.h
        HINTS ${Qt5Core_INCLUDE_DIRS}
        PATH_SUFFIXES QtZlib
        NO_DEFAULT_PATH
    )

    # else try to found zlib package
    if (NOT ZLIB_INCLUDE_DIR)
        find_package(ZLIB REQUIRED)
    endif()

endif()



if(CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(LIB_SUFFIX "64")
endif()

set(INSTALL_INCDIR include )
set(INSTALL_BINDIR bin )
if(WIN32)
    set(INSTALL_LIBDIR ${INSTALL_BINDIR})
    set(INSTALL_ARCHIVEDIR lib)
else()
    set(INSTALL_LIBDIR lib${LIB_POSTFIX})
    set(INSTALL_ARCHIVEDIR lib${LIB_POSTFIX})
endif()

# All build libraries are moved to this directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${INSTALL_BINDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${INSTALL_LIBDIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${INSTALL_ARCHIVEDIR})


set(__QuaZip_BUILD_LIB 1)
include(cmake/target_properties.cmake)


if(CMAKE_HOST_APPLE)
	set(CMAKE_OSX_DEPLOYMENT_TARGET 10.9)
endif()

add_subdirectory(quazip)

install(
    FILES QuaZipConfig.cmake QuaZipConfigVersion.cmake
    DESTINATION lib/cmake/QuaZip)

install(
    FILES cmake/target_properties.cmake
    DESTINATION lib/cmake)
