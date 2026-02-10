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
import QGroundControl.SkyClean                      
import Qt5Compat.GraphicalEffects                     

Item{
    id:                                             _root 
    width:                                          parent.width 
    height:                                         parent.height 

    QGCPalette { id: qgcPal }

    //private list 
    property int efkParam:                          (controllerLoader.item && controllerLoader.item.getParameterFact(-1, "EK3_SRC1_POSZ")) ? controllerLoader.item.getParameterFact(-1, "EK3_SRC1_POSZ").value : -1
    property var    _activeVehicle:                 QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete:         _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property url baro:                              "/skyclean/BaroIcon"
    property url gps:                               "/qmlimages/Gps.svg"
    property color iconColor:                       qgcPal.cleanColor

    //connections param
    Loader {
        id:                                         controllerLoader
        active:                                     _initialDownloadComplete
        sourceComponent:                            factPanelControllerComponent
    }
    Component {
        id:                                         factPanelControllerComponent
        FactPanelController {
            id:                                     controller
        }
    }

    Rectangle {
    width:                                      ScreenTools.defaultFontPixelWidth * 4.9
        height:                                     width
        color:                                      qgcPal.iconColor
        radius:                                     width
        visible:                                    _activeVehicle
        anchors {
            top:                                    parent.top
            topMargin:                              ScreenTools.defaultFontPixelHeight * 8.169
            left:                                   parent.left
            leftMargin:                             ScreenTools.defaultFontPixelWidth * 2.1
        }

        Image {
            id:                                     iconImage
            anchors.horizontalCenter:               parent.horizontalCenter
            width:                                  ScreenTools.defaultFontPixelWidth * 4.2
            height:                                 ScreenTools.defaultFontPixelWidth * 3.85
            y:                                      parent.height / 2 - height / 2 - 3
            source:                                 efkParam === 1 ? baro : gps
            layer.enabled:                          true
            layer.effect: ColorOverlay { 
                color: iconColor;
            }
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("EKF value:", efkParam)
            }
        }
    }
}