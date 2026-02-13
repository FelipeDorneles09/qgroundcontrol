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