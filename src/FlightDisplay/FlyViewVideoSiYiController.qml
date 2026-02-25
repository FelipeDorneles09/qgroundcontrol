/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root
    clip: true
    anchors.fill: parent

    property var siyi: typeof SiYi !== 'undefined' ? SiYi : null
    property var camera: siyi ? siyi.camera : null
    property int minDelta: 5
    property bool isRecording: camera ? camera.isRecording : false

    // Gimbal control via mouse
    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        hoverEnabled: true
        visible: camera && camera.isConnected

        onPressed: {
            enableControl = true
            controlMouseArea.originX = mouse.x
            controlMouseArea.originY = mouse.y
            controlMouseArea.currentX = mouse.x
            controlMouseArea.currentY = mouse.y
            controlMouseArea.pitch = 0
            controlMouseArea.yaw = 0
            controlTimer.start()
        }

        onReleased: {
            enableControl = false
            controlTimer.stop()
        }

        onPositionChanged: {
            controlMouseArea.currentX = mouse.x
            controlMouseArea.currentY = mouse.y
            controlMouseArea.yaw = (controlMouseArea.currentX - controlMouseArea.originX) / 5
            controlMouseArea.pitch = (controlMouseArea.currentY - controlMouseArea.originY) / 5

            if (Math.abs(controlMouseArea.yaw) > Math.abs(controlMouseArea.pitch)) {
                if (Math.abs(controlMouseArea.yaw) > minDelta) {
                    controlMouseArea.pitch = 0
                    controlMouseArea.isYDirection = false
                }
            } else {
                if (Math.abs(controlMouseArea.pitch) > minDelta) {
                    controlMouseArea.yaw = 0
                    controlMouseArea.isYDirection = true
                }
            }
        }

        onDoubleClicked: {
            if (camera) camera.resetPostion()
        }

        onClicked: {
            if (camera) camera.autoFocus(mouse.x, mouse.y, root.width, root.height)
        }

        Timer {
            id: controlTimer
            running: false
            interval: 100
            repeat: true

            onTriggered: {
                if (!controlMouseArea.enableControl) return

                // Clamp values
                if (controlMouseArea.yaw < -100) controlMouseArea.yaw = -100
                if (controlMouseArea.yaw > 100) controlMouseArea.yaw = 100
                if (controlMouseArea.pitch < -100) controlMouseArea.pitch = -100
                if (controlMouseArea.pitch > 100) controlMouseArea.pitch = 100

                if (Math.abs(controlMouseArea.pitch) > minDelta) {
                    controlMouseArea.prePitch = controlMouseArea.pitch
                }
                if (Math.abs(controlMouseArea.yaw) > minDelta) {
                    controlMouseArea.preYaw = controlMouseArea.yaw
                }

                if (Math.abs(controlMouseArea.pitch) < minDelta && 
                    Math.abs(controlMouseArea.yaw) < minDelta) {
                    return
                }

                var yaw = controlMouseArea.isYDirection ? 0 : 
                           Math.abs(controlMouseArea.yaw) < minDelta ? 
                           controlMouseArea.preYaw : controlMouseArea.yaw

                var pitch = controlMouseArea.isYDirection ? 
                            Math.abs(controlMouseArea.pitch) < minDelta ? 
                            -controlMouseArea.prePitch : -controlMouseArea.pitch : 0

                if (camera) camera.turn(yaw, pitch)
            }

            onRunningChanged: {
                if (!running) {
                    controlMouseArea.originX = 0
                    controlMouseArea.originY = 0
                    controlMouseArea.currentX = 0
                    controlMouseArea.currentY = 0
                    if (camera) camera.turn(0, 0)
                }
            }
        }

        property bool enableControl: false
        property int pitch: 0
        property int yaw: 0
        property int prePitch: 0
        property int preYaw: 0
        property int originX: 0
        property int originY: 0
        property int currentX: 0
        property int currentY: 0
        property bool isYDirection: false
    }

    // Camera control buttons
    ColumnLayout {
        id: controlButtons
        anchors.left: parent.left
        anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
        anchors.top: parent.top
        anchors.topMargin: ScreenTools.defaultFontPixelWidth * 2
        spacing: ScreenTools.defaultFontPixelHeight * 0.5
        visible: camera && camera.isConnected

        // Zoom In
        QGCButton {
            text: qsTr("Zoom +")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableZoom
            visible: enabled
            onClicked: {
                if (camera) camera.zoom(1)
            }
            Layout.fillWidth: true
        }

        // Zoom Out
        QGCButton {
            text: qsTr("Zoom -")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableZoom
            visible: enabled
            onClicked: {
                if (camera) camera.zoom(-1)
            }
            Layout.fillWidth: true
        }

        // Reset Gimbal
        QGCButton {
            text: qsTr("Reset")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableControl
            visible: enabled
            onClicked: {
                if (camera) camera.resetPostion()
            }
            Layout.fillWidth: true
        }

        // Take Photo
        QGCButton {
            text: qsTr("Photo")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enablePhoto
            visible: enabled
            onClicked: {
                if (camera) camera.sendCommand(0) // CameraCommandTakePhoto
            }
            Layout.fillWidth: true
        }

        // Record Video
        QGCButton {
            text: camera && camera.isRecording ? qsTr("Stop") : qsTr("Record")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableVideo
            visible: enabled
            onClicked: {
                if (camera) {
                    if (camera.isRecording) {
                        camera.sendRecodingCommand(0) // CloseRecording
                    } else {
                        camera.sendRecodingCommand(1) // OpenRecording
                    }
                }
            }
            Layout.fillWidth: true
        }

        // Focus Far (Infinity)
        QGCButton {
            text: qsTr("∞ Focus")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableFocus
            visible: enabled
            onClicked: {
                if (camera) camera.focus(1)
            }
            Layout.fillWidth: true
        }

        // Focus Near
        QGCButton {
            text: qsTr("⊕ Focus")
            width: ScreenTools.defaultFontPixelWidth * 10
            enabled: camera && camera.enableFocus
            visible: enabled
            onClicked: {
                if (camera) camera.focus(-1)
            }
            Layout.fillWidth: true
        }
    }

    // Status indicator
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: ScreenTools.defaultFontPixelWidth
        anchors.top: parent.top
        anchors.topMargin: ScreenTools.defaultFontPixelHeight
        width: ScreenTools.defaultFontPixelWidth * 15
        height: ScreenTools.defaultFontPixelHeight * 8
        color: "#CC000000"
        radius: ScreenTools.defaultFontPixelWidth
        visible: camera && camera.isConnected
        border.color: camera && camera.isRecording ? "#FF0000" : "#00FF00"
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScreenTools.defaultFontPixelWidth
            spacing: 4

            QGCLabel {
                text: "SiYi Status"
                font.bold: true
                color: "white"
            }

            QGCLabel {
                text: qsTr("Connected: %1").arg(camera && camera.isConnected ? "Yes" : "No")
                color: camera && camera.isConnected ? "#00FF00" : "#FF0000"
                font.pointSize: ScreenTools.smallFontPointSize
            }

            QGCLabel {
                text: qsTr("Recording: %1").arg(camera && camera.isRecording ? "Yes" : "No")
                color: camera && camera.isRecording ? "#FF0000" : "#00FF00"
                font.pointSize: ScreenTools.smallFontPointSize
            }

            QGCLabel {
                text: qsTr("Zoom: %1x").arg(camera ? Math.round(camera.zoomMultiple) : 0)
                color: "white"
                font.pointSize: ScreenTools.smallFontPointSize
            }
        }
    }
}
