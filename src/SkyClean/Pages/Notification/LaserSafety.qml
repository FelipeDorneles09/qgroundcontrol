/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models
import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap

Item {
    id: root
    width: parent.width
    height: parent.height
    z: 30

    // ── properties ────────────────────────────────────────────────────────────
    property string passSky: "SkyP4r4m3tr0$"
    property bool _passwordValid: false

    // ── design tokens ────────────────────────────────────────────────────────
    readonly property color _surface: "#111827"
    readonly property color _surfaceHigh: "#1A2235"
    readonly property color _border: "#243044"
    readonly property color _borderBright: "#3D5070"
    readonly property color _accent: "#00CFFF"
    readonly property color _error: "#FF4D6A"
    readonly property color _textPrimary: "#E8EEF7"
    readonly property color _textSecondary: "#6B80A0"

    QGCPalette { id: qgcPal }

    // ── dimmed backdrop ───────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.82
        MouseArea {
            anchors.fill: parent
            enabled: true
            onClicked: {}
        }
    }

    // ── modal card ────────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: ScreenTools.defaultFontPixelWidth * 45
        height: ScreenTools.defaultFontPixelHeight * 20
        color: _surface
        radius: ScreenTools.defaultFontPixelWidth * 1.4
        border.color: _border
        border.width: 1

        // top glow line
        Rectangle {
            width: parent.width * 0.4
            height: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: _accent }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // ── header ────────────────────────────────────────────────────────────
        Item {
            id: cardHeader
            width: parent.width
            height: ScreenTools.defaultFontPixelHeight * 3.5

            Rectangle {
                width: ScreenTools.defaultFontPixelWidth * 0.3
                height: ScreenTools.defaultFontPixelHeight * 1.4
                radius: 1
                color: _accent
                anchors.left: parent.left
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: qsTr("ACESSO RESTRITO")
                color: _textPrimary
                font.bold: true
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                font.letterSpacing: 1.4
                anchors.left: parent.left
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 3
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                id: closeBtn
                width: ScreenTools.defaultFontPixelHeight * 1.7
                height: ScreenTools.defaultFontPixelHeight * 1.7
                radius: ScreenTools.defaultFontPixelWidth * 0.5
                color: closeMa.containsMouse ? "#3D1A22" : _surfaceHigh
                border.color: closeMa.containsMouse ? _error : _border
                border.width: 1
                anchors.right: parent.right
                anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 130 } }
                Behavior on border.color { ColorAnimation { duration: 130 } }

                Text {
                    text: "x"
                    color: closeMa.containsMouse ? _error : _textSecondary
                    font.bold: true
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                    anchors.centerIn: parent
                    Behavior on color { ColorAnimation { duration: 130 } }
                }

                MouseArea {
                    id: closeMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.visible = false
                }
            }
        }

        Rectangle {
            id: headerDivider
            width: parent.width
            height: 1
            color: _border
            anchors.top: cardHeader.bottom
        }

        // ── content ───────────────────────────────────────────────────────────
        Column {
            anchors.top: headerDivider.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: ScreenTools.defaultFontPixelHeight * 1.2
            anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2.5
            anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2.5
            anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 1.2
            spacing: ScreenTools.defaultFontPixelHeight * 1.2

            // ── description text ──────────────────────────────────────────────
            Text {
                text: qsTr("Insira a senha para acessar ajustes adicionais")
                color: _textSecondary
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
                wrapMode: Text.WordWrap
                width: parent.width
            }

            // ── password input ────────────────────────────────────────────────
            Item {
                width: parent.width
                height: ScreenTools.defaultFontPixelHeight * 3

                Rectangle {
                    anchors.fill: parent
                    color: _surfaceHigh
                    radius: ScreenTools.defaultFontPixelWidth * 0.6
                    border.color: passwordField.activeFocus ? _accent : _border
                    border.width: 1
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    TextField {
                        id: passwordField
                        anchors.fill: parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.8
                        placeholderText: qsTr("Insira a senha")
                        echoMode: TextInput.Password
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.8
                        color: _textPrimary
                        placeholderTextColor: _textSecondary
                        background: Rectangle { color: "transparent" }

                        onTextChanged: {
                            errorMessage.visible = false
                            errorMessage.text = ""
                        }

                        Keys.onReturnPressed: {
                            validatePassword()
                        }
                    }
                }
            }

            // ── error message ─────────────────────────────────────────────────
            Text {
                id: errorMessage
                text: ""
                color: _error
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                visible: false
                wrapMode: Text.WordWrap
                width: parent.width
                Behavior on opacity { PropertyAnimation { duration: 200 } }
            }

            // ── buttons ───────────────────────────────────────────────────────
            Row {
                width: parent.width
                spacing: ScreenTools.defaultFontPixelWidth * 1.5
                layoutDirection: Qt.RightToLeft

                // Cancel button
                Rectangle {
                    width: (parent.width - parent.spacing) / 2
                    height: ScreenTools.defaultFontPixelHeight * 1.8
                    radius: ScreenTools.defaultFontPixelWidth * 0.5
                    color: cancelMa.containsMouse ? Qt.rgba(93, 80, 112, 0.5) : _surfaceHigh
                    border.color: cancelMa.containsMouse ? _borderBright : _border
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Text {
                        text: qsTr("Cancelar")
                        color: _textPrimary
                        font.bold: true
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.8
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: cancelMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.visible = false
                    }
                }

                // Submit button
                Rectangle {
                    width: (parent.width - parent.spacing) / 2
                    height: ScreenTools.defaultFontPixelHeight * 1.8
                    radius: ScreenTools.defaultFontPixelWidth * 0.5
                    color: submitMa.containsMouse ? Qt.rgba(0, 207, 255, 0.25) : Qt.rgba(0, 207, 255, 0.15)
                    border.color: submitMa.containsMouse ? _accent : _border
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Text {
                        text: qsTr("Entrar")
                        color: _accent
                        font.bold: true
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.8
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: submitMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: validatePassword()
                    }
                }
            }
        }
    }

    // ── validation timer ──────────────────────────────────────────────────────
    Timer {
        id: errorTimer
        interval: 4000
        onTriggered: {
            errorMessage.visible = false
            errorMessage.text = ""
        }
    }

    // ── functions ─────────────────────────────────────────────────────────────
    function validatePassword() {
        if (passwordField.text === passSky) {
            passwordField.text = ""
            root.visible = false
            showLaserAdjusted()
        } else {
            errorMessage.text = qsTr("Senha inválida")
            errorMessage.visible = true
            errorTimer.restart()
            passwordField.selectAll()
            passwordField.forceActiveFocus()
        }
    }
}