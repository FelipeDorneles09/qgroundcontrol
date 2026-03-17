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
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width:  parent.width
    height: parent.height

    property var    now:    new Date()
    property int    year:   now.getFullYear()
    property string month:  (now.getMonth() + 1) < 10 ? "0" + (now.getMonth() + 1) : "" + (now.getMonth() + 1)
    property string day:    now.getDate() < 10 ? "0" + now.getDate() : "" + now.getDate()

    QGCPalette { id: qgcPal }

    // Backdrop blur overlay
    Rectangle {
        anchors.fill:   parent
        color:          "#80000000"
        MouseArea {
            anchors.fill: parent
            onClicked:    root.visible = false
        }
    }

    // Main card
    Rectangle {
        id:             card
        width:          ScreenTools.defaultFontPixelWidth  * 60
        height:         ScreenTools.defaultFontPixelHeight * 24
        radius:         ScreenTools.defaultFontPixelHeight * 0.75
        color:          qgcPal.iconColor
        anchors {
            verticalCenter:   parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        // Subtle drop shadow simulation via layered rect
        layer.enabled:  true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset:  0
            verticalOffset:    ScreenTools.defaultFontPixelHeight * 0.5
            radius:            ScreenTools.defaultFontPixelHeight * 1.5
            samples:           17
            color:             "#55000000"
        }

        Column {
            id:         cardColumn
            width:      parent.width
            spacing:    0

            // ── Header ─────────────────────────────────────────────
            Rectangle {
                id:     header
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 4.2
                radius: card.radius
                color:  qgcPal.cleanColor   // #6acce0 — accent teal

                // Square bottom corners
                Rectangle {
                    width:  parent.width
                    height: parent.radius
                    anchors.bottom: parent.bottom
                    color:  parent.color
                }

                // Title
                Row {
                    anchors.centerIn: parent
                    spacing: ScreenTools.defaultFontPixelWidth * 1

                    Image {
                        source:        "/InstrumentValueIcons/tablet.svg"
                        width:         ScreenTools.defaultFontPixelHeight * 1.6
                        height:        width
                        anchors.verticalCenter: parent.verticalCenter
                        layer.enabled: true
                        layer.effect:  ColorOverlay { color: "#ffffff" }
                    }
                    Text {
                        text:           qsTr("Suporte SkyDrones")
                        font.bold:      true
                        font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                        color:          "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Close button
                Rectangle {
                    id:     closeBtn
                    width:  ScreenTools.defaultFontPixelHeight * 2.5
                    height: width
                    radius: width / 2
                    color:  closeHover.containsMouse ? "#40ffffff" : "#25ffffff"
                    anchors {
                        right:          parent.right
                        rightMargin:    ScreenTools.defaultFontPixelWidth * 1.5
                        verticalCenter: parent.verticalCenter
                    }
                    border.color: '#83ffffff'
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        text:            "X"
                        font.pointSize:  ScreenTools.defaultFontPointSize * 1.2
                        font.bold:       true
                        color:           "#ffffff"
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        id:            closeHover
                        anchors.fill:  parent
                        hoverEnabled:  true
                        cursorShape:   Qt.PointingHandCursor
                        onClicked:     root.visible = false
                    }
                }
            } // header

            // ── Accent divider line ─────────────────────────────────
            Rectangle {
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 0.15
                color:  qgcPal.cleanColor
                opacity: 0.25
            }

            // ── Contact items ───────────────────────────────────────
            Column {
                width:          parent.width
                padding:        ScreenTools.defaultFontPixelWidth * 2.5
                topPadding:     ScreenTools.defaultFontPixelHeight * 1.2
                bottomPadding:  ScreenTools.defaultFontPixelHeight * 1.2
                spacing:        ScreenTools.defaultFontPixelHeight * 0.6

                // E-mail row
                ContactRow {
                    iconSource:  "/InstrumentValueIcons/at-symbol.svg"
                    label:       qsTr("E-mail")
                    value:       "suporte@skydrones.com.br"
                    accentColor: qgcPal.cleanColor
                    textColor:   qgcPal.textColor
                    iconColor:   qgcPal.cleanColor
                    rowWidth:    card.width - ScreenTools.defaultFontPixelWidth * 5
                }

                // Divider
                Rectangle {
                    width:   card.width - ScreenTools.defaultFontPixelWidth * 5
                    height:  1
                    color:   qgcPal.textColor
                    opacity: 0.08
                }

                // Site row
                ContactRow {
                    iconSource:  "/InstrumentValueIcons/link.svg"
                    label:       qsTr("Site")
                    value:       "www.skydrones.com.br"
                    accentColor: qgcPal.cleanColor
                    textColor:   qgcPal.textColor
                    iconColor:   qgcPal.cleanColor
                    rowWidth:    card.width - ScreenTools.defaultFontPixelWidth * 5
                    clickable:   true
                    onRowClicked: Qt.openUrlExternally("https://skydrones.com.br/")
                }

                // Divider
                Rectangle {
                    width:   card.width - ScreenTools.defaultFontPixelWidth * 5
                    height:  1
                    color:   qgcPal.textColor
                    opacity: 0.08
                }

                // Telefone row
                ContactRow {
                    iconSource:  "/InstrumentValueIcons/phone.svg"
                    label:       qsTr("Telefone")
                    value:       "+55 51 3328.6091  ·  +55 51 99595-0550"
                    accentColor: qgcPal.cleanColor
                    textColor:   qgcPal.textColor
                    iconColor:   qgcPal.cleanColor
                    rowWidth:    card.width - ScreenTools.defaultFontPixelWidth * 5
                }

                // Divider
                Rectangle {
                    width:   card.width - ScreenTools.defaultFontPixelWidth * 5
                    height:  1
                    color:   qgcPal.textColor
                    opacity: 0.08
                }

                // Versão row
                ContactRow {
                    iconSource:  "/InstrumentValueIcons/tablet.svg"
                    label:       qsTr("Versão do Aplicativo")
                    value:       "1.1." + year + day + month
                    accentColor: qgcPal.cleanColor
                    textColor:   qgcPal.textColor
                    iconColor:   qgcPal.cleanColor
                    rowWidth:    card.width - ScreenTools.defaultFontPixelWidth * 5
                    badgeMode:   true
                }
            }

            // ── Footer strip ────────────────────────────────────────
            Rectangle {
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 2.2
                radius: card.radius
                color:  Qt.rgba(
                            Qt.lighter(qgcPal.cleanColor, 1.0).r,
                            Qt.lighter(qgcPal.cleanColor, 1.0).g,
                            Qt.lighter(qgcPal.cleanColor, 1.0).b,
                            0.12)

                // Square top corners
                Rectangle {
                    width:  parent.width
                    height: parent.radius
                    anchors.top: parent.top
                    color:       parent.color
                }

                Text {
                    anchors.centerIn:   parent
                    text:               qsTr("© %1 SkyDrones Tecnologia Aviônica").arg(year)
                    font.pointSize:     ScreenTools.defaultFontPointSize * 0.75
                    color:              qgcPal.textColor
                    opacity:            0.5
                }
            }

        } // cardColumn
    } // card


    // ── Reusable contact row component (inline) ─────────────────────
    component ContactRow: Item {
        id:             cRow
        width:          rowWidth
        height:         ScreenTools.defaultFontPixelHeight * 3.4

        property string iconSource:  ""
        property string label:       ""
        property string value:       ""
        property color  accentColor: "teal"
        property color  textColor:   "black"
        property color  iconColor:   "teal"
        property int    rowWidth:    300
        property bool   clickable:   false
        property bool   badgeMode:   false
        signal rowClicked()

        Rectangle {
            anchors.fill:  parent
            radius:        ScreenTools.defaultFontPixelHeight * 0.5
            color:         rowHover.containsMouse && cRow.clickable ? Qt.rgba(cRow.accentColor.r, cRow.accentColor.g, cRow.accentColor.b, 0.08) : "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Row {
            anchors {
                left:           parent.left
                leftMargin:     ScreenTools.defaultFontPixelWidth * 0.5
                verticalCenter: parent.verticalCenter
            }
            spacing: ScreenTools.defaultFontPixelWidth * 2

            // Icon pill
            Rectangle {
                width:  ScreenTools.defaultFontPixelHeight * 2.4
                height: width
                radius: width / 2
                color:  Qt.rgba(cRow.accentColor.r, cRow.accentColor.g, cRow.accentColor.b, 0.15)
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    source:        cRow.iconSource
                    width:         ScreenTools.defaultFontPixelHeight * 1.1
                    height:        width
                    anchors.centerIn: parent
                    layer.enabled: true
                    layer.effect:  ColorOverlay { color: cRow.accentColor }
                }
            }

            // Text block
            Column {
                spacing:            ScreenTools.defaultFontPixelHeight * 0.1
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text:           cRow.label
                    color:          cRow.textColor
                    font.bold:      true
                    font.pointSize: ScreenTools.defaultFontPointSize * 0.78
                    opacity:        0.6
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing:  0.8
                }

                Row {
                    spacing: ScreenTools.defaultFontPixelWidth * 1

                    Text {
                        text:           cRow.value
                        color:          cRow.clickable ? cRow.accentColor : cRow.textColor
                        font.pointSize: ScreenTools.defaultFontPointSize * 1.0
                        font.underline: cRow.clickable && rowHover.containsMouse
                    }

                    // Version badge
                    Rectangle {
                        visible:    cRow.badgeMode
                        width:      badgeText.implicitWidth + ScreenTools.defaultFontPixelWidth * 1.5
                        height:     ScreenTools.defaultFontPixelHeight * 1.2
                        radius:     height / 2
                        color:      Qt.rgba(cRow.accentColor.r, cRow.accentColor.g, cRow.accentColor.b, 0.2)
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id:             badgeText
                            text:           "STABLE"
                            color:          cRow.accentColor
                            font.bold:      true
                            font.pointSize: ScreenTools.defaultFontPointSize * 0.65
                            font.capitalization: Font.AllUppercase
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        // Arrow icon for clickable rows
        Image {
            visible:       cRow.clickable
            source:        "/InstrumentValueIcons/link.svg"
            width:         ScreenTools.defaultFontPixelHeight * 0.9
            height:        width
            anchors {
                right:          parent.right
                rightMargin:    ScreenTools.defaultFontPixelWidth * 1
                verticalCenter: parent.verticalCenter
            }
            opacity: rowHover.containsMouse ? 1.0 : 0.35
            Behavior on opacity { NumberAnimation { duration: 120 } }
            layer.enabled: true
            layer.effect:  ColorOverlay { color: cRow.accentColor }
        }

        MouseArea {
            id:            rowHover
            anchors.fill:  parent
            hoverEnabled:  true
            cursorShape:   cRow.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked:     if (cRow.clickable) cRow.rowClicked()
        }
    }

}
