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
import QtQuick.Controls.Styles      


QGCComboBox{
    id:                             root 
    width:                          setWidth
    height:                         setHeight
    
    background: Rectangle{
        border.color:               qgcPal.cleanColor
        border.width:               4
        radius:                     10
        color:                      qgcPal.iconColor
    }

    QGCPalette { id:qgcPal }
    
    //private
    property int setWidth:          0
    property int setHeight:         0
    property Fact fact:             Fact { }
    property bool indexModel: true  ///< true: model must be specifed, selected index is fact value, false: use enum meta data

    model: fact ? fact.enumStrings : null

    currentIndex: fact ? (indexModel ? fact.value : fact.enumIndex) : 0

    onActivated: {
        if (indexModel) {
            fact.value = index
        } else {
            fact.value = fact.enumValues[index]
        }
    }
}
