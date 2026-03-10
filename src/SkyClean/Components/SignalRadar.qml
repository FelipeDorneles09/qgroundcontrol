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
            font.pointSize: 11
            visible: !isNaN(proximityValues.rotationNoneValue)
            anchors {
                left: parent.left 
                leftMargin: 100
            }
        }
    }
}