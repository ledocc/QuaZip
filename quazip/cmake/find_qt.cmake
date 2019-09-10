

if(QuaZip_BUILD_WITH_QT4)

    find_package(Qt4 4.5.0 REQUIRED)

else()

    find_package(
        Qt5 REQUIRED
        COMPONENTS
            Core
    )

endif()
