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
import Qt5Compat.GraphicalEffects                   

Item{
    id:                                             takeOffBtn 
    width:                                          parent.width 
    height:                                         parent.height 

    WindowTakeOff { id: winTakeOff; visible: false; }
    
    //Btn Action TakeOff 
    Button{
        id:                                         btnAction
        width:                                      180
        height:                                     180
        anchors{
            right:                                  parent.right 
            rightMargin:                            30
            verticalCenter:                         parent.verticalCenter 
        }
        background: Rectangle {
            color:                                  btnAction.down ? (qgcPal.iconColor) : (qgcPal.cleanColor)
            radius:                                 40 
        }

        Image {
            id:                                     img 
            source:                                 "/skyclean/TakeOff"
            anchors{
                centerIn:                           parent
                //fill:                               parent
            }
            layer.enabled: true
            layer.effect: ColorOverlay { 
                color: btnAction.down ? (qgcPal.cleanColor) : (qgcPal.iconColor);
            }
        }

        onClicked: { 
            /* if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                mainWindow.showMessageDialog(qsTr("Decolagem"), qsTr("Você precisa estar conectado ao drone."))
            } else {
                winTakeOff.visible = !winTakeOff.visible;
            } */
            winTakeOff.visible = !winTakeOff.visible;
        }
    }
    
}