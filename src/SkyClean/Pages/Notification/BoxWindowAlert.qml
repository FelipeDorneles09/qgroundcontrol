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

Item{
    id:                                             root
    width:                                          parent.width 
    height:                                         parent.height 

    //private system 
    property string titleName:                      ""
    property string setDescri:                      ""
    property int setWidth:                          0
    property int setHeight:                         0
    property bool buttonVisible:                    false
    //colors palette
    QGCPalette { id:qgcPal }

    Rectangle{
        width:                                      setWidth 
        height:                                     setHeight 
        color:                                      qgcPal.iconColor
        border.color:                               qgcPal.cleanColor 
        border.width:                               2
        anchors{
            verticalCenter:                         parent.verticalCenter 
            horizontalCenter:                       parent.horizontalCenter
        }

        Column{
            anchors.fill:                           parent             
            spacing:                                30         

            Text{
                text:                               titleName
                font.bold:                          true 
                color:                              qgcPal.textColor                
                anchors{
                    horizontalCenter:               parent.horizontalCenter                    
                    topMargin:                      10
                }                
            }
            Text{
                text:                               setDescri
                font.bold:                          true 
                color:                              qgcPal.textColor
                anchors.horizontalCenter:           parent.horizontalCenter  
            }

            ButtonAction{
                visible:                            buttonVisible
                setWidth:                           180
                setHeight:                          70
                setText:                            qsTr("Ok")
                anchors.horizontalCenter:           parent.horizontalCenter 
                onClicked:                          root.visible = false;
            }
        }
        
    }
}
