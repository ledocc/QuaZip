# QUAZIP5_FOUND               - QuaZip library was found
# QUAZIP5_INCLUDE_DIR         - Path to QuaZip include dir
# QUAZIP5_INCLUDE_DIRS        - Path to QuaZip and zlib include dir (combined from QUAZIP_INCLUDE_DIR + ZLIB_INCLUDE_DIR)
# QUAZIP5_LIBRARIES           - List of QuaZip libraries
# QUAZIP5_ZLIB_INCLUDE_DIR    - The include dir of zlib headers


find_path(
    QuaZip_INCLUDE_DIR quazip5/quazip.h
    PATHS $ENV{QUAZIP_DIR}
          $ENV{QUAZIP_ROOT}
    PATH_SUFFIXES include
)

find_library(
    QuaZip_LIBRARY_RELEASE quazip
    PATHS $ENV{QUAZIP_DIR}
          $ENV{QUAZIP_ROOT}
    PATH_SUFFIXES lib
)

find_library(
    QuaZip_LIBRARY_DEBUG quazipd
    PATHS $ENV{QUAZIP_DIR}
          $ENV{QUAZIP_ROOT}
    PATH_SUFFIXES lib
)

if(QuaZip_LIBRARY_RELEASE OR QuaZip_LIBRARY_DEBUG)
    set(
        QuaZip_LIBRARIES
        release ${QuaZip_LIBRARY_RELEASE}
	debug ${QuaZip_LIBRARY_DEBUG}
    )
endif()

if(QuaZip_INCLUDE_DIR)
    set(
        QuaZip_INCLUDE_DIRS
        ${QuaZip_INCLUDE_DIR}
    )
endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    QuaZip FOUND_VAR QuaZip_FOUND
    REQUIRED_VARS QuaZip_INCLUDE_DIRS QuaZip_LIBRARIES
    VERSION_VAR QuaZip_VERSION_STRING
)
