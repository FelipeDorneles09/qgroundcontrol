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
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import QGroundControl

import QGroundControl.Controls

import QGroundControl.FlightDisplay
import QGroundControl.FlightMap




// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl
    property bool _hasFLFMessage9: false

    // since this file is a placeholder for the custom layer in a standard build, we will just pass through the parent insets
    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeTopInset:       parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset:    parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset:   parentToolInsets.bottomEdgeRightInset
    }

    QGCPalette { id: qgcPal }

    Connections {
        target: QGroundControl.multiVehicleManager.activeVehicle
        onNewFormattedMessage: {
            let flfCode = null;

            if (formattedMessage.includes("<FLF:9>")) {
                flfCode = "FLF:9";
            } else if (formattedMessage.includes("<FLF:0>")) {
                flfCode = "FLF:0";
            }

            switch (flfCode) {
                case "FLF:9":
                    _hasFLFMessage9 = true;
                    console.log("FLF:9 activated, showing overlay.");
                    QGroundControl.mainWindow.showMessageDialog(qsTr("Modo Parede"), qsTr("Modo Parede ativado."));
                    break;
                case "FLF:0":
                    _hasFLFMessage9 = false;
                    console.log("FLF:0 activated, hiding overlay.");
                    QGroundControl.mainWindow.showMessageDialog(qsTr("Modo Parede"), qsTr("Modo Parede desativado."));
                    break;
                default:
                    break;
            }
        }
    }

    Rectangle {
        id: guidedModeRect
        width: ScreenTools.defaultFontPixelHeight * 5
        height: width
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: ScreenTools.defaultFontPixelWidth * 2
        anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
        color: qgcPal.iconColor
        radius: width / 2
        z: QGroundControl.zOrderTopMost
        visible: _hasFLFMessage9
        border.color: qgcPal.cleanColor
        border.width: 2

        Image {
            anchors.centerIn: parent
            source: "/res/wall.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height
        }
    }
}
