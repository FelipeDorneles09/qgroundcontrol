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
import QGroundControl.FactControls    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
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