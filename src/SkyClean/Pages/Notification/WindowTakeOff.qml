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

Item{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 

    QGCPalette { id:qgcPal }

    //DrawerTakeOff { id: winTakeOff; visible: false }


    Item{
        id:                                         _root
        width:                                      parent.width 
        height:                                     parent.height
        Rectangle{
            id:                                         window 
            width:                                      1200
            height:                                     350 
            color:                                      qgcPal.iconColor
            border.width:                               1.2
            border.color:                               qgcPal.cleanColor
            anchors{
                horizontalCenter:                       parent.horizontalCenter 
                verticalCenter:                         parent.verticalCenter 
            }

            Column{
                spacing:                                10
                anchors.centerIn:                       parent
                Text{
                    text:                               qsTr("Você irá começar a automação do seu SkyClean")
                    color:                              qgcPal.textColor 
                    font.bold:                          true 
                    //font.pointSize:                     20
                    
                }

                Text{
                    text:                               qsTr("Limite de distância dos pontos é de 10 metros")
                    color:                              qgcPal.textColor 
                    font.bold:                          true 
                    //font.pointSize:                     20
                }

                Row{
                    spacing:                            400
                    
                    // Continuar Missão 
                    Rectangle{
                        width:                          350
                        height:                         100
                        color:                          "green"
                        radius:                         10

                        Text{
                            text:                       qsTr("Continuar")
                            color:                      "#FFFFFF"   
                            font.bold:                  true 
                            anchors.centerIn:           parent 
                        }   

                        MouseArea{
                            anchors.fill:               parent 
                            onClicked: {
                                showTakeOff();
                                root.visible = false;
                            }
                        }            
                    }
                    // Cancelar
                    Rectangle{
                        width:                          350
                        height:                         100
                        color:                          "red"
                        radius:                         10

                        Text{
                            text:                       qsTr("Cancelar")
                            color:                      "#FFFFFF"   
                            font.bold:                  true 
                            anchors.centerIn:           parent 
                        }   

                        MouseArea{
                            anchors.fill:               parent 
                            onClicked: {
                                root.visible = false;
                            }
                        }            
                    }
                }
            }
        }
    }
}