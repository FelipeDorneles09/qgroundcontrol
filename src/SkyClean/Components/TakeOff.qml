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