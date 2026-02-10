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

Item {
    id: _root
    anchors.fill: parent
    visible: proximityValues.telemetryAvailable

    QGCPalette { id: qgcPal }

    property var vehicle     
    property real range: 6   

    property var _minlength: Math.min(_root.width, _root.height)
    property var _ratio: (_minlength / 2) / _root.range

    ProximityRadarValues {
        id: proximityValues
        vehicle: _root.vehicle
        onRotationValueChanged: _sectorViewEllipsoid.requestPaint() 
    }

    Item {
        anchors.fill: parent

        Text {
            text: proximityValues.rotationNoneValueString[0] !== proximityValues._noValueStr ? 
                  proximityValues.rotationNoneValueString[0] : "N/A"
            color: qgcPal.iconColor
            font.bold: true 
            font.pointSize: 16
            visible: !isNaN(proximityValues.rotationNoneValue)
            anchors {
                left: parent.left 
                leftMargin: 100
            }
        }
    }
}