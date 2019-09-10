
set(target quazip${QuaZip_LIB_VERSION_SUFFIX})

# Must be added to enable export macro
add_definitions(-DQUAZIP_BUILD)

# set all include directories for in and out of source builds
include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${ZLIB_INCLUDE_DIR}
)

file(GLOB QUAZIP_SRCS "*.c" "*.cpp")
file(GLOB QUAZIP_PUBLIC_HEADERS "*.h")


###########################################################
# build commands
###########################################################

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
add_library(${target} ${QUAZIP_SRCS})


set_target_properties(
    ${target}
    PROPERTIES
        POSITION_INDEPENDENT_CODE 1 # force to use fPIC even in static mode
)

# Must be added to enable export macro
target_compile_definitions(
    ${target}
    PRIVATE
        QUAZIP_BUILD
    )

if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(
        ${target}
        PUBLIC
            QUAZIP_STATIC
    )
endif()


if(QuaZip_BUILD_WITH_QT4)
    target_link_libraries(${target} Qt4::QtCore)
else()
    target_link_libraries(${target} Qt5::Core)
endif()


target_link_libraries(${target} ZLIB::ZLIB)


set_target_properties(${taret} PROPERTIES
  FRAMEWORK TRUE
  FRAMEWORK_VERSION CXX
  MACOSX_FRAMEWORK_IDENTIFIER org.quazip.QuaZip
  MACOSX_FRAMEWORK_INFO_PLIST Info.plist
  PUBLIC_HEADER dynamicFramework.h
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
)


###########################################################
# install commands
###########################################################

install(
    FILES ${QUAZIP_PUBLIC_HEADERS}
    DESTINATION
        include/quazip
    COMPONENT
        Devel
)

install(
    TARGETS ${target}
    EXPORT ${target}Targets
    RUNTIME  DESTINATION ${INSTALL_BINARY_DIR}
    ARCHIVE  DESTINATION ${INSTALL_ARCHIVE_DIR}
    LIBRARY  DESTINATION ${INSTALL_LIBRARY_DIR}
    INCLUDES DESTINATION ${INSTALL_INCLUDE_DIR}
)

export(
    EXPORT
        ${target}Targets
    FILE
        "${CMAKE_CURRENT_BINARY_DIR}/${target}Targets.cmake" # TODO test remove this
)

install(
    EXPORT
        ${target}Targets
    DESTINATION
        ${ConfigPackageLocation}
)
