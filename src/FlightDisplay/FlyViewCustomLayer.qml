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
import QGroundControl.Airspace      
import QGroundControl.Airmap        
import QGroundControl.Controllers   
import QGroundControl.Controls      
import QGroundControl.FactSystem    
import QGroundControl.FlightDisplay 
import QGroundControl.FlightMap     
import QGroundControl.Palette       
import QGroundControl.ScreenTools   
import QGroundControl.Vehicle       

// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl
    property bool _hasFLFMessage9: false

    QGCToolInsets {
        id:                         _toolInsets
        leftEdgeCenterInset:    0
        leftEdgeTopInset:           0
        leftEdgeBottomInset:        0
        rightEdgeCenterInset:   0
        rightEdgeTopInset:          0
        rightEdgeBottomInset:       0
        topEdgeCenterInset:       0
        topEdgeLeftInset:           0
        topEdgeRightInset:          0
        bottomEdgeCenterInset:    0
        bottomEdgeLeftInset:        0
        bottomEdgeRightInset:       0
    }

    QGCPalette { id: qgcPal }

    Connections {
        target: QGroundControl.multiVehicleManager.activeVehicle
        onNewFormattedMessage: function(formattedMessage) {
            let flfCode = null;

            if (formattedMessage.includes("<FLF:9>")) {
                flfCode = "FLF:9";
            } else if (formattedMessage.includes("<FLF:0>")) {
                flfCode = "FLF:0";
            }

            switch (flfCode) {
                case "FLF:9":
                    _hasFLFMessage9 = true;
                    break;
                case "FLF:0":
                    _hasFLFMessage9 = false;
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
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
        color: qgcPal.iconColor
        radius: width / 2
        z: QGroundControl.zOrderTopMost
        visible: _hasFLFMessage9
        border.color: '#ec4141'
        border.width: 2

        Image {
            anchors.centerIn: parent
            source: "/qmlimages/wall.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: parent.height
        }
    }
}
