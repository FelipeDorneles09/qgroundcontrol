# ============================================================================
# SkyClean UI Module
# Custom UI components and pages for SkyClean
# ============================================================================

qt_add_library(SkyCleanModule STATIC)

qt_add_qml_module(SkyCleanModule
    URI QGroundControl.SkyClean
    VERSION 1.0
    RESOURCE_PREFIX /qml
    QML_FILES
        # Components
        Components/BoxWindow.qml
        Components/ButtonAction.qml
        Components/ButtonIcon.qml
        Components/ButtonOp.qml
        Components/ChangeMap.qml
        Components/ConsoleLog.qml
        Components/DrawerTakeOff.qml
        Components/DropView.qml
        Components/SignalRadar.qml
        Components/SwitchAction.qml
        Components/SwitchSquad.qml
        Components/TakeOff.qml
        Components/ToolStripView.qml
        # Pages
        Pages/ComnLinksView.qml
        Pages/DrawerMenu.qml
        Pages/FlightView.qml
        Pages/LogDownloadView.qml
        Pages/MapDownloadPage.qml
        Pages/SettingsView.qml
        Pages/SupportView.qml
        Pages/TunningView.qml
        # Pages - Notifications
        Pages/Notification/AlertFailSafe.qml
        Pages/Notification/AltIndicator.qml
        Pages/Notification/BoxWindowAlert.qml
        Pages/Notification/CriticalFailSafe.qml
        Pages/Notification/FailGPS.qml
        Pages/Notification/LaserAjusted.qml
        Pages/Notification/LaserSafety.qml
        Pages/Notification/MaxLoad.qml
        Pages/Notification/ObstacleAlert.qml
        Pages/Notification/StatusNTRIP.qml
        Pages/Notification/StatusLaser.qml
        Pages/Notification/WindowTakeOff.qml
        Pages/Notification/WrongParameters.qml
        # Services
        Services/UpdateView.qml
    RESOURCES
        Images/Altitude.svg
        Images/AlertFailSafe.svg
        Images/Alert.svg
        Images/BaroIcon.svg
        Images/Battery0.svg
        Images/Battery25.svg
        Images/Battery50.svg
        Images/Battery75.svg
        Images/Battery100.svg
        Images/BrazilIcon.svg
        Images/CriticalFailSafe.svg
        Images/Distance.svg
        Images/Edit.svg
        Images/EUAIcon.svg
        Images/FlightStatus.svg
        Images/HorizontalSpeed.svg
        Images/IconLaserOff.svg
        Images/IconLaserOn.svg
        Images/LaserOff.svg
        Images/LaserOn.svg
        Images/Links.svg
        Images/LogDownload.svg
        Images/MapDownload.svg
        Images/MapIcon.svg
        Images/MoomMode.svg
        Images/ObstacleAlert.svg
        Images/Radar.svg
        Images/RadioMK15.svg
        Images/SkyClean.svg
        Images/SkyDrones.svg
        Images/StartFly.svg
        Images/SunMode.svg
        Images/Support.svg
        Images/Ntrip.svg
        Images/TakeOff.svg
        Images/Time.svg
        Images/Tuning.svg
        Images/VerticalSpeed.svg
    NO_PLUGIN
)

target_include_directories(SkyCleanModule
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
