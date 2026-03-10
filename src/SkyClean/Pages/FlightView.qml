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
import Qt5Compat.GraphicalEffects   

Item {
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 

    //private
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property string _altitude:              _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _distanceStr:           isNaN(_distance) ? "0" : _distance.toFixed(0) + ' ' + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property real   _heading:               _activeVehicle   ? _activeVehicle.heading.rawValue : 0
    property real   _distance:              _activeVehicle ? _activeVehicle.distanceToHome.rawValue : 0
    property string _messageTitle:          ""
    property string _messageText:           ""
    property var    battery:                _activeVehicle ? (isNaN(_activeVehicle.battery.voltage.rawValue)) : 0
    property Fact flightTimeFact: _activeVehicle ? _activeVehicle.getFact("FlightTime") : null
    property real   _fixedTextWidth:        ScreenTools.defaultFontPixelWidth * 7

    //import
    QGCPalette { id: qgcPal }

    function getVerticalSpeed(){
        var _temp="0.0"
        var  _speed
        if (_activeVehicle){
            if (_activeVehicle.climbRate.rawValue >=0 ){
                _temp= " " + _activeVehicle.climbRate.rawValue.toFixed(1) + ' ' +_activeVehicle.climbRate.units;
                
            }else{
                if (true/*_speed < 0.1*/){
                    _temp=" " + _activeVehicle.climbRate.rawValue.toFixed(1)  + ' ' +_activeVehicle.climbRate.units;
                }else{
                
                }
            }
        }
        return _temp
    }
     function secondsToHHMMSS(timeS) {
        var sec_num = parseInt(timeS, 10);
        var minutes = Math.floor(sec_num / 60);
        var seconds = sec_num % 60;
        
        if (minutes < 10) {
            minutes = "0" + minutes;
        }
        if (seconds < 10) {
            seconds = "0" + seconds;
        }
        
        return minutes + ':' + seconds;
    }

    Rectangle{
        width:                          parent.width 
        height:                         ScreenTools.defaultFontPixelWidth * 6
        color:                          "#6acce0"
        opacity:                        60
        radius:                         ScreenTools.defaultFontPixelWidth * 2
        anchors{
            bottom:                     parent.bottom 
        }

       GridLayout {
            id:                     vehicleStatusGrid
            Layout.rowSpan:         12
            Layout.column:          12
            Layout.minimumWidth:    mainIsMap ? vehicleIndicator.height * 1.25 : vehicleIndicator.height * 1.25
            Layout.fillHeight:      true
            Layout.fillWidth:       true
            anchors.left:           parent.left 
            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 3
            anchors.bottom:         parent.bottom
            anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 0.65

            Row {
                spacing: ScreenTools.defaultFontPixelWidth * 2

                // Altitude
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    
                    Image{
                        source:             "/skyclean/Altitude"
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                        text:               _altitude
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     11
                        width:              _fixedTextWidth * 0.8 // <-- LARGURA FIXA AQUI
                        horizontalAlignment: Text.AlignLeft
                        anchors.bottom:     parent.bottom
                    }
                }

                // Flight Time
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    
                    Image{
                        source:             "/skyclean/Time"
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                        text: flightTimeFact ? secondsToHHMMSS(flightTimeFact.rawValue) : "00:00  | "
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     11
                        width:              _fixedTextWidth * 0.8 // <-- LARGURA FIXA AQUI
                        horizontalAlignment: Text.AlignLeft
                        anchors.bottom:     parent.bottom
                    }
                }                                
                
                // HorizontalSpeed
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    
                    Image{
                        source:             "/skyclean/HorizontalSpeed"
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                       text:                _activeVehicle ? _activeVehicle.groundSpeed.rawValue.toFixed(1) + ' ' + _activeVehicle.groundSpeed.units : "0.0"  + " | "                            
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     11
                        width:              _fixedTextWidth // <-- LARGURA FIXA AQUI
                        horizontalAlignment: Text.AlignLeft
                        anchors.bottom:     parent.bottom
                    }
                }

                // VerticalSpeed
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    
                    Image{
                        source:             "/skyclean/VerticalSpeed"
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                       text:                _activeVehicle ? _activeVehicle.climbRate.rawValue.toFixed(1) + ' ' + _activeVehicle.climbRate.units : "0.0"  + " | " 
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     11
                        width:              _fixedTextWidth // <-- LARGURA FIXA AQUI
                        horizontalAlignment: Text.AlignLeft
                        anchors.bottom:     parent.bottom
                    }
                }

                // Distance
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    
                    Image{
                        source:             "/skyclean/Distance"
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                        text:               _activeVehicle ? ('00000' + _activeVehicle.distanceToHome.rawValue.toFixed(0)).slice(-5) + ' ' + _activeVehicle.distanceToHome.units : "00000" + " | "
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     11
                        width:              _fixedTextWidth // <-- LARGURA FIXA AQUI
                        horizontalAlignment: Text.AlignLeft
                        anchors.bottom:     parent.bottom
                    }
                }

                // Laser Image 
                Row{
                    spacing:        10
                    Image{
                        source: "/skyclean/Radar"
                        anchors.verticalCenter: parent.verticalCenter 
                        width:              ScreenTools.defaultFontPixelWidth * 2.75
                        height:             ScreenTools.defaultFontPixelWidth * 2.75
                        layer.enabled: true 
                        layer.effect: ColorOverlay {
                            opacity: 0.7
                            color: qgcPal.iconColor
                        }
                    }
                    Row{
                        SignalRadar{
                            anchors.fill: parent
                            vehicle: QGroundControl.multiVehicleManager.activeVehicle
                        }
                    }
                }
                
            }
        }
    }
}