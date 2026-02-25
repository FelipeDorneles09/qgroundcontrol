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


QGCComboBox{
    id:                             root 
    width:                          setWidth
    height:                         setHeight
    
    background: Rectangle{
        border.color:               qgcPal.cleanColor
        border.width:               2
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
