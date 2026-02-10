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
import QtMultimedia
Item {
    id:                                     alertFailSafe
    width:                                  parent.width
    height:                                 parent.height

    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property bool _isMessageImportant:      _activeVehicle ? !_activeVehicle.messageTypeNormal && !_activeVehicle.messageTypeNone : false
    property bool _hasObstacle:             false

        MediaPlayer {
            id:                             myAudio
            source:                         "/res/audio/alert_white"
            audioOutput: AudioOutput { id: myAudioOutput; volume: 1.0 }
            loops:                          MediaPlayer.Infinite
        }

   Connections {
        target: _activeVehicle
        onNewFormattedMessage: function(formattedMessage) {
            let flfCode = null;

            if (formattedMessage.includes("<FLF:7>")) {
                flfCode = "FLF:7";
            } else if (formattedMessage.includes("<FLF:0>")) {
                flfCode = "FLF:0";
            }

            switch (flfCode) {
                case "FLF:7":
                    _hasObstacle = true;
                    myAudio.play();
                    console.log("FLF:7 activated, showing specific alert.");
                    break;
                case "FLF:0":
                    _hasObstacle = false;
                    myAudio.stop();
                    console.log("FLF:0 activated, hiding alert.");
                    break;
                default:
                    // No action needed
                    break;
            }
        }
    }

    Rectangle {
        width:                              parent.width
        height:                             parent.height
        visible:                            _hasObstacle
        color:                              "transparent"

        Image{
            id:                             blinkingImage
            source:                         "/skyclean/ObstacleAlert"
            fillMode:                       Image.PreserveAspectFit
            width:                          parent.width
            height:                         parent.height

            Timer {
                interval: 500
                running: true
                repeat: true 
                onTriggered: {
                    blinkingImage.visible = !blinkingImage.visible
                }
            }
        }

    Rectangle{
            width:                          700
            height:                         250
            color:                          "transparent"
            border.color:                   "#000000"
            border.width:                   4
            radius:                         50
            anchors{
                horizontalCenter:           parent.horizontalCenter 
                top:                        parent.top 
                topMargin:                  15
            }

            Rectangle{
                width:                      700
                height:                     250
                color:                      "#ffffff"
                opacity:                    0.6 
                radius:                     50
            }

            Column{
                //spacing:                    20
                Row{  
                    spacing:                38              
                    Image{
                        source:             "/skyclean/Alert"
                    }
                    Text{
                        text:               qsTr("OBSTÁCULO DETECTADO!")
                        font.pointSize:     16
                        font.bold:          true 
                        anchors{
                            top:            parent.top 
                            topMargin:      40
                        }
                    }
                    Image{
                        source:             "/skyclean/Alert"
                    }
                }

                /* Text{
                    text:                   qsTr("Pousando o drone")
                    font.bold:              true                     
                    anchors.horizontalCenter:parent.horizontalCenter                    
                } */

            }
        }
    }
}
