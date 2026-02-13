/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                      2.12
import QtQuick.Controls             2.4
import QtQuick.Dialogs              
import QtQuick.Layouts              1.12
import QtLocation                   5.3
import QtPositioning                5.3
import QtQuick.Window               2.2
import QtQml.Models                 2.1
import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0


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