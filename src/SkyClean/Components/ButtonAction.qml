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

Button{
    id:                             root 
    width:                          setWidth
    height:                         setHeight 

    //private
    property int setWidth:          0
    property int setHeight:         0
    property color normalColor:     qgcPal.cleanColor
    property color clickedColor:    "#FFFFFF"
    property string setText:        ""

    background: Rectangle{
        color:                      root.down ? clickedColor : normalColor;
        radius:                     10
        border.color:               qgcPal.cleanColor 
        border.width:               5
    }

    Text{
        text:                       setText
        font.bold:                  true 
        color:                      root.down ? normalColor : "#1C1C28"   
        anchors.centerIn:           parent        
    }
}