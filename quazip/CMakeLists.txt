
set(QUAZIP_LIB_TARGET_NAME quazip${QUAZIP_LIB_VERSION_SUFFIX})

# Must be added to enable export macro
add_definitions(-DQUAZIP_BUILD)

# set all include directories for in and out of source builds
include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${ZLIB_INCLUDE_DIR}
)

file(GLOB SRCS "*.c" "*.cpp")
file(GLOB PUBLIC_HEADERS "*.h")

qt_wrap_cpp(MOC_SRCS ${PUBLIC_HEADERS})
set(SRCS ${SRCS} ${MOC_SRCS})



###########################################################
# build commands
###########################################################

add_library(quazip_obj OBJECT ${SRCS})

# not yet available
#target_link_libraries(quazip_obj Qt5::Core ${ZLIB_LIBRARIES})

# so use complicate way
target_include_directories(quazip_obj PRIVATE $<TARGET_PROPERTY:Qt5::Core,INTERFACE_INCLUDE_DIRECTORIES>)
target_compile_definitions(quazip_obj PRIVATE $<TARGET_PROPERTY:Qt5::Core,INTERFACE_COMPILE_DEFINITIONS>)
target_compile_options(quazip_obj PRIVATE $<TARGET_PROPERTY:Qt5::Core,INTERFACE_COMPILE_OPTIONS>)
get_target_property(Qt5Core_PIC Qt5::Core INTERFACE_POSITION_INDEPENDENT_CODE)
set_target_properties(quazip_obj PROPERTIES POSITION_INDEPENDENT_CODE ${Qt5Core_PIC})


add_library(${QUAZIP_LIB_TARGET_NAME} SHARED $<TARGET_OBJECTS:quazip_obj>)
add_library(${QUAZIP_LIB_TARGET_NAME}_static STATIC $<TARGET_OBJECTS:quazip_obj>)
 
# Windows uses .lib extension for both static and shared library
# *nix systems use different extensions for SHARED and STATIC library and by convention both libraries have the same name
#if (NOT WIN32)
#        set_target_properties(${QUAZIP_LIB_TARGET_NAME}_static PROPERTIES OUTPUT_NAME ${QUAZIP_LIB_TARGET_NAME})
#endif ()

#set_target_properties(${QUAZIP_LIB_TARGET_NAME} quazip_static PROPERTIES VERSION 1.0.0 SOVERSION 1 DEBUG_POSTFIX d)
# Link against ZLIB_LIBRARIES if needed (on Windows this variable is empty)
target_link_libraries(${QUAZIP_LIB_TARGET_NAME} Qt5::Core ${ZLIB_LIBRARIES})
target_link_libraries(${QUAZIP_LIB_TARGET_NAME}_static Qt5::Core ${ZLIB_LIBRARIES})



###########################################################
# install commands
###########################################################

install(
    FILES ${PUBLIC_HEADERS}
    DESTINATION include/quazip
)
install(
    TARGETS ${QUAZIP_LIB_TARGET_NAME} ${QUAZIP_LIB_TARGET_NAME}_static
    RUNTIME DESTINATION ${INSTALL_BINDIR}
    LIBRARY DESTINATION ${INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${INSTALL_ARCHIVEDIR}
)
