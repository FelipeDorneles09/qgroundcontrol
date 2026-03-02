import QtQuick                       2.12
import QtQuick.Controls              2.4
import QtQuick.Layouts               1.12
import QtQuick.Window                2.2
import QGroundControl                1.0
import QGroundControl.Controls       1.0
import QGroundControl.FlightDisplay  1.0
import QGroundControl.SkyClean       1.0
import Qt5Compat.GraphicalEffects    1.0

Item {
    id: _root
    width: parent.width
    height: parent.height

    QGCPalette { id: qgcPal }

    // Read NTRIP status directly from the global manager as used in NTRIPSettings.qml
    property string ntripStatus: NTRIPManager ? (NTRIPManager.ntripStatus || "Disconnected") : "Unavailable"

    // Status checks (mirror logic used in NTRIPSettings.qml)
    property bool isConnected: (ntripStatus.toLowerCase().indexOf("connected") !== -1)
    property bool isConnecting: (ntripStatus.toLowerCase().indexOf("connecting") !== -1)
    property bool isError: (ntripStatus.toLowerCase().indexOf("error") !== -1) || (ntripStatus.toLowerCase().indexOf("failed") !== -1)

    property color bgColor: isConnected ? qgcPal.colorGreen : (isConnecting ? qgcPal.colorOrange : (isError ? qgcPal.colorRed : qgcPal.primaryBackground))
    property color textColor: isConnected ? "white" : qgcPal.text


    // Only visible when NTRIP reports connected (user requested)
    visible: isConnected

    property url ntripIcon: "/skyclean/Ntrip"
    property color iconColor: qgcPal.colorGreen

    Rectangle {
        width: ScreenTools.defaultFontPixelWidth * 4.9
        height: width
        color: qgcPal.iconColor
        radius: width
        anchors {
            top: parent.top
            topMargin: ScreenTools.defaultFontPixelHeight * 11.15
            left: parent.left
            leftMargin: ScreenTools.defaultFontPixelWidth * 2.1
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: ScreenTools.defaultFontPixelWidth * 4.2
            height: width
            source: ntripIcon
            layer.enabled: true
            layer.effect: ColorOverlay {
                color: iconColor
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                try {
                    QGroundControl.showSettingsPage && QGroundControl.showSettingsPage("NTRIP")
                } catch (e) {
                    console.log("Open NTRIP settings not available")
                }
            }
        }
    }

    // Keep ntripStatus bound so component reacts to changes
    Binding { target: _root; property: "ntripStatus"; value: NTRIPManager ? (NTRIPManager.ntripStatus || "Disconnected") : "Unavailable" }
}
