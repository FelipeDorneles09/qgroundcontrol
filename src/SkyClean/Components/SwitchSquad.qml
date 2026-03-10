/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                      				2.12
import QtQuick.Controls             				2.4
import QtQuick.Dialogs              				
import QtQuick.Layouts              				1.12
import QtLocation                   				5.3
import QtPositioning                				5.3
import QtQuick.Window               				2.2
import QtQml.Models                 				2.1
import QGroundControl               				1.0
import QGroundControl.Controls      				1.0
import QGroundControl.FactControls    				1.0
import QGroundControl.FlightDisplay 				1.0
import QGroundControl.FlightMap     				1.0
import QtCore

Rectangle{
    id:                                         root 
    width:                                      setWidth
    height:                                     setHeight
    radius:                                     10
    border.color:                               "white"
    border.width:                               5
    color:                                      "black"
    //opacity:                                    enabled && !mouseArea.pressed ? 1 : 0.3

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


    Text{
        text:                                   isChecked ? trueTxt : falseTxt
        color:                                  qgcPal.textColor       
        anchors.centerIn:                       parent          
    }

    Rectangle{
        id:                                     pill 
        width:                                  root.setWidth / 5
        height:                                 root.setHeight
        color:                                  qgcPal.cleanColor
        radius:                                 10
        x:                                      isChecked ? root.width - pill.width : 0

    }

    MouseArea{
        id:                                     mouseArea 
        anchors.fill:                           parent 

        drag{
            target:                             pill
            axis:                               Drag.XAxis 
            maximumX:                           root.width - pill.width 
            minimumX:                           0
        }

        onReleased: {
            if( isChecked && pill.x < root.width - pill.width)  root.clicked(false)
            if(!isChecked  &&  pill.x)                          root.clicked(true )
        }
        onClicked: root.clicked(!isChecked)
    }
    Connections {
        target: root
        onClicked: {
            isChecked = !isChecked
        }
    }
    
}