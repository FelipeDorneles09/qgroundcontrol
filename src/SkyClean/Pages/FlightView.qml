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
import QGroundControl.FactSystem    
import QGroundControl.FlightDisplay 
import QGroundControl.FlightMap     
import QGroundControl.Palette       
import QGroundControl.ScreenTools
import QGroundControl.Vehicle       
import SiYi.Object                  
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
    property var    battery:                _activeVehicle ? (isNaN(_activeVehicle.battety.voltage.rawValue)) : 0

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
        height:                         70
        color:                          "#6acce0"
        opacity:                        60
        radius:                         20
        anchors{
            bottom:                     parent.bottom 
            bottomMargin:               5
        }

       GridLayout {
            id:                     vehicleStatusGrid
            Layout.rowSpan:         12
            Layout.column:          12
            Layout.minimumWidth:    mainIsMap ? vehicleIndicator.height * 1.25 : vehicleIndicator.height * 1.25
            Layout.fillHeight:      true
            Layout.fillWidth:       true
            anchors.left:           parent.left 
            anchors.leftMargin:     40
            anchors.bottom:         parent.bottom
            anchors.bottomMargin:   5

            Row {
                spacing: 30

                //Altitude
                Row {
                    spacing:    8
                    
                    Image{
                        source:             "/skyclean/Altitude"
                        //width:              20
                        //height:             20
                        //anchors.bottom:     parent.bottom
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                        text:               _altitude + " | "
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     16
                        Layout.fillWidth:   true
                        Layout.minimumWidth: indicatorValueWidth
                        horizontalAlignment: firstLabel.horizontalAlignment
                        anchors.bottom:     parent.bottom
                    }
                }

                // Flight Time
                Row {
                    spacing:    8
                    
                    Image{
                        source:             "/skyclean/Time"
                        //width:              20
                        //height:             20
                        //anchors.bottom:     parent.bottom
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                       text:               {
                            if (_activeVehicle)
                                return secondsToHHMMSS(_activeVehicle.getFact("FlightTime").rawValue)
                            return "00:00"  + " | "
                        }
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     16
                        Layout.fillWidth:   true
                        Layout.minimumWidth: indicatorValueWidth
                        horizontalAlignment: firstLabel.horizontalAlignment
                        anchors.bottom:     parent.bottom
                    }
                }                                
                
                // HorizontalSpeed
                Row {
                    spacing:    8
                    
                    Image{
                        source:             "/skyclean/HorizontalSpeed"
                        //width:              20
                        //height:             20
                        //anchors.bottom:     parent.bottom
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
                        font.pointSize:     16
                        Layout.fillWidth:   true
                        Layout.minimumWidth: indicatorValueWidth
                        horizontalAlignment: firstLabel.horizontalAlignment
                        anchors.bottom:     parent.bottom
                    }
                }

                // VerticalSpeed
                Row {
                    spacing:    8
                    
                    Image{
                        source:             "/skyclean/VerticalSpeed"
                        //width:              20
                        //height:             20
                        //anchors.bottom:     parent.bottom
                        layer.enabled:          true 
                        layer.effect: ColorOverlay {
                            opacity:            0.7
                            color:              qgcPal.iconColor
                        }
                    }
                    Text{
                       text:                _activeVehicle ? _activeVehicle.climbRate.rawValue.toFixed(1) + ' ' + _activeVehicle.climbRate.units : "0.0"  + " | " //getVerticalSpeed()  + " | "                      
                        color:              qgcPal.iconColor 
                        font.bold:          true 
                        font.pointSize:     16
                        Layout.fillWidth:   true
                        Layout.minimumWidth: indicatorValueWidth
                        horizontalAlignment: firstLabel.horizontalAlignment
                        anchors.bottom:     parent.bottom
                    }
                }

                //Distance
                Row {
                    spacing:    8
                    
                    Image{
                        source:             "/skyclean/Distance"
                        //width:              20
                        //height:             20
                        //anchors.bottom:     parent.bottom
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
                        font.pointSize:     16
                        Layout.fillWidth:   true
                        Layout.minimumWidth: indicatorValueWidth
                        horizontalAlignment: firstLabel.horizontalAlignment
                        anchors.bottom:     parent.bottom
                    }
                }

                //Laser Image 
                Row{
                    spacing:        10
                    Image{
                        source: "/skyclean/Radar"
                        anchors.verticalCenter: parent.verticalCenter 
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
