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
import QGroundControl.SkyClean      1.0

Rectangle{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"
    z:                              5
    
    MouseArea {
        anchors.fill:               parent
        onClicked: {
            // Verifica se o drawer está visível (x == 0)
            if (drawer.x === 0) {
                // Se o clique foi fora da área do drawer
                if (mouse.x > drawer.width) {
                    // Esconde todas as subviews
                    settingsView.visible = false;
                    supportView.visible = false;
                    logView.visible = false;
                    tuningView.visible = false;
                    linkView.visible = false;
                    // Fecha o DrawerMenu inteiro (parent)
                    root.visible = false;
                    mouse.accepted = true;
                }
                // Se o clique foi dentro do drawer, não faz nada (permite interação com os botões)
            } else {
                // Se o drawer não está visível, qualquer clique deve esconder as subviews
                settingsView.visible = false;
                supportView.visible = false;
                logView.visible = false;
                tuningView.visible = false;
                linkView.visible = false;
                mouse.accepted = true;
            }
        }
    }

    QGCPalette { id:qgcPal }

    // call pages
    SettingsView{
        id:             settingsView
        anchors.fill:   parent 
        visible:        false
        z:              10
    }

    SupportView{
        id:             supportView
        anchors.fill:   parent 
        visible:        false
    }

    LogDownloadView{
        id:             logView
        anchors.fill:   parent 
        visible:        false
    }

    MapDownloadPage{
        id:             mapView
        anchors.fill:   parent 
        visible:        false
    }
    
    ComnLinksView{
        id:             linkView
        anchors.fill:   parent 
        visible:        false
    }

    TunningView{
        id:             tuningView
        anchors.fill:   parent 
        visible:        false
    }

    Rectangle{
    id:                         drawer 
    width:                      Math.min(ScreenTools.defaultFontPixelWidth * 9.8, 180) 
        height:                     parent.height
        color:                      qgcPal.iconColor 
        x:                          visible ? 0 : -width
        z:                          20

        Rectangle {
            width:                  ScreenTools.defaultFontPixelWidth * 0.21
            height:                 parent.height
            color:                  qgcPal.textColor
            anchors.right:          parent.right
        }

        Behavior on x{
            PropertyAnimation{
                duration:       300
                easing.type:    Easing.InOutQuad
            }
        }
        Column{
            spacing:                Math.min(ScreenTools.defaultFontPixelWidth * 1.4, 50) //origin 60 
            anchors{
                left:               parent.left 
                leftMargin:         Math.min(ScreenTools.defaultFontPixelWidth * 1.05, 15)
                top:                parent.top
                topMargin:          Math.min(ScreenTools.defaultFontPixelHeight * 0.581, 20)
            }

            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/res/gear-white"
                onClicked:         {
                    settingsView.visible = !settingsView.visible;
                    supportView.visible = false;
                    logView.visible = false;
                    tuningView.visible = false;
                    linkView.visible = false;
                }
            }

            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/skyclean/Tuning"
                onClicked:{
                    tuningView.visible = !tuningView.visible;
                    settingsView.visible = false;
                    supportView.visible = false;
                    logView.visible = false;
                    linkView.visible = false;
                }
            }

            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/skyclean/LogDownload"
                onClicked:          {
                   logView.visible = !logView.visible;
                   settingsView.visible = false;
                   supportView.visible = false;
                   tuningView.visible = false;
                   linkView.visible = false;
                }
            }

            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/skyclean/Links"
                onClicked:{
                    mainWindow.showSettingsTool(qsTr("Comm Links"));
                    tuningView.visible = false;
                    settingsView.visible = false;
                    supportView.visible = false;
                    logView.visible = false;
                }
            }

            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/skyclean/Support"
                onClicked:{
                    supportView.visible = !supportView.visible;
                    settingsView.visible = false;
                    logView.visible = false;
                    tuningView.visible = false;
                    linkView.visible = false;
                }          
            }
            ButtonIcon{
                setWidth:           Math.min(ScreenTools.defaultFontPixelWidth * 7, 140)
                setHeight:          setWidth
                setImage:           "/skyclean/Ntrip"
                onClicked:{
                    mainWindow.showSettingsTool(qsTr("NTRIP/RTK"));
                    tuningView.visible = false;
                    settingsView.visible = false;
                    supportView.visible = false;
                    logView.visible = false;
                }
            }
        }
    }  
}