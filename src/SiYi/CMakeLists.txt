# ============================================================================
# SiYi Module
# Provides SiYi camera/transmitter integration and registers QML types
# ============================================================================

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        SiYi.cc
        SiYi.h
        SiYiCamera.cc
        SiYiCamera.h
        SiYiTransmitter.cc
        SiYiTransmitter.h
        SiYiCrcApi.cc
        SiYiCrcApi.h
        SiYiTcpClient.cc
        SiYiTcpClient.h
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
