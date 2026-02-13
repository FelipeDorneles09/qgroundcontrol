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
import Qt5Compat.GraphicalEffects
import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap

Button{
    id:                             root
    width:                          setWidth
    height:                         setHeight

    //Private
    property int setWidth:          0
    property int setHeight:         0
    property color clickedColor:    qgcPal.cleanColor
    property color normalColor:     "transparent"
    property url setImage:          ""

    //import Palette
    QGCPalette { id:qgcPal }

    background: Rectangle{
        color:                      root.down ? clickedColor : normalColor                
        radius:                     10
    }

    Image{
        id:                         img
        source:                     setImage
        anchors{
            centerIn:               parent
            fill:                   parent
        }
        layer.enabled: true
        layer.effect: ColorOverlay { 
            color: root.down ? (qgcPal.iconColor) : clickedColor;
        }
    }
    
}