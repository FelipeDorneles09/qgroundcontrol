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
