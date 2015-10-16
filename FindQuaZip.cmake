# QuaZip5_FOUND               - QuaZip library was found
# QuaZip5_INCLUDE_DIRS        - Path to QuaZip and zlib include dir (combined from QUAZIP_INCLUDE_DIR + ZLIB_INCLUDE_DIR)
# QuaZip5_LIBRARIES           - List of QuaZip libraries
#
# quazip5 imported library interface

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

set(_QUAZIP_SEARCH_PATHS $ENV{${QUAZIP_UP_NAME}_DIR}
                         $ENV{${QUAZIP_UP_NAME}_ROOT} )

find_path(
    ${QuaZip_NAME}_INCLUDE_DIR ${quazip_NAME}/quazip.h
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

if(${QuaZip_NAME}_LIBRARY_RELEASE OR ${QuaZip_NAME}_LIBRARY_DEBUG)
    set(
        ${QuaZip_NAME}_LIBRARIES
        release ${${QuaZip_NAME}_LIBRARY_RELEASE}
        debug ${${QuaZip_NAME}_LIBRARY_DEBUG}
    )
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


add_library(${quazip_LIB_NAME} ${_QUAZIP_LIBRARY_MODE} IMPORTED)

set_property(${quazip_LIB_NAME} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${${QuaZip_NAME}_INCLUDE_DIRS})
set_property(${quazip_LIB_NAME} PROPERTIES INTERFACE_LINK_LIBRARIES_RELEASE ${${QuaZip_NAME}_LIBRARY_RELEASE})
set_property(${quazip_LIB_NAME} PROPERTIES INTERFACE_LINK_LIBRARIES_DEBUG ${${QuaZip_NAME}_LIBRARY_DEBUG})
