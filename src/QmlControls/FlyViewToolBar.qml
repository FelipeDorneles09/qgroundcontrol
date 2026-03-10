/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import QGroundControl
import QGroundControl.Controls
import QGroundControl.SkyClean
import SiYi.Object 1.0

Rectangle {
    id:     control
    width:  parent.width
    height: ScreenTools.toolbarHeight
    color:  qgcPal.windowTransparent

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple
    property real   _leftRightMargin:   ScreenTools.defaultFontPixelWidth * 0.75

    function dropMainStatusIndicatorTool() {
        mainStatusIndicator.dropMainStatusIndicator();
    }

    function colorToolBar(){
        var redcolor = "red"
        var oricolor = "#6acce0"

        if(_activeVehicle){
            if(_communicationLost){
                return redcolor;
            }
           if (_activeVehicle.readyToFlyAvailable) {
                if (_activeVehicle.readyToFly) {
                    
                    return oricolor
                } else {
                    
                    return redcolor
                }
            }
        } else {
            return oricolor; 
        }
    }

    QGCPalette { id: qgcPal }

    /// Bottom single pixel divider
    Rectangle {
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        height:         1
        color:          qgcPal.toolbarDivider
    }

    Rectangle {
        id:             gradientBackground
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        width:          mainStatusLayout.width

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0;                                     color: colorToolBar()}
            GradientStop { position: currentButton.x + currentButton.width; color: colorToolBar()}
            GradientStop { position: 1;                                     color: control.color }
        }
    }

    Rectangle {
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        anchors.left:   gradientBackground.right
        anchors.right:  parent.right
        color:          qgcPal.windowTransparent
    }

    RowLayout {
        id:                     mainLayout
        anchors.bottomMargin:   1
        anchors.rightMargin:    control._leftRightMargin
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left:           parent.left
        anchors.right:          parent.right
        spacing:                ScreenTools.defaultFontPixelWidth

        RowLayout {
            id:                 leftStatusLayout
            Layout.fillHeight:  true
            Layout.alignment:   Qt.AlignLeft
            spacing:            ScreenTools.defaultFontPixelWidth * 2

            RowLayout {
                id:                 mainStatusLayout
                Layout.fillHeight:  true
                spacing:            0
                Layout.fillWidth: true

                QGCToolBarButton {
                    id:                 qgcButton
                    Layout.fillHeight:  true
                    icon.source:        "/skyclean/SkyClean"
                    logo:               true
                    onClicked:          mainWindow.showDrawerMenu()
                }

                MainStatusIndicator {
                    id:                 mainStatusIndicator
                    Layout.preferredHeight: viewButtonRow.height
                }
            }

            ButtonAction {
                id:         disconnectButton
                text:       qsTr("Disconnect")
                onClicked:  _activeVehicle.closeVehicle()
                visible:    _activeVehicle && _communicationLost
            }

        property real indicatorsLeftLocalX: indicatorLoader.x - (mainStatusIndicator ? mainStatusIndicator.x : 0)
        onIndicatorsLeftLocalXChanged: if (mainStatusIndicator) mainStatusIndicator.rightIndicatorsX = indicatorsLeftLocalX
        Component.onCompleted: if (mainStatusIndicator) mainStatusIndicator.rightIndicatorsX = indicatorsLeftLocalX
            
        }

        FlightModeMenu {
            id:                     flightModeMenu
            Layout.preferredHeight: control.height
            verticalAlignment:      Text.AlignVCenter
            font.pointSize:         _vehicleInAir ?  ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
            mouseAreaLeftMargin:    -(flightModeMenu.x - (flightModeIcon.x * 0.5))
            visible:                _activeVehicle && !_communicationLost
        }

        QGCFlickable {
            id:                     indicatorsFlickable
            Layout.alignment:       Qt.AlignRight
            Layout.fillHeight:      true
            Layout.preferredWidth:  Math.min(contentWidth, availableWidth)
            contentWidth:           toolIndicators.width
            flickableDirection:     Flickable.HorizontalFlick

            property real availableWidth: mainLayout.width - leftStatusLayout.width

            FlyViewToolBarIndicators { id: toolIndicators }
        }
    }

    ParameterDownloadProgress {
        anchors.fill: parent
    }
}
