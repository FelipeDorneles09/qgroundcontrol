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
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       
import SiYi.Object                  

Rectangle{
    id:                             root 
    width:                          setWidth
    height:                         setHeight
    color:                          qgcPal.mainColor
    border.color:                   qgcPal.cleanColor
    border.width:                   2
    radius:                         20
    anchors{
        verticalCenter:             parent.verticalCenter 
        horizontalCenter:           parent.horizontalCenter 
    }

    //import
    QGCPalette { id:qgcPal }

    //private
    property int setWidth:          0
    property int setHeight:         0
    property string setTitle:       ""
    property string setDescription: ""

    Rectangle{
        width:                      setWidth
        height:                     50
        radius:                     0
        color:                      qgcPal.cleanColor
        Text{
            text:                   setTitle
            font.bold:              true 
            font.pointSize:         30
            anchors.centerIn:       parent 
            color:                  qgcPal.textColor
        }
        Text{
            text:                   "X"
            font.bold:              true 
            font.pointSize:         25
            color:                  qgcPal.textColor
            anchors{
                right:              parent.right 
                verticalCenter:     parent.verticalCenter 
                rightMargin:        5
            }
            MouseArea{
                anchors.fill:       parent 
                onClicked: {
                    root.visible    =   false;
                }
            }
        }
    }



}