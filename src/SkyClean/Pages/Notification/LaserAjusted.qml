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

Item{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 
    z:                                              30
    
    //private 
    property var    _activeVehicle:                 QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete:         _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property bool pxrType:                          controllerLoader.item.getParameterFact(-1, "PRX1_TYPE")
    property bool rangeType:                        controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE")
    property bool flowType:                         controllerLoader.item.getParameterFact(-1, "FLOW_TYPE")

    Loader {
        id: controllerLoader
        active: _initialDownloadComplete
        sourceComponent: factPanelControllerComponent
    }

    Component {
        id: factPanelControllerComponent
        FactPanelController {
            id:         controller;
        }
    }

    BoxWindowAlert{ 
        id:             laserAlert
        visible:        false
    setWidth:       ScreenTools.defaultFontPixelWidth * 84
    setHeight:      ScreenTools.defaultFontPixelHeight * 8.75
        buttonVisible:  true
        titleName:      qsTr("LASER")
        setDescri:      qsTr("É preciso reiniciar o drone para a aplicação funcionar")
        z:              30
    }

    QGCPalette { id:qgcPal }

    Rectangle{
        width:                                          parent.width 
        height:                                         parent.height 
        color:                                          "#000000"
        opacity:                                        0.75

        MouseArea {
            anchors.fill: parent
            enabled: true
            onClicked: {
            }
        }
    }

     Rectangle {
        anchors.centerIn: parent
    width: ScreenTools.defaultFontPixelWidth * 28
    height: ScreenTools.defaultFontPixelHeight * 16.044
        color: "#000000"
    radius: ScreenTools.defaultFontPixelWidth * 1.75
        opacity: 0.8
        border.color:                       "#ffffff"
    border.width:                       ScreenTools.defaultFontPixelHeight * 0.0581

        Text{
            text:           qsTr("x")
            color:          "white"
            font.bold:      true 
            font.pointSize:  25
            anchors{
                right:      parent.right 
                rightMargin: ScreenTools.defaultFontPixelWidth * 1.05
                top:        parent.top 
                topMargin:  ScreenTools.defaultFontPixelHeight * 0.147
            }
            MouseArea{
                anchors.fill: parent 
                onClicked: {
                    root.visible = false
                }
            }
        }
        
        Column {            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top 
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight * 2.625
            spacing: ScreenTools.defaultFontPixelHeight * 0.875
            width: ScreenTools.defaultFontPixelWidth * 24.5
            height: ScreenTools.defaultFontPixelHeight * 20.419

            Text{
                text:           qsTr("Laser")
                color:          "white"
                font.bold:      true 
                font.pointSize:  16
            }

            SwitchSquad {                            

                setWidth:                   ScreenTools.defaultFontPixelWidth * 21
                setHeight:                  ScreenTools.defaultFontPixelHeight * 2.919
                falseImg:                   "/skyclean/LaserOff"
                trueImg:                    "/skyclean/LaserOn"
                falseTxt:                   qsTr("Desligado")
                trueTxt:                    qsTr("Ligado")
                isChecked:                  pxrType

                Connections {
                    target: controllerLoader.item.getParameterFact(-1, "PRX1_TYPE")

                    onValueChanged: {
                        pxrType = value === 4
                        isChecked = pxrType
                    }
                }

                onClicked: {
                    if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                        //laserAlert.visible = true;
                    } else {
                        pxrType = isChecked

                        // Atualizar PRX1_TYPE
                        controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value = pxrType ? 4 : 0
                        console.log("Valor a ser enviado para PRX1_TYPE: ", controllerLoader.item.getParameterFact(-1, "PRX1_TYPE").value)

                        // Atualizar RNGFND1_TYPE com base no pxrType
                        controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value = pxrType ? 8 : 0
                        console.log("Valor a ser enviado para RNGFND1_TYPE: ", controllerLoader.item.getParameterFact(-1, "RNGFND1_TYPE").value)

                        // Atualizar AVOID com base no pxrType
                        controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value = pxrType ? 3 : 1
                        console.log("Valor a ser enviado para AVOID_ENABLE: ", controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value)
                    }    
                    laserAlert.visible = true;        
                }
            }

            Text{
                text:           qsTr("Flow")
                color:          "white"
                font.bold:      true 
                font.pointSize:  16
            }

            SwitchSquad {                            

                setWidth:                   ScreenTools.defaultFontPixelWidth * 21
                setHeight:                  ScreenTools.defaultFontPixelHeight * 2.919
                falseImg:                   "/skyclean/LaserOff"
                trueImg:                    "/skyclean/LaserOn"
                falseTxt:                   qsTr("Desligado")
                trueTxt:                    qsTr("Ligado")
                isChecked:                  flowType

                Connections {
                    target: controllerLoader.item.getParameterFact(-1, "FLOW_TYPE")

                    onValueChanged: {
                        flowType = value === 6
                        isChecked = flowType
                    }
                }

                onClicked: {
                    if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                        mainWindow.showMessageDialog(qsTr("Definir Laser"), qsTr("Você precisa estar conectado ao drone."))
                    } else {
                        flowType = isChecked
                        controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value = flowType ? 6 : 0
                        console.log("Valor a ser enviado para FLOW_TYPE: ", controllerLoader.item.getParameterFact(-1, "FLOW_TYPE").value)
                    }            
                }
            }
            
        }
    } 
}