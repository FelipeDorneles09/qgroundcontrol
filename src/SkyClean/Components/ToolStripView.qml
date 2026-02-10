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

Button{
    id:                             root 
    width:                          setWidth
    height:                         setHeight 

    //private 
    property int setWidth:          0
    property int setHeight:         0
    property url setImage:          ""

    //import Palette
    QGCPalette { id:qgcPal } 

    background: Rectangle{
        color:                      root.down  ? (qgcPal.mainColor) : (qgcPal.iconColor);
        radius:                     15
    }

    Image{
        id:                         img 
        source:                     setImage
        anchors.centerIn:           parent
        layer.enabled:              true 
        layer.effect:   ColorOverlay{
            color:                  root.down  ? (qgcPal.iconColor) : (qgcPal.mainColor);
        }
    }
}