/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                      				2.12
import QtQuick.Controls             				2.4
import QtQuick.Dialogs              				
import QtQuick.Layouts              				1.12
import QtLocation                   				5.3
import QtPositioning                				5.3
import QtQuick.Window               				2.2
import QtQml.Models                 				2.1
import QGroundControl               				1.0
import QGroundControl.Controls      				1.0
import QGroundControl.FactControls   				1.0
import QGroundControl.FlightDisplay 				1.0
import QGroundControl.FlightMap     				1.0




Item{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 

    //private
    property string checkVersion:                   "1.0.0"
    property string currentVersion:                 ""
    
    QGCPalette { id:qcgPal }

    Component.onCompleted: {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://skydrones.com.br/Update/VersionSkyClean.json", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var response = JSON.parse(xhr.responseText);
                root.currentVersion = response.version;  // Define a versão atual a partir do JSON

                if (root.currentVersion !== root.checkVersion) {
                    updateRectangle.visible = true;  // Torna o Rectangle visível se as versões forem diferentes
                }
            }
        };
        xhr.send();
    }

    Rectangle{
        id:                                         updateRectangle
        width:                                      800
        height:                                     500
        color:                                      qgcPal.iconColor
        border.color:                               qgcPal.cleanColor
        border.width:                               3
        radius:                                     10
        visible:                                    false
        anchors{
            centerIn:                               parent
        }
        Rectangle{
            width:                                  800
            height:                                 125
            color:                                 qgcPal.cleanColor
            
            Text{
                text:                               qsTr("Atualização Disponivel")
                font.bold:                          true 
                color:                              qgcPal.textColor
                anchors{
                    centerIn:                       parent
                }
            }

            Text{
                text:                               "x"
                font.bold:                          true 
                color:                              qgcPal.textColor
                anchors{
                    right:                          parent.right 
                    rightMargin:                    20
                    verticalCenter:                 parent.verticalCenter
                }
                MouseArea{                    
                    anchors.fill:                   parent
                    onClicked: {
                        updateRectangle.visible =   false 
                    }
                }
            }
            
        }

        Column{
            spacing:                                30
            anchors{
                top:                                parent.top 
                topMargin:                          205
                verticalCenter:                     parent.verticalCenter
                horizontalCenter:                   parent.horizontalCenter 
            }

            Text{
                text:                               qsTr("NOVA VERSÃO") + " : " + root.currentVersion
                color:                              qgcPal.textColor 
                font.bold:                          true
            }

            Text{
                text:                               qsTr("Existe uma nova versão") + " \n" +  qsTr("disponivel para seu dispositivo")
                color:                              qgcPal.textColor
                font.pointSize:                     10
            }

            Text{
                text:                               qsTr("Acesse o software SkyDrones Desktop") + " \n" + qsTr("e baixe a versão mais recente.")
                color:                              qgcPal.textColor
                font.pointSize:                     10
            }


        }
    }
}
