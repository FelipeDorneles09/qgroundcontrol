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
import QGroundControl.SkyClean      

Rectangle{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"
    z:                              5
    MouseArea{
        onClicked: {
            settingsView.visible = false;
            supportView.visible = false;
            logView.visible = false;
            tuningView.visible = false;
            linkView.visible = false;
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
                    mainWindow.showSettingsTool();
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
        }
    }  
}