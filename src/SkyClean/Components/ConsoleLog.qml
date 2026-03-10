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
import Qt5Compat.GraphicalEffects   

Rectangle{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"

    //private

    property bool                   hasUnreadErrorMessages: false

    QGCPalette{ id:qgcPal }

    Rectangle{
    width:                      ScreenTools.defaultFontPixelWidth * 7
        height:                     width
        radius:                     width
        color:                      qgcPal.iconColor
        border.color:               qgcPal.cleanColor
        border.width:               2
        anchors{
            left:                   parent.left 
            leftMargin:             ScreenTools.defaultFontPixelWidth * 1.4
            top:                    parent.top 
            topMargin:              ScreenTools.defaultFontPixelHeight * 1.47
        }

            Image{
            source:                 "/qmlimages/Megaphone.svg"
            width:                  ScreenTools.defaultFontPixelWidth * 3.5
            height:                 width
            layer.enabled:          true 
            anchors.centerIn:       parent
            layer.effect: ColorOverlay{
                color:              hasUnreadErrorMessages ? qgcPal.warningText : qgcPal.cleanColor
            }
        }
        MouseArea {
            anchors.fill:   parent
            onClicked: {
                hasUnreadErrorMessages = false
                mainWindow.showIndicatorPopup(_root, vehicleMessagesPopup)
            }
        }

        Connections {
            target:                 _activeVehicle
            onNewFormattedMessage: {
                if (formattedMessage.indexOf("<#E>") !== -1 || formattedMessage.indexOf("<#I>") !== -1) {
                    hasUnreadErrorMessages = true
                }
            }
        }

        Component {
            id: vehicleMessagesPopup

            Rectangle {
                width:          mainWindow.width  * 0.666
                height:         mainWindow.height * 0.666
                radius:         ScreenTools.defaultFontPixelHeight / 2
                color:          qgcPal.window
                border.color:   qgcPal.cleanColor
                x:              (mainWindow.width - width) * 1.5
                y:              (mainWindow.height - height) / 2

                function formatMessage(message) {
                    message = message.replace(new RegExp("<#E>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#I>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#N>", "g"), "color: " + qgcPal.text + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    return message;
                }

                Component.onCompleted: {
                    messageText.text = formatMessage(_activeVehicle.formattedMessages)
                    //-- Hack to scroll to last message
                    for (var i = 0; i < _activeVehicle.messageCount; i++)
                        messageFlick.flick(0,-5000)
                    _activeVehicle.resetMessages()
                }

                Connections {
                    target: _activeVehicle
                    onNewFormattedMessage :{
                        messageText.append(formatMessage(formattedMessage))
                        //-- Hack to scroll down
                        messageFlick.flick(0,-500)
                    }
                }

                QGCLabel {
                    anchors.centerIn:   parent
                    text:               qsTr("No Messages")
                    visible:            messageText.length === 0
                }

                //-- Clear Messages
                /* QGCColoredImage {
                    anchors.bottom:     parent.bottom
                    anchors.right:      parent.right
                    anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
                    height:             ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight
                    width:              height
                    sourceSize.height:   height
                    source:             "/res/TrashDelete.svg"
                    fillMode:           Image.PreserveAspectFit
                    mipmap:             true
                    smooth:             true
                    color:              qgcPal.text
                    visible:            messageText.length !== 0
                    MouseArea {
                        anchors.fill:   parent
                        onClicked: {
                            if (_activeVehicle) {
                                _activeVehicle.clearMessages()
                                mainWindow.hideIndicatorPopup()
                            }
                        }
                    }
                } */

                QGCFlickable {
                    id:                 messageFlick
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    anchors.fill:       parent
                    contentHeight:      messageText.height
                    //contentWidth:       messageText.width
                    pixelAligned:       true

                    TextEdit {
                        id:             messageText
                        readOnly:       true
                        textFormat:     TextEdit.RichText
                        color:          qgcPal.text
                    }
                }
            }
        }
    }
}
