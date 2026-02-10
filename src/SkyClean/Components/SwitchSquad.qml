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
import QGroundControl.Airspace      				
import QGroundControl.Airmap        				
import QGroundControl.Controllers   				
import QGroundControl.Controls      				
import QGroundControl.FactSystem    				
import QGroundControl.FlightDisplay 				
import QGroundControl.FlightMap     				
import QGroundControl.Palette       				
import QGroundControl.ScreenTools 1.0
import QGroundControl.Vehicle       				
import SiYi.Object                  				
import QtQuick.Controls.Styles                     
import Qt.labs.settings                             

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
        width:                                  100
        height:                                 100
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