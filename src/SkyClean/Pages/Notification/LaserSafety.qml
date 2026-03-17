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

Item{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 
    z:                                              30

    property string passSky:                        "SkyP4r4m3tr0$"

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
                width: 700
                height: 450
                color: "#000000"
                radius: 25
                opacity: 0.8
                border.color:                       "#ffffff"
                border.width:                       2
                

                Column {
                    //anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top 
                    anchors.topMargin:  60
                    spacing: 30
                    width: 500
                    height: 300

                    Text{
                            text:           qsTr("Acessar ajustes adicionais")
                            color:          "white"
                            font.bold:      true 
                            font.pointSize:  16
                        }

                    TextField {
                        id: passwordField
                        placeholderText: qsTr("Insira a senha")
                        echoMode: TextInput.Password
                        width: parent.width
                        height: 70

                        // Style properties
                        font.pointSize: 16
                        color: "#000000"
                        background: Rectangle {
                            color: "#ffffff"
                            border.color: "#000000"
                            radius: 15
                            border.width: 1
                        }

                        // Placeholder style
                        placeholderTextColor: "#000000"
                        padding: 10

                    }

                    Row {
                        spacing: 90
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter

                        ButtonAction {
                            setText: qsTr("Entrar")
                            onClicked: {
                                if (passwordField.text ===  passSky ) {                                    
                                    root.visible = false; 
                                    showLaserAdjusted();
                                } else {
                                    errorMessage.text = qsTr("Senha inválida");
                                    errorMessage.visible = true;
                                }
                            }

                            setWidth: 200
                            setHeight: 70
                        }

                        ButtonAction {
                            setText: qsTr("Cancelar")
                            onClicked: {
                                root.visible = false; 
                               
                            }
                            setWidth: 200
                            setHeight: 70
                        }
                    }

                    Text {
                        id: errorMessage
                        color: "red"
                        visible: false  
                    }
                     Timer {
                            interval: 5000; running: true; repeat: true
                            onTriggered:{
                                if(errorMessage.text){
                                    errorMessage.visible = false;
                                }  
                            }
                        }
                }
            } 
}