/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author Gus Grubba <gus@auterion.com>
 */

import QtQuick          
import QtQuick.Controls 
import QtQuick.Layouts  

import QGroundControl                       
import QGroundControl.Controls                         

//-------------------------------------------------------------------------
//-- ROI Indicator
Item {
    id:                     _root
    width:                  showIndicator ? roiIcon.width : 0
    visible:                showIndicator
    anchors.top:            parent.top
    anchors.bottom:         parent.bottom

    property bool showIndicator: true //_activeVehicle && _activeVehicle.roiModeSupported

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function colorThemaSky() {
        if (qgcPal.globalTheme === QGCPalette.Light) {
            return "/skyclean/SkyDrones";
        } else if (qgcPal.globalTheme === QGCPalette.Dark) {
            return "/skyclean/SkyDronesWhite";
        }
    }

    Component {
        id: roiInfo

        Rectangle {
            width:                  roiCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height:                 roiCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius:                 ScreenTools.defaultFontPixelHeight * 0.5
            color:                  qgcPal.window
            border.color:           qgcPal.text

            Column {
                id:                 roiCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(roiButton.width, roiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                /* QGCLabel {
                    id:             roiLabel
                    text:           qsTr("ROI Disabled")
                    font.family:    ScreenTools.demiboldFontFamily
                    visible:        !roiButton.visible
                    anchors.horizontalCenter: parent.horizontalCenter
                } */

                QGCLabel {
                    id:             roiButton
                    visible:        _activeVehicle && _activeVehicle.isROIEnabled
                    text:           qsTr("Visite nosso site www.skydrones.com.br")
                }
            }
        }
    }
    /*
    Image {
        id:                 roiIcon
        anchors {
            top: parent.top
            bottom: parent.bottom
            rightMargin:    5
        }
        //sourceSize.height:  height 
        source:             colorThemaSky() //"/qmlimages/roi.svg"
        fillMode:           Image.PreserveAspectFit
    }
    */

    /* MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, roiInfo)
        }
    } */
}

