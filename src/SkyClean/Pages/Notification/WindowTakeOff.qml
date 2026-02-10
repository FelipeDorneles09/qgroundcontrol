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