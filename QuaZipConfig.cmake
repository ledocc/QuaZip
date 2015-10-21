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

cmake_minimum_required(VERSION 2.8.3)



###############################################################################
# define options
###############################################################################
if (QUAZIP_USE_STATIC)
    set(_QUAZIP_STATIC_SUFFIX _static)
    set(_QUAZIP_LINK_MODE STATIC)
else()
    set(_QUAZIP_LINK_MODE SHARED)
endif()

if (QUAZIP_USE_QT5)    
    set(_QUAZIP_QT_VERSION_SUFFIX 5)
else()
    set(_QUAZIP_QT_VERSION_SUFFIX "")
endif()




###############################################################################
# search dependencies
###############################################################################

#################
# search Qt(5)
#
if (QUAZIP_USE_QT5 AND NOT Qt5_FOUND)
    find_package(Qt5 REQUIRED COMPONENTS Core)
elseif(NOT QUAZIP_USE_QT5 AND NOT Qt4_FOUND)
    find_package(Qt4 REQUIRED)
endif()


#################
# search zlib
#
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



###############################################################################
# define quazip(5) include / libs path
###############################################################################

#######################
# define usefull name
#
set(QUAZIP_NAME QUAZIP${_QUAZIP_QT_VERSION_SUFFIX})
set(QuaZip_NAME QuaZip${_QUAZIP_QT_VERSION_SUFFIX})
set(quazip_NAME quazip${_QUAZIP_QT_VERSION_SUFFIX})
set(quazip_LIB_NAME quazip${_QUAZIP_QT_VERSION_SUFFIX}${_QUAZIP_STATIC_SUFFIX})


get_filename_component(_quazip_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)



set(QUAZIP_RELEASE_LIB_FILE ${CMAKE_${_QUAZIP_LINK_MODE}_LIBRARY_PREFIX}${quazip_LIB_NAME}${CMAKE_${_QUAZIP_LINK_MODE}_LIBRARY_SUFFIX})
set(QUAZIP_DEBUG_LIB_FILE ${CMAKE_${_QUAZIP_LINK_MODE}_LIBRARY_PREFIX}${quazip_LIB_NAME}${CMAKE_DEBUG_POSTFIX}${CMAKE_${_QUAZIP_LINK_MODE}_LIBRARY_SUFFIX})


set(${QuaZip_NAME}_INCLUDE_DIRS    ${_quazip_install_prefix}/include)
set(${QuaZip_NAME}_LIBRARY_RELEASE ${_quazip_install_prefix}/lib/${QUAZIP_RELEASE_LIB_FILE})
set(${QuaZip_NAME}_LIBRARY_DEBUG   ${_quazip_install_prefix}/lib/${QUAZIP_DEBUG_LIB_FILE})


if(${QuaZip_NAME}_LIBRARY_DEBUG)
    set(
	${QuaZip_NAME}_LIBRARIES
        optimize ${${QuaZip_NAME}_LIBRARY_RELEASE}
        debug ${${QuaZip_NAME}_LIBRARY_DEBUG}
        )
else()
    set(${QuaZip_NAME}_LIBRARIES ${${QuaZip_NAME}_LIBRARY_RELEASE})
endif()



#message("${QuaZip_NAME}_INCLUDE_DIR = ${${QuaZip_NAME}_INCLUDE_DIR}")
#message("${QuaZip_NAME}_LIBRARY_RELEASE = ${${QuaZip_NAME}_LIBRARY_RELEASE}")
#message("${QuaZip_NAME}_LIBRARY_DEBUG = ${${QuaZip_NAME}_LIBRARY_DEBUG}")


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

add_library(${quazip_LIB_NAME} ${_QUAZIP_LINK_MODE} IMPORTED)

#target_include_directories(
#  ${quazip_LIB_NAME}
#  INTERFACE
#    ${${QuaZip_NAME}_INCLUDE_DIRS}
#    ${ZLIB_INCLUDE_DIR}
#)
set_property(
    TARGET ${quazip_LIB_NAME}
    PROPERTY INTERFACE_INCLUDE_DIRECTORIES 
    ${${QuaZip_NAME}_INCLUDE_DIRS}
    ${ZLIB_INCLUDE_DIRS}
    )

#target_link_libraries(
#  ${quazip_LIB_NAME}
#  INTERFACE
#    ${${QuaZip_NAME}_LIBRARIES}
#    ${ZLIB_LIBRARIES}
#    Qt5::Core
#)

set_property(
    TARGET ${quazip_LIB_NAME}
    PROPERTY INTERFACE_LINK_LIBRARIES 
    ${ZLIB_LIBRARIES}
    Qt5::Core
    )
set_property(
    TARGET ${quazip_LIB_NAME}
    PROPERTY IMPORTED_LOCATION_RELEASE
    ${${QuaZip_NAME}_LIBRARY_RELEASE}
)

if(EXISTS ${${QuaZip_NAME}_LIBRARY_DEBUG})    
    set_property(
        TARGET ${quazip_LIB_NAME}
        PROPERTY IMPORTED_LOCATION_DEBUG
        ${${QuaZip_NAME}_LIBRARY_DEBUG}
    )
endif()

if(QUAZIP_USE_STATIC)
#    target_compile_definitions(
#        ${quazip_LIB_NAME}
#        INTERFACE
#            QUAZIP_STATIC
#    )

set_property(
    TARGET ${quazip_LIB_NAME}
    PROPERTY INTERFACE_COMPILE_DEFINITIONS
    QUAZIP_STATIC
    )


endif()
