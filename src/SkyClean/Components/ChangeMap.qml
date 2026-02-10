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
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"

    //private
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value

    Row{
        anchors{
            top:                    parent.top 
            topMargin:              250
            right:                  parent.right 
            rightMargin:            30
        }

        QGCComboBox {
            id: mapTypeCombo
            model: QGroundControl.mapEngineManager.mapTypeList(_mapProvider)
            Layout.preferredWidth: _comboFieldWidth
            visible:    false
            onActivated: {
                _mapType = textAt(index)
                QGroundControl.settingsManager.flightMapSettings.mapType.value = textAt(index)
            }
            Component.onCompleted: {
                var index = mapTypeCombo.find(_mapType)
                if (index < 0) index = 0
                mapTypeCombo.currentIndex = index
            }
        }

        Image {
            source: "/skyclean/MapIcon"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Incrementa o índice atual para o próximo tipo de mapa
                    var nextIndex = (mapTypeCombo.currentIndex + 1) % mapTypeCombo.count
                    mapTypeCombo.currentIndex = nextIndex

                    // Opcional: Ative manualmente o mapa selecionado
                    _mapType = mapTypeCombo.textAt(nextIndex)
                    QGroundControl.settingsManager.flightMapSettings.mapType.value = mapTypeCombo.textAt(nextIndex)
                }
            }
        }
    }
}