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
        border.color:              hasUnreadErrorMessages ? qgcPal.warningText : qgcPal.cleanColor
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

            Item {
                width:  mainWindow.width
                height: mainWindow.height

                MouseArea {
                    anchors.fill: parent
                    onClicked: mainWindow.hideIndicatorPopup()
                    z: 0
                }

                Rectangle {
                    width:          mainWindow.width  * 0.7
                    height:         mainWindow.height * 0.7
                    radius:         ScreenTools.defaultFontPixelHeight / 2
                    color:          qgcPal.window
                    border.color:   qgcPal.cleanColor
                    x:              (mainWindow.width - width) * 2.1
                    y:              (mainWindow.height - height) / 2
                    z:              1

                function formatMessage(message) {
                    message = message.replace(new RegExp("<#E>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#I>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#N>", "g"), "color: " + qgcPal.text + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    return message;
                }

                function _reorderMessagesOldestFirst(html) {
                    if (!html) return "";
                    var parts = html.split("</font><br/>");
                    var filtered = [];
                    for (var i = 0; i < parts.length; i++) {
                        var p = parts[i].trim();
                        if (p.length > 0) {
                            filtered.push(p + "</font><br/>");
                        }
                    }
                    filtered.reverse();
                    return filtered.join("");
                }

                // unified HTML buffer so we always set the TextEdit's text
                property string messageHtml: ""

                //-- Auto-close the popup after 5 seconds
                Timer {
                    id:             autoCloseTimer
                    interval:       5000
                    repeat:         false
                    running:        true
                    onTriggered:    mainWindow.hideIndicatorPopup()
                }

                //-- Timer para scroll automático ao final
                Timer {
                    id:             scrollToBottomTimer
                    interval:       100
                    repeat:         false
                    onTriggered: {
                        messageFlick.contentY = Math.max(0, messageFlick.contentHeight - messageFlick.height)
                    }
                }

                Component.onCompleted: {
                    var raw = _activeVehicle.formattedMessages
                    var ordered = _reorderMessagesOldestFirst(raw)
                    messageHtml = ordered
                    messageText.text = formatMessage(messageHtml)
                    //-- Scroll para a última mensagem
                    scrollToBottomTimer.start()
                    _activeVehicle.resetMessages()
                }

                Connections {
                    target: _activeVehicle
                    onNewFormattedMessage :{
                        // append to our unified HTML buffer and re-render the full HTML
                        messageHtml += formattedMessage
                        messageText.text = formatMessage(messageHtml)
                        //-- Scroll para a última mensagem
                        scrollToBottomTimer.restart()
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
                    source:             "/InstrumentValueIcons/trash.svg"
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
}
