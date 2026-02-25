target_sources(QGroundControlModule
    PRIVATE
        SiYi.cc
        SiYi.h
        SiYiCamera.cc
        SiYiCamera.h
        SiYiTransmitter.cc
        SiYiTransmitter.h
        SiYiTcpClient.cc
        SiYiTcpClient.h
        SiYiCrcApi.cc
        SiYiCrcApi.h
)

target_include_directories(QGroundControlModule
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)
