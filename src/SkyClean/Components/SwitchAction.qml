/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                                  2.12
import QtQuick.Controls                         2.4
import QtQuick.Dialogs                          1.3
import QtQuick.Layouts                          1.12
import QtLocation                               5.3
import QtPositioning                            5.3
import QtQuick.Window                           2.2
import QtQml.Models                             2.1
import QGroundControl                           1.0
import QGroundControl.Controls                  1.0
import QGroundControl.Airspace                  1.0
import QGroundControl.Airmap                    1.0
import QGroundControl.Controllers               1.0
import QGroundControl.Controls                  1.0
import QGroundControl.FactSystem                1.0
import QGroundControl.FlightDisplay             1.0
import QGroundControl.FlightMap                 1.0
import QGroundControl.Palette                   1.0
import QGroundControl.ScreenTools               1.0
import QGroundControl.Vehicle                   1.0
import SiYi.Object                              1.0
import QtQuick.Controls.Styles                  1.4
import Qt.labs.settings                         1.0

Rectangle{
    id:                                         root 
    width:                                      setWidth
    height:                                     setHeight
    radius:                                     ScreenTools.defaultFontPixelWidth * 3.5
    border.color:                               qgcPal.cleanColor
    border.width:                               ScreenTools.defaultFontPixelHeight * 0.147
    color:                                      qgcPal.iconColor

    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    scale:                                      mouseArea.pressed ? 0.98 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
    }

    QGCPalette { id:qgcPal }
    signal clicked(bool isChecked);
    
    //private
    property int setWidth:                      0
    property int setHeight:                     0
    property bool isChecked:                    switchSettings.savedState
    property url falseImg:                      ""
    property url trueImg:                       ""
    property string falseTxt:                   ""
    property string trueTxt:                    ""
    property alias saveValue:                   appSettings.saveValue
    property Fact fact: Fact { }
    
    Settings {
        id: appSettings
        property bool saveValue: false
    }

    Rectangle {
        anchors.fill:                           parent
        radius:                                 parent.radius
        color:                                  "white"
        opacity:                                mouseArea.containsMouse ? 0.05 : 0
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    Text{
        text:                                   isChecked ? trueTxt : falseTxt
        color:                                  qgcPal.textColor
        font.pixelSize:                         root.height * 0.25
        font.weight:                            Font.Medium
        anchors.centerIn:                       parent
        opacity:                                0.9
        
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: parent; property: "opacity"; to: 0.5; duration: 100 }
                NumberAnimation { target: parent; property: "opacity"; to: 0.9; duration: 100 }
            }
        }
    }

    Rectangle{
        id:                                     pill 
        width:                                  height
    height:                                 ScreenTools.defaultFontPixelHeight * 2.919
        color:                                  qgcPal.cleanColor
        radius:                                 height
        x:                                      isChecked ? root.width - pill.width : 0
        
        Behavior on x {
            NumberAnimation { 
                duration: 300
                easing.type: Easing.InOutCubic
            }
        }

        scale:                                  mouseArea.pressed ? 0.95 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        Image{
            source:                             isChecked ? trueImg : falseImg
            anchors.centerIn:                   parent
            width:                              parent.width * 0.9
            height:                             parent.height * 0.9
            fillMode:                           Image.PreserveAspectFit
            smooth:                             true
            
            opacity:                            1.0
            Behavior on source {
                SequentialAnimation {
                    NumberAnimation { target: parent; property: "opacity"; to: 0; duration: 100 }
                    PropertyAction { target: parent; property: "source" }
                    NumberAnimation { target: parent; property: "opacity"; to: 1.0; duration: 100 }
                }
            }
        }
    }

    MouseArea{
        id:                                     mouseArea 
        anchors.fill:                           parent 
        hoverEnabled:                           true
        cursorShape:                            Qt.PointingHandCursor
        onClicked:                              root.clicked(!isChecked)
    }
    
    Connections {
        target: root
        onClicked: {
            isChecked = !isChecked
        }
    }
}