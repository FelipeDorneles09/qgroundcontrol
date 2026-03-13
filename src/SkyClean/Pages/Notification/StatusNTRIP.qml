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

    property string ntripStatus: NTRIPManager ? (NTRIPManager.ntripStatus || "Disconnected") : "Unavailable"

    property bool isConnected:  (ntripStatus.toLowerCase().indexOf("connected")  !== -1)
    property bool isConnecting: (ntripStatus.toLowerCase().indexOf("connecting") !== -1)
    property bool isError:      (ntripStatus.toLowerCase().indexOf("error")      !== -1) ||
                                (ntripStatus.toLowerCase().indexOf("failed")     !== -1)

    visible: isConnected

    property url   ntripIcon: "/skyclean/Ntrip"
    property color iconColor: "#00E676"   // vivid green for the icon glyph

    // ── anchor point ──────────────────────────────────────────────────────────
    Item {
        id: badge
        width:  ScreenTools.defaultFontPixelWidth  * 5.6
        height: width
        anchors {
            top:        parent.top
            topMargin:  ScreenTools.defaultFontPixelHeight * 11.15
            left:       parent.left
            leftMargin: ScreenTools.defaultFontPixelWidth  * 2.1
        }

        // ── outer pulse ring ──────────────────────────────────────────────────
        Rectangle {
            id: pulseRing
            anchors.centerIn: parent
            width:   parent.width
            height:  width
            radius:  width / 2
            color:   "transparent"
            border.color: "#00E676"
            border.width: 2
            opacity: 0

            SequentialAnimation on opacity {
                running:  _root.isConnected
                loops:    Animation.Infinite
                NumberAnimation { to: 0.6; duration: 900;  easing.type: Easing.OutQuad }
                NumberAnimation { to: 0;   duration: 900;  easing.type: Easing.InQuad  }
                PauseAnimation  { duration: 400 }
            }

            SequentialAnimation on scale {
                running:  _root.isConnected
                loops:    Animation.Infinite
                NumberAnimation { to: 1.45; duration: 900;  easing.type: Easing.OutQuad }
                NumberAnimation { to: 1.0;  duration: 900;  easing.type: Easing.InQuad  }
                PauseAnimation  { duration: 400 }
            }
        }

        // ── drop shadow ───────────────────────────────────────────────────────
        Rectangle {
            anchors.centerIn: parent
            width:   parent.width * 0.92
            height:  width
            radius:  width / 2
            color:   "#55000000"
            y:       2
        }

        // ── main pill ─────────────────────────────────────────────────────────
        Rectangle {
            id: mainCircle
            anchors.centerIn: parent
            width:   parent.width * 0.92
            height:  width
            radius:  width / 2

            // dark centre with a subtle radial tint
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2A2F2A" }
                GradientStop { position: 1.0; color: "#1A1E1A" }
            }

            // green rim
            border.color: "#00C853"
            border.width: 1.5

            // soft inner glow layer
            Rectangle {
                anchors.centerIn: parent
                width:   parent.width  * 0.78
                height:  width
                radius:  width / 2
                color:   "transparent"
                border.color: "#3300E676"
                border.width: 4
            }

            Image {
                id: iconImage
                anchors.centerIn: parent
                width:  parent.width * 0.58
                height: width
                source: ntripIcon
                smooth: true
                mipmap: true
                layer.enabled: true
                layer.effect: ColorOverlay {
                    color: iconColor
                }
            }
        }
    }

    Binding {
        target:   _root
        property: "ntripStatus"
        value:    NTRIPManager ? (NTRIPManager.ntripStatus || "Disconnected") : "Unavailable"
    }
}