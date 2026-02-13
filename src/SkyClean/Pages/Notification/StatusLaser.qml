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
import QGroundControl.SkyClean                      1.0
import Qt5Compat.GraphicalEffects                   

Item {
    id:                                             _root
    width:                                          parent.width
    height:                                         parent.height

    property var    _activeVehicle:                 QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete:         _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property int pxrType:                           controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value
    property int rangeType:                         controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value
    property int flowType:                          controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value
    property int avoid:                             controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value
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