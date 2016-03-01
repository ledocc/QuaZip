cmake_minimum_required(VERSION 3.0.2)

project (QuaZip VERSION 0.7.1)



########################################################################################################################
## define usefull directory
########################################################################################################################

set(ConfigPackageLocation lib/cmake/QuaZip)



########################################################################################################################
## build options
########################################################################################################################
option(QuaZip_BUILD_WITH_QT4 "enable to build QuaZip with Qt4, disable to build QuaZip with Qt5" OFF)
option(BUILD_SHARED_LIBS "enable to build shared libraries, disable to build static libraries" OFF)


########################################################################################################################
## dependencies search
########################################################################################################################

if(QuaZip_BUILD_WITH_QT4)

    set(qt_min_version "4.5.0")
    find_package(Qt4 REQUIRED)

    set(QT_USE_QTGUI false)
    include(${QT_USE_FILE})
    include_directories(${QT_INCLUDES})
    set(QTCORE_LIBRARIES ${QT_QTCORE_LIBRARY})

else()
    find_package(
        Qt5 REQUIRED
        COMPONENTS
            Core
    )

    set(QuaZip_LIB_VERSION_SUFFIX 5)

    # if there is no QT_ROOT, try to deduce it from Qt QtCore include
    if ("${QT_ROOT}" STREQUAL "")
        set(QT_ROOT ${QT_QTCORE_INCLUDE_DIR}/../..)
    endif()

endif()

# Use system zlib on unix and Qt ZLIB on Windows
if(WIN32)
    # is Qt build with embeded zlib
    find_path(
        ZLIB_INCLUDE_DIR zlib.h
        HINTS ${Qt5Core_INCLUDE_DIRS}
        PATH_SUFFIXES QtZlib
        NO_DEFAULT_PATH
    )
endif()

if((UNIX OR MINGW) OR (NOT ZLIB_INCLUDE_DIR))
    find_package(ZLIB REQUIRED)
    set(QuaZip_SEARCH_ZLIB ON)
endif()





########################################################################################################################
## define install directories
########################################################################################################################
if(CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(LIB_SUFFIX "64")
endif()

set(INSTALL_INCLUDE_DIR include )
set(INSTALL_BINARY_DIR bin )
if(WIN32)
    set(INSTALL_LIBRARY_DIR ${INSTALL_BINARY_DIR})
    set(INSTALL_ARCHIVE_DIR lib)
else()
    set(INSTALL_LIBRARY_DIR lib${LIB_POSTFIX})
    set(INSTALL_ARCHIVE_DIR lib${LIB_POSTFIX})
endif()


add_subdirectory(quazip)



########################################################################################################################
# install commands
########################################################################################################################

# configure and install Config/Version/Dependencies files
configure_file(
    "cmake/QuaZipConfig.cmake"
    "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipConfig.cmake"
    COPYONLY
)

configure_file(
    "cmake/QuaZipDependencies.cmake.in"
    "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipDependencies.cmake"
)


include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipConfigVersion.cmake"
  VERSION ${QuaZip_VERSION}
  COMPATIBILITY AnyNewerVersion
)

install(
  FILES
    "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipConfig.cmake"
    "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipConfigVersion.cmake"
    "${CMAKE_BINARY_DIR}/${ConfigPackageLocation}/QuaZipDependencies.cmake"
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Devel
)
