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
import QGroundControl.FactControls    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import Qt5Compat.GraphicalEffects   

Item{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 

    property var now:               new Date()
    property int year:              now.getFullYear()
    property string month:          (now.getMonth() + 1) < 10 ? "0" + (now.getMonth() + 1) : "" + (now.getMonth() + 1)
    property string day:            now.getDate() < 10 ? "0" + now.getDate() : "" + now.getDate()

    QGCPalette { id:qgcPal }

    Rectangle{
        id:                         supportView
        width:                      ScreenTools.defaultFontPixelWidth * 70
        height:                     ScreenTools.defaultFontPixelHeight * 21
        color:                      qgcPal.iconColor
        border.color:               qgcPal.cleanColor
        border.width:               ScreenTools.defaultFontPixelHeight * 0.0581
        anchors{
            verticalCenter:         parent.verticalCenter 
            horizontalCenter:       parent.horizontalCenter 
        }
        /* BackGround */
        Rectangle{
            width:                      ScreenTools.defaultFontPixelWidth * 70
            height:                     ScreenTools.defaultFontPixelHeight * 2.919
            radius:                     0
            color:                      qgcPal.cleanColor

            Text{
                text:                   qsTr("Suporte")
                font.bold:              true 
                font.pointSize:         30
                anchors.centerIn:       parent 
                color:                  qgcPal.iconColor
            }
            Text{
                text:                   "X"
                font.bold:              true 
                font.pointSize:         25
                color:                  qgcPal.iconColor
                anchors{
                    right:              parent.right 
                    verticalCenter:     parent.verticalCenter 
                    rightMargin:        ScreenTools.defaultFontPixelWidth * 0.35
                }
                MouseArea{
                    anchors.fill:       parent 
                    onClicked: {
                        root.visible    =   false;
                    }
                }
            }
        }

        Column{
            anchors{
                top:                parent.top
                topMargin:          ScreenTools.defaultFontPixelHeight * 4.375
                left:               parent.left 
                leftMargin:         ScreenTools.defaultFontPixelWidth * 3.5
            }
            /* E-mail */
            Item {
                Column{
                    spacing:        ScreenTools.defaultFontPixelHeight * 1.456
                    /* E-mail */
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth * 0.35
                        Image {
                            source:     "/InstrumentValueIcons/at-symbol.svg"
                            width:      ScreenTools.defaultFontPixelWidth * 3.5
                            height:     ScreenTools.defaultFontPixelHeight * 1.456
                            layer.enabled: true
                            layer.effect: ColorOverlay {
                                color: qgcPal.textColor
                            }
                        }
                        Column {
                            spacing:    ScreenTools.defaultFontPixelHeight * 0.0581
                            Text {
                                text:   qsTr("E-mail")
                                color:  qgcPal.textColor
                                font.bold: true
                            }
                            Text {
                                text:   "suporte@skydrones.com.br"
                                color: qgcPal.textColor
                            }
                        }
                    }
                    /* Site */
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth * 0.35
                        Image {
                            source:             "/InstrumentValueIcons/link.svg"
                            layer.enabled:      true
                            width:              ScreenTools.defaultFontPixelWidth * 3.5
                            height:             ScreenTools.defaultFontPixelHeight * 1.456
                            layer.effect:       ColorOverlay {
                                color:          qgcPal.textColor
                            }
                        }
                        Column {
                            spacing:    ScreenTools.defaultFontPixelHeight * 0.0581
                            Text {
                                text:           qsTr("Site")
                                color:          qgcPal.textColor
                                font.bold:      true
                            }
                            Text {
                                text:           "www.skydrones.com.br"
                                color:          qgcPal.textColor
                                //font.underline: true
                                MouseArea {
                                    anchors.fill:   parent
                                    cursorShape:    Qt.PointingHandCursor
                                    onClicked: {
                                        Qt.openUrlExternally("https://skydrones.com.br/")
                                    }
                                }
                            }
                        }
                    }
                    /* Telefone */
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth * 0.35
                        Image {
                            source:     "/InstrumentValueIcons/phone.svg"
                            layer.enabled: true
                            width:              ScreenTools.defaultFontPixelWidth * 3.5
                            height:             ScreenTools.defaultFontPixelHeight * 1.456
                            layer.effect: ColorOverlay {
                                color: qgcPal.textColor
                            }
                        }
                        Column {
                            spacing:    ScreenTools.defaultFontPixelHeight * 0.0581
                            Text {
                                text:   qsTr("Telefone")
                                color:  qgcPal.textColor
                                font.bold: true
                            }
                            Text {
                                text:   "+55 51 3328.6091 | +55 51 995-950-550 |"
                                color: qgcPal.textColor
                            }
                        }
                    }
                    /* Versão do App */
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth * 0.35
                        Image {
                            source:     "/InstrumentValueIcons/tablet.svg"
                            layer.enabled: true
                            width:              ScreenTools.defaultFontPixelWidth * 3.5
                            height:             ScreenTools.defaultFontPixelHeight * 1.456
                            layer.effect: ColorOverlay {
                                color: qgcPal.textColor
                            }
                        }
                        Column {
                            spacing:    ScreenTools.defaultFontPixelHeight * 0.0581
                            Text {
                                text:   qsTr("Versão do Aplicativo")
                                color:  qgcPal.textColor
                                font.bold: true
                            }
                            Text {
                                id:     appVersionText
                                text:   "1.1." + year + day + month + "-test"
                                color: qgcPal.textColor
                            }
                        }
                    }
                }
            }
            
        }
    }
}