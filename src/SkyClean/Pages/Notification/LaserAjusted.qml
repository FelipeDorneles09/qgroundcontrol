/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                      2.12
import QtQuick.Controls             2.4
import QtQuick.Dialogs
import QtQuick.Layouts              1.12
import QtLocation                   5.3
import QtPositioning                5.3
import QtQuick.Window               2.2
import QtQml.Models                 2.1
import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QtCore

Item {
    id:     root
    width:  parent.width
    height: parent.height
    z:      30

    // ── private ───────────────────────────────────────────────────────────────
    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property bool pxrType:                  controllerLoader.item.getParameterFact(-1, "PRX1_TYPE")
    property bool rangeType:                controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE")
    property bool flowType:                 controllerLoader.item.getParameterFact(-1, "FLOW_TYPE")

    // ── design tokens ─────────────────────────────────────────────────────────
    readonly property color _surface:       "#111827"
    readonly property color _surfaceHigh:   "#1A2235"
    readonly property color _border:        "#243044"
    readonly property color _borderBright:  "#3D5070"
    readonly property color _accent:        "#00CFFF"
    readonly property color _success:       "#00D68F"
    readonly property color _textPrimary:   "#E8EEF7"
    readonly property color _textSecondary: "#6B80A0"

    // ── controller ────────────────────────────────────────────────────────────
    Loader {
        id:     controllerLoader
        active: _initialDownloadComplete
        sourceComponent: Component {
            FactPanelController { id: controller }
        }
    }

    QGCPalette { id: qgcPal }

    // ── dimmed backdrop ───────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color:        "#000000"
        opacity:      0.82
        MouseArea { anchors.fill: parent; enabled: true; onClicked: {} }
    }

    // ── modal card ────────────────────────────────────────────────────────────
    Rectangle {
        id:               card
        anchors.centerIn: parent
        width:            ScreenTools.defaultFontPixelWidth  * 50
        height:           ScreenTools.defaultFontPixelHeight * 22
        color:            _surface
        radius:           ScreenTools.defaultFontPixelWidth  * 1.4
        border.color:     _border
        border.width:     1

        // top glow line
        Rectangle {
            width:  parent.width * 0.55
            height: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:              parent.top
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: _accent }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // ── header ────────────────────────────────────────────────────────────
        Item {
            id:     cardHeader
            width:  parent.width
            height: ScreenTools.defaultFontPixelHeight * 4

            Rectangle {
                width:                  ScreenTools.defaultFontPixelWidth  * 0.3
                height:                 ScreenTools.defaultFontPixelHeight * 1.4
                radius:                 1
                color:                  _accent
                anchors.left:           parent.left
                anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text:               qsTr("CONFIGURAÇÃO DO LASER")
                color:              _textPrimary
                font.bold:          true
                font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.85
                font.letterSpacing: 1.4
                anchors.left:           parent.left
                anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 3
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                id:           closeBtn
                width:        ScreenTools.defaultFontPixelHeight * 1.7
                height:       ScreenTools.defaultFontPixelHeight * 1.7
                radius:       ScreenTools.defaultFontPixelWidth  * 0.5
                color:        closeMa.containsMouse ? "#3D1A22" : _surfaceHigh
                border.color: closeMa.containsMouse ? "#FF4D6A" : _border
                border.width: 1
                anchors.right:          parent.right
                anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 2
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color        { ColorAnimation { duration: 130 } }
                Behavior on border.color { ColorAnimation { duration: 130 } }

                Text {
                    text:           "x"
                    color:          closeMa.containsMouse ? "#FF4D6A" : _textSecondary
                    font.bold:      true
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                    anchors.centerIn: parent
                    Behavior on color { ColorAnimation { duration: 130 } }
                }

                MouseArea {
                    id:           closeMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:    root.visible = false
                }
            }
        }

        Rectangle {
            id:          headerDivider
            width:       parent.width
            height:      1
            color:       _border
            anchors.top: cardHeader.bottom
        }

        // ── content ───────────────────────────────────────────────────────────
        Column {
            anchors.top:         headerDivider.bottom
            anchors.left:        parent.left
            anchors.right:       parent.right
            anchors.bottom:      parent.bottom
            anchors.topMargin:   ScreenTools.defaultFontPixelHeight * 0.4
            anchors.leftMargin:  ScreenTools.defaultFontPixelWidth  * 2
            anchors.rightMargin: ScreenTools.defaultFontPixelWidth  * 2
            spacing:             0

            // ── LASER ─────────────────────────────────────────────────────────
            Item {
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 6.5

                Rectangle {
                    anchors.fill:    parent
                    anchors.margins: ScreenTools.defaultFontPixelHeight * 0.25
                    radius:          ScreenTools.defaultFontPixelWidth  * 0.8
                    color:           laserMa.containsMouse ? "#141E30" : "transparent"
                    border.color:    laserMa.containsMouse ? _borderBright : "transparent"
                    border.width:    1
                    Behavior on color        { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                }

                Rectangle {
                    id:           laserIcon
                    width:        ScreenTools.defaultFontPixelHeight * 3
                    height:       ScreenTools.defaultFontPixelHeight * 3
                    radius:       ScreenTools.defaultFontPixelWidth  * 0.6
                    color:        Qt.rgba(0, 0.81, 1, 0.10)
                    border.color: Qt.rgba(0, 0.81, 1, 0.30)
                    border.width: 1
                    anchors.left:           parent.left
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.8
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text:           "L"
                        color:          _accent
                        font.bold:      true
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.15
                        anchors.centerIn: parent
                    }
                }

                Column {
                    anchors.left:           laserIcon.right
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 1.2
                    anchors.verticalCenter: parent.verticalCenter
                    spacing:                ScreenTools.defaultFontPixelHeight * 0.2

                    Text {
                        text:               qsTr("LASER")
                        color:              _textPrimary
                        font.bold:          true
                        font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.88
                        font.letterSpacing: 1.0
                    }
                    Text {
                        text:           qsTr("Sensor de proximidade")
                        color:          _textSecondary
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.65
                    }

                    Rectangle {
                        width:        lsr.implicitWidth + ScreenTools.defaultFontPixelWidth * 1.2
                        height:       ScreenTools.defaultFontPixelHeight * 0.95
                        radius:       height / 2
                        color:        pxrType ? Qt.rgba(0, 0.81, 1, 0.15) : Qt.rgba(1,1,1,0.05)
                        border.color: pxrType ? _accent : _border
                        border.width: 1
                        Behavior on color        { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        Row {
                            id:               lsr
                            anchors.centerIn: parent
                            spacing:          ScreenTools.defaultFontPixelWidth * 0.4
                            Rectangle {
                                width:                  ScreenTools.defaultFontPixelHeight * 0.38
                                height:                 width
                                radius:                 width / 2
                                color:                  pxrType ? _accent : _textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                            Text {
                                text:               pxrType ? qsTr("LIGADO") : qsTr("DESLIGADO")
                                color:              pxrType ? _accent : _textSecondary
                                font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.58
                                font.bold:          true
                                font.letterSpacing: 0.6
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }
                }

                Item {
                    width:  ScreenTools.defaultFontPixelWidth  * 5.8
                    height: ScreenTools.defaultFontPixelHeight * 1.6
                    anchors.right:          parent.right
                    anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 0.8
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius:       height / 2
                        color:        pxrType ? Qt.rgba(0,0.81,1,0.22) : "#18212E"
                        border.color: pxrType ? _accent : _border
                        border.width: 1
                        Behavior on color        { ColorAnimation { duration: 220 } }
                        Behavior on border.color { ColorAnimation { duration: 220 } }
                    }

                    Rectangle {
                        width:  ScreenTools.defaultFontPixelHeight * 1.15
                        height: width
                        radius: width / 2
                        color:  pxrType ? _accent : _textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                        x: pxrType ? parent.width - width - ScreenTools.defaultFontPixelWidth * 0.35
                                   : ScreenTools.defaultFontPixelWidth * 0.35
                        Behavior on x     { SmoothedAnimation { velocity: 280 } }
                        Behavior on color { ColorAnimation    { duration: 220 } }

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 1.8; height: parent.height * 1.8
                            radius: width / 2; color: "transparent"
                            border.color: pxrType ? Qt.rgba(0,0.81,1,0.35) : "transparent"
                            border.width: 1
                            Behavior on border.color { ColorAnimation { duration: 220 } }
                        }
                    }
                }

                MouseArea {
                    id:           laserMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (!QGroundControl.multiVehicleManager.activeVehicle ||
                            QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                        } else {
                            pxrType = !pxrType
                            controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value    = pxrType ? 4 : 0
                            console.log("Valor a ser enviado para PRX1_TYPE: ",    controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value)
                            controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value = pxrType ? 8 : 0
                            console.log("Valor a ser enviado para RNGFND1_TYPE: ", controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value)
                            controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value = pxrType ? 3 : 1
                            console.log("Valor a ser enviado para AVOID_ENABLE: ", controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value)
                            mainWindow.showMessageDialog(qsTr("LASER"),
                                                         qsTr("É preciso reiniciar o drone para a aplicação funcionar"))
                        }
                    }
                }

                Connections {
                    target: controllerLoader.item.getParameterFact(-1, "PRX1_TYPE")
                    onValueChanged: { pxrType = (value === 4) }
                }
            }

            // separator
            Rectangle { width: parent.width; height: 1; color: _border; opacity: 0.5 }

            // ── FLOW ──────────────────────────────────────────────────────────
            Item {
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 6.5

                Rectangle {
                    anchors.fill:    parent
                    anchors.margins: ScreenTools.defaultFontPixelHeight * 0.25
                    radius:          ScreenTools.defaultFontPixelWidth  * 0.8
                    color:           flowMa.containsMouse ? "#131E1A" : "transparent"
                    border.color:    flowMa.containsMouse ? "#1E5040" : "transparent"
                    border.width:    1
                    Behavior on color        { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                }

                Rectangle {
                    id:           flowIcon
                    width:        ScreenTools.defaultFontPixelHeight * 3
                    height:       ScreenTools.defaultFontPixelHeight * 3
                    radius:       ScreenTools.defaultFontPixelWidth  * 0.6
                    color:        Qt.rgba(0, 0.84, 0.56, 0.10)
                    border.color: Qt.rgba(0, 0.84, 0.56, 0.30)
                    border.width: 1
                    anchors.left:           parent.left
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.8
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text:           "F"
                        color:          _success
                        font.bold:      true
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.15
                        anchors.centerIn: parent
                    }
                }

                Column {
                    anchors.left:           flowIcon.right
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 1.2
                    anchors.verticalCenter: parent.verticalCenter
                    spacing:                ScreenTools.defaultFontPixelHeight * 0.2

                    Text {
                        text:               qsTr("FLOW")
                        color:              _textPrimary
                        font.bold:          true
                        font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.88
                        font.letterSpacing: 1.0
                    }
                    Text {
                        text:           qsTr("Sensor de fluxo óptico")
                        color:          _textSecondary
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.65
                    }

                    Rectangle {
                        width:        flr.implicitWidth + ScreenTools.defaultFontPixelWidth * 1.2
                        height:       ScreenTools.defaultFontPixelHeight * 0.95
                        radius:       height / 2
                        color:        flowType ? Qt.rgba(0,0.84,0.56,0.15) : Qt.rgba(1,1,1,0.05)
                        border.color: flowType ? _success : _border
                        border.width: 1
                        Behavior on color        { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        Row {
                            id:               flr
                            anchors.centerIn: parent
                            spacing:          ScreenTools.defaultFontPixelWidth * 0.4
                            Rectangle {
                                width:                  ScreenTools.defaultFontPixelHeight * 0.38
                                height:                 width
                                radius:                 width / 2
                                color:                  flowType ? _success : _textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                            Text {
                                text:               flowType ? qsTr("LIGADO") : qsTr("DESLIGADO")
                                color:              flowType ? _success : _textSecondary
                                font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.58
                                font.bold:          true
                                font.letterSpacing: 0.6
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }
                }

                Item {
                    width:  ScreenTools.defaultFontPixelWidth  * 5.8
                    height: ScreenTools.defaultFontPixelHeight * 1.6
                    anchors.right:          parent.right
                    anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 0.8
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius:       height / 2
                        color:        flowType ? Qt.rgba(0,0.84,0.56,0.22) : "#18212E"
                        border.color: flowType ? _success : _border
                        border.width: 1
                        Behavior on color        { ColorAnimation { duration: 220 } }
                        Behavior on border.color { ColorAnimation { duration: 220 } }
                    }

                    Rectangle {
                        width:  ScreenTools.defaultFontPixelHeight * 1.15
                        height: width
                        radius: width / 2
                        color:  flowType ? _success : _textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                        x: flowType ? parent.width - width - ScreenTools.defaultFontPixelWidth * 0.35
                                    : ScreenTools.defaultFontPixelWidth * 0.35
                        Behavior on x     { SmoothedAnimation { velocity: 280 } }
                        Behavior on color { ColorAnimation    { duration: 220 } }

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 1.8; height: parent.height * 1.8
                            radius: width / 2; color: "transparent"
                            border.color: flowType ? Qt.rgba(0,0.84,0.56,0.35) : "transparent"
                            border.width: 1
                            Behavior on border.color { ColorAnimation { duration: 220 } }
                        }
                    }
                }

                MouseArea {
                    id:           flowMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (!QGroundControl.multiVehicleManager.activeVehicle ||
                            QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                            mainWindow.showMessageDialog(qsTr("Definir Laser"),
                                                         qsTr("Você precisa estar conectado ao drone."))
                        } else {
                            flowType = !flowType
                            controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value = flowType ? 6 : 0
                            console.log("Valor a ser enviado para FLOW_TYPE: ", controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value)
                        }
                    }
                }

                Connections {
                    target: controllerLoader.item.getParameterFact(-1, "FLOW_TYPE")
                    onValueChanged: { flowType = (value === 6) }
                }
            }
        }
    }
}
