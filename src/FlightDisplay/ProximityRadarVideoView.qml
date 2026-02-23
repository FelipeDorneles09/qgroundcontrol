/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  
import QtLocation               
import QtPositioning            
import Qt5Compat.GraphicalEffects       

import QGroundControl                   
import QGroundControl.Controls      
import QGroundControl.FlightDisplay 

Item {
    id:             _root
    anchors.fill:   parent
    visible:        proximityValues.telemetryAvailable

    property var    vehicle     ///< Vehicle object, undefined for ADSB vehicle
    property real   range:  6   ///< Default 6m view

    property var _minlength:    Math.min(_root.width,_root.height)
    property var _ratio:        (_minlength / 2) / _root.range

    ProximityRadarValues {
        id:                     proximityValues
        vehicle:                _root.vehicle
        onRotationValueChanged: _sectorViewEllipsoid.requestPaint()
    }

    Canvas{
        id:             _sectorViewEllipsoid
        anchors.fill:   _root
        opacity:        0.5

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.translate(width/2, height/2)
            ctx.strokeStyle = Qt.rgba(1, 0, 0, 1);
            ctx.lineWidth = width/100;
            ctx.scale(_root.width  / _minlength, _root.height / _minlength);
            ctx.rotate(-Math.PI/2 - Math.PI/8);
            // Only draw the radar value with orientation == 0 (rotationNone)
            var rotationValue = proximityValues.rgRotationValues.length > 0 ? proximityValues.rgRotationValues[0] : NaN;
            if (!isNaN(rotationValue)) {
                // Draw only the first sector (index 0)
                var a = Math.PI/4 * 0;
                ctx.beginPath();
                ctx.arc(0, 0, rotationValue * _ratio, 0 + a + Math.PI/50, Math.PI/4 + a - Math.PI/50, false);
                ctx.stroke();
            }
        }
    }

    Item {
        anchors.fill: parent

        Repeater{
            // Only show the label for orientation == 0 (rotationNone)
            model: 1

            QGCLabel{
                x:                      (_sectorViewEllipsoid.width / 2) - (width / 2)
                y:                      (_sectorViewEllipsoid.height / 2) - (height / 2)
                text:                   proximityValues.rgRotationValueStrings[0]
                font.family:            ScreenTools.demiboldFontFamily
                visible:                !isNaN(proximityValues.rgRotationValues[0])

                transform: Translate {
                    x: Math.cos(-Math.PI/2 + Math.PI/4 * 0) * (proximityValues.rgRotationValues[0] * _ratio)
                    y: Math.sin(-Math.PI/2 + Math.PI/4 * 0) * (proximityValues.rgRotationValues[0] * _ratio)
                }
            }
        }
        transform: Scale {
            origin.x:       _sectorViewEllipsoid.width / 2
            origin.y:       _sectorViewEllipsoid.height / 2
            xScale:         _root.width  / _minlength
            yScale:         _root.height / _minlength
        }
    }

}

