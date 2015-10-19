# QuaZip(5)_FOUND               - QuaZip library was found
# QuaZip(5)_INCLUDE_DIRS        - Path to QuaZip and zlib include dir (combined from QUAZIP_INCLUDE_DIR + ZLIB_INCLUDE_DIR)
# QuaZip(5)_LIBRARIES           - List of QuaZip libraries
#
# quazip(5)(_static) imported library interface
#
# define this variable before call find_package(Quazip) to enable/disable feature
#
# QUAZIP_USE_STATIC - search/use static version of quazip
# QUAZIP_USE_QT5    - search/use qt5 version of quazip



# TODO include Qt header/lib in quazip imported target


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




if (QUAZIP_USE_STATIC)
    set(_QUAZIP_STATIC_SUFFIX _static)
    set(_QUAZIP_LIBRARY_MODE STATIC)
else()
    set(_QUAZIP_LIBRARY_MODE SHARED)
endif()

set(_QUAZIP_QT_VERSION_SUFFIX "")
if (QUAZIP_USE_QT5)
    set(_QUAZIP_QT_VERSION_SUFFIX 5)
endif()

set(QUAZIP_NAME QUAZIP${_QUAZIP_QT_VERSION_SUFFIX})
set(QuaZip_NAME QuaZip${_QUAZIP_QT_VERSION_SUFFIX})
set(quazip_NAME quazip${_QUAZIP_QT_VERSION_SUFFIX})
set(quazip_LIB_NAME quazip${_QUAZIP_QT_VERSION_SUFFIX}${_QUAZIP_STATIC_SUFFIX})

set(_QUAZIP_SEARCH_PATHS $ENV{${QUAZIP_NAME}_DIR}
                         $ENV{${QUAZIP_NAME}_ROOT} )

find_path(
    ${QuaZip_NAME}_INCLUDE_DIR quazip/quazip.h
    PATHS ${_QUAZIP_SEARCH_PATHS}
    PATH_SUFFIXES include
)


find_library(
    ${QuaZip_NAME}_LIBRARY_RELEASE ${quazip_LIB_NAME}
    PATHS ${_QUAZIP_SEARCH_PATHS}
    PATH_SUFFIXES lib
)

find_library(
    ${QuaZip_NAME}_LIBRARY_DEBUG ${quazip_LIB_NAME}d
    PATHS ${_QUAZIP_SEARCH_PATHS}
    PATH_SUFFIXES lib
)
  
#message("${QuaZip_NAME}_INCLUDE_DIR = ${${QuaZip_NAME}_INCLUDE_DIR}")
#message("${QuaZip_NAME}_LIBRARY_RELEASE = ${${QuaZip_NAME}_LIBRARY_RELEASE}")
#message("${QuaZip_NAME}_LIBRARY_DEBUG = ${${QuaZip_NAME}_LIBRARY_DEBUG}")

if(${QuaZip_NAME}_LIBRARY_RELEASE)
    if(${QuaZip_NAME}_LIBRARY_DEBUG)
        set(
	    ${QuaZip_NAME}_LIBRARIES
            optimize ${${QuaZip_NAME}_LIBRARY_RELEASE}
            debug ${${QuaZip_NAME}_LIBRARY_DEBUG}
        )
    else()
        set(${QuaZip_NAME}_LIBRARIES ${${QuaZip_NAME}_LIBRARY_RELEASE})
    endif()
endif()

if(${QuaZip_NAME}_INCLUDE_DIR)
    set(
        ${QuaZip_NAME}_INCLUDE_DIRS
        ${${QuaZip_NAME}_INCLUDE_DIR}
    )
endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    ${QuaZip_NAME} FOUND_VAR ${QuaZip_NAME}_FOUND
    REQUIRED_VARS ${QuaZip_NAME}_INCLUDE_DIRS ${QuaZip_NAME}_LIBRARIES
)


if(NOT ${QuaZip_NAME}_FOUND)
    return()
endif()




###############################################################################
# define imported target quazip(5)(_static)
###############################################################################

add_library(${quazip_LIB_NAME} ${_QUAZIP_LIBRARY_MODE} IMPORTED)

set_target_properties(
    ${quazip_LIB_NAME}
    PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${${QuaZip_NAME}_INCLUDE_DIRS}
        INTERFACE_LINK_LIBRARIES_RELEASE ${${QuaZip_NAME}_LIBRARY_RELEASE}
        IMPORTED_LOCATION_RELEASE        ${${QuaZip_NAME}_LIBRARY_RELEASE}
)
set_property(
    TARGET ${quazip_LIB_NAME}
    APPEND PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES ${ZLIB_INCLUDE_DIR}
)

if(QUAZIP_USE_STATIC)
    set_property(
        TARGET ${quazip_LIB_NAME}
        APPEND PROPERTY
            INTERFACE_COMPILE_DEFINITIONS QUAZIP_STATIC
    )
endif()

if (${${QuaZip_NAME}_LIBRARY_DEBUG})
  
    set_target_properties(
        ${quazip_LIB_NAME}
        PROPERTIES
             INTERFACE_LINK_LIBRARIES_DEBUG ${${QuaZip_NAME}_LIBRARY_DEBUG}
             IMPORTED_LOCATION_DEBUG        ${${QuaZip_NAME}_LIBRARY_DEBUG}
    )

endif()
