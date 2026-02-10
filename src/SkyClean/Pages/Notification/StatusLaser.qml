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
import QGroundControl.ScreenTools 
import QGroundControl.Vehicle       				
import SiYi.Object                  				
import QGroundControl.SkyClean                      
import Qt5Compat.GraphicalEffects                        

Item {
    id:                                             _root
    width:                                          parent.width
    height:                                         parent.height

    property var    _activeVehicle:                 QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete:         _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property int pxrType:                           (controllerLoader.item && controllerLoader.item.getParameterFact(-1, "PRX1_TYPE")) ? controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value : -1
    property int rangeType:                         (controllerLoader.item && controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE")) ? controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value : -1
    property int flowType:                          (controllerLoader.item && controllerLoader.item.getParameterFact(-1, "FLOW_TYPE")) ? controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value : -1
    property int avoid:                             (controllerLoader.item && controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE")) ? controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value : 0
    property url desligado:                         "/skyclean/IconLaserOff"
    property url ligado:                            "/skyclean/IconLaserOn"
    property bool allParametersOff:                 avoid === 1
    property color iconColor:                       qgcPal.cleanColor

    QGCPalette { id: qgcPal }

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
            topMargin:                              ScreenTools.defaultFontPixelHeight * 5.25
            left:                                   parent.left
            leftMargin:                             ScreenTools.defaultFontPixelWidth * 2.1
        }

        Image {
            id:                                     iconImage  
            anchors.centerIn:                       parent
            width:                                  ScreenTools.defaultFontPixelWidth * 4.2
            height:                                 width
            source:                                 allParametersOff ? ligado : desligado
            layer.enabled:                          true
            layer.effect: ColorOverlay { 
                color: iconColor;
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("avoid:", avoid)
            }
        }
    }

    Connections {
        target:             controllerLoader.item
        onParameterChanged: {
            iconImage.source = allParametersOff ? desligado : ligado
        }
    }
}