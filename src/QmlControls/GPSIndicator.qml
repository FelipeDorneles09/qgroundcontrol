/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          
import QtQuick.Layouts  

import QGroundControl                       1.0
import QGroundControl.Controls              1.0

//-------------------------------------------------------------------------
//-- GPS Indicator
Item {
    id:             _root
    width:          (gpsValuesColumn.x + gpsValuesColumn.width) * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    //CREATE SKYDRONES
    function getSignalGPS() {
        if (_activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)) {
            if (_activeVehicle.gps.hdop.value < 1.0) {
                return 100;
            } else if (_activeVehicle.gps.hdop.value < 1.1) {
                return 75;
            } else if (_activeVehicle.gps.hdop.value < 1.2) {
                return 50;
            } else {
                return 25;
            }
        } else {
            return 0;
        }
    }


    Component {
        id: gpsInfo

        Rectangle {
            width:  gpsCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: gpsCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 gpsCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(gpsGrid.width, gpsLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             gpsLabel
                    text:           (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? qsTr("Status do GPS") : qsTr("Dados GPS indisponíveis")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 gpsGrid
                    visible:            (_activeVehicle && _activeVehicle.gps.count.value >= 0)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCLabel { text: qsTr("Satélites GPS:") }
                    QGCLabel { text: _activeVehicle ? _activeVehicle.gps.count.valueString : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("Tranca GPS:") }
                    QGCLabel { text: _activeVehicle ? _activeVehicle.gps.lock.enumStringValue : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("HDOP:") }
                    QGCLabel { text: _activeVehicle ? _activeVehicle.gps.hdop.valueString : qsTr("--.--", "No data to display") }
                    QGCLabel { text: qsTr("VDOP:") }
                    QGCLabel { text: _activeVehicle ? _activeVehicle.gps.vdop.valueString : qsTr("--.--", "No data to display") }
                    /* QGCLabel { text: qsTr("Curso sobre o solo:") }
                    QGCLabel { text: _activeVehicle ? _activeVehicle.gps.courseOverGround.valueString : qsTr("--.--", "No data to display") } */
                }
            }
        }
    }

    Row {
        id:                     gpsValuesColumn
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth * 0.25

        QGCColoredImage {
            id:                 gpsIcon
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             "/qmlimages/Gps.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            opacity:            (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? 1 : 0.5
            color:              qgcPal.buttonText
        }

        QGCLabel {
            //anchors.horizontalCenter:   hdopValue.horizontalCenter
            visible:                    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
            color:                      qgcPal.buttonText
            text:                       _activeVehicle ? _activeVehicle.gps.count.valueString : ""
        }

        /* QGCLabel {
            id:         hdopValue
            visible:    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
            color:      qgcPal.buttonText
            text:       _activeVehicle ? _activeVehicle.gps.hdop.value.toFixed(1) : ""
        } */
        SignalStrength {
            percent:    getSignalGPS()
            anchors.verticalCenter: parent.verticalCenter
            size:                   parent.height * 0.7
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, gpsInfo)
        }
    }
}
