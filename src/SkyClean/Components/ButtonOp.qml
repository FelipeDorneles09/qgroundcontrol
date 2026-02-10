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

Button {
    id:                                             root 
    width:                                          setWidth 
    height:                                         setHeight 

    // private 
    property int setWidth:                          0
    property int setHeight:                         0
    property string setOperator:                      ""

    background: Rectangle{
        color:                                      root.down ? "#FFFFFF" : (qgcPal.cleanColor)
        radius:                                     10
    } 

    Text{
        text:                                       setOperator
        font.bold:                                  true 
        color:                                      root.down ? (qgcPal.cleanColor) :  "#FFFFFF"   
        anchors.centerIn:                           parent        
    }
}