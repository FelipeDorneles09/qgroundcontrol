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

import QGroundControl                       
import QGroundControl.Controls                          
import QGroundControl.SkyClean              
import Qt5Compat.GraphicalEffects           

//-------------------------------------------------------------------------
//-- Battery Indicator
Item {
    id:             _root
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          batteryIndicatorRow.width + skyDronesImage.width + ScreenTools.defaultFontPixelWidth

    property bool showIndicator: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function colorThemaSky() {
        if (qgcPal.globalTheme === QGCPalette.Light) {
            return "/skyclean/SkyDrones";
        } else if (qgcPal.globalTheme === QGCPalette.Dark) {
            return "/skyclean/SkyDronesWhite";
        }
    }

    Row {
        id:             batteryIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        Repeater {
            model: _activeVehicle ? _activeVehicle.batteries : 0

            Loader {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                sourceComponent:    batteryVisual

                property var battery: object
            }
        }
    }

    Image {
        id:                 skyDronesImage
        anchors {
            left:           batteryIndicatorRow.right
            top:            parent.top
            bottom:         parent.bottom
            bottomMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            leftMargin:     ScreenTools.defaultFontPixelWidth * 2
        }
        source:             colorThemaSky()
        fillMode:           Image.PreserveAspectFit
    }
    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, batteryPopup)
        }
    }

    Component {
        id: batteryVisual

        Row {
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            spacing:        0 //ScreenTools.defaultFontPixelWidth * 0.25
            /* function getBatteryColor() {
                switch (battery.chargeState.rawValue) {
                case MAVLink.MAV_BATTERY_CHARGE_STATE_OK:
                    return qgcPal.text
                case MAVLink.MAV_BATTERY_CHARGE_STATE_LOW:
                    return qgcPal.colorOrange
                case MAVLink.MAV_BATTERY_CHARGE_STATE_CRITICAL:
                case MAVLink.MAV_BATTERY_CHARGE_STATE_EMERGENCY:
                case MAVLink.MAV_BATTERY_CHARGE_STATE_FAILED:
                case MAVLink.MAV_BATTERY_CHARGE_STATE_UNHEALTHY:
                    return showFailSafeAlert();
                default:
                    return qgcPal.text
                }
            } */

            function getBatteryPercentageText() {
                if  (!isNaN(battery.voltage.rawValue))  {
                    return battery.voltage.valueString + battery.voltage.units;
                }   else if (!isNaN(battery.percentRemaining.rawValue)){
                    return  battery.percentRemaining.enumStringValue;
                }
                return  qsTr("N/A");
            }

            function getBatteryVoltageText() {
                if (!isNaN(battery.percentRemaining.rawValue)) {
                    if (battery.percentRemaining.rawValue > 98.9) {
                        return qsTr("100%")
                    } else {
                        return battery.percentRemaining.valueString + battery.percentRemaining.units
                    }
                } else if (!isNaN(battery.voltage.rawValue)) {
                    return battery.voltage.valueString + battery.voltage.units
                } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                    return battery.chargeState.enumStringValue
                }
                return ""
            }

            function getBatteryBatteryImage() {
                if (!isNaN(battery.voltage.rawValue)) {
                    var voltage = battery.voltage.rawValue;
                    if (voltage > 40) {
                        return "/skyclean/Battery100";
                    } else if (voltage > 41) {
                        return "/skyclean/Battery75";
                    } else if (voltage > 38) {
                        return "/skyclean/Battery50";
                    } else if (voltage > 35) {
                        return "/skyclean/Battery25";
                    } else {
                        return "/skyclean/Battery0";
                    }
                }
                return "N/A";
            }

            //------CREATE SKYDRONES-------
            function getBatteryPercentageImage() {
                if (!isNaN(battery.percentRemaining.rawValue)) {
                    var percentRemaining = battery.percentRemaining.rawValue;
                    if (percentRemaining > 90.8) {
                        return "/skyclean/Battery100";
                    } else if (percentRemaining > 75.1) {
                        return "/skyclean/Battery75";
                    } else if (percentRemaining > 40.1) {
                        return "/skyclean/Battery50";
                    } else if (percentRemaining > 10.1) {
                        return "/skyclean/Battery25";
                    } else {
                        return "/skyclean/Battery0";
                    }
                }
                return "N/A";
            }

            function getBatteryColor() {
                if (!isNaN(battery.voltage.rawValue)) {
                    var voltage = battery.voltage.rawValue;
                    var normalColor = "white";
                    var alertColor = "yellow";
                    var criticalColor = "red";

                    if (voltage > 42) {
                        return normalColor;
                    } else if (voltage > 40) {
                        return alertColor;
                    } else {
                        return criticalColor;
                    }
                }
                return "N/A";
            }

            /* function logoSD(){
                if()
            } */

            QGCColoredImage {
                width:              height
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                source:             getBatteryPercentageImage()
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                layer.enabled: true
                layer.effect: ColorOverlay { 
                    color: qgcPal.buttonText
                }
            }

            QGCLabel {
                text:                   getBatteryVoltageText() //getBatteryPercentageText() system to voltage
                font.pointSize:         ScreenTools.mediumFontPointSize * 0.9
                font.bold:              true 
                //color:                  getBatteryColor()
                anchors.verticalCenter: parent.verticalCenter
            }

        }
    }

    Component {
        id: batteryValuesAvailableComponent

        QtObject {
            property bool functionAvailable:        battery.function.rawValue !== MAVLink.MAV_BATTERY_FUNCTION_UNKNOWN
            property bool temperatureAvailable:     !isNaN(battery.temperature.rawValue)
            property bool currentAvailable:         !isNaN(battery.current.rawValue)
            property bool mahConsumedAvailable:     !isNaN(battery.mahConsumed.rawValue)
            property bool timeRemainingAvailable:   !isNaN(battery.timeRemaining.rawValue)
            property bool chargeStateAvailable:     battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED
        }
    }

    Component {
        id: batteryPopup

        Rectangle {
            width:          mainLayout.width   + mainLayout.anchors.margins * 2
            height:         mainLayout.height  + mainLayout.anchors.margins * 2
            radius:         ScreenTools.defaultFontPixelHeight / 2
            color:          qgcPal.window
            border.color:   qgcPal.text

            ColumnLayout {
                id:                 mainLayout
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.top:        parent.top
                anchors.right:      parent.right
                spacing:            ScreenTools.defaultFontPixelHeight

                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    text:               qsTr("Status da Bateria")
                    font.family:        ScreenTools.demiboldFontFamily
                }

                RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth

                    ColumnLayout {
                        Repeater {
                            model: _activeVehicle ? _activeVehicle.batteries : 0

                            ColumnLayout {
                                spacing: 0

                                property var batteryValuesAvailable: nameAvailableLoader.item

                                Loader {
                                    id:                 nameAvailableLoader
                                    sourceComponent:    batteryValuesAvailableComponent

                                    property var battery: object
                                }

                                QGCLabel { text: qsTr("Bateria %1").arg(object.id.rawValue) }
                                QGCLabel { text: qsTr("Estado de carga");                          visible: batteryValuesAvailable.chargeStateAvailable }
                                QGCLabel { text: qsTr("Restante");                             visible: batteryValuesAvailable.timeRemainingAvailable }
                                QGCLabel { text: qsTr("Restante") }
                                QGCLabel { text: qsTr("Voltagem") }
                                QGCLabel { text: qsTr("Consumo");                              visible: batteryValuesAvailable.mahConsumedAvailable }
                                QGCLabel { text: qsTr("Temperatura");                           visible: batteryValuesAvailable.temperatureAvailable }
                                QGCLabel { text: qsTr("Função");                              visible: batteryValuesAvailable.functionAvailable }
                            }
                        }
                    }

                    ColumnLayout {
                        Repeater {
                            model: _activeVehicle ? _activeVehicle.batteries : 0

                            ColumnLayout {
                                spacing: 0

                                property var batteryValuesAvailable: valueAvailableLoader.item

                                Loader {
                                    id:                 valueAvailableLoader
                                    sourceComponent:    batteryValuesAvailableComponent

                                    property var battery: object
                                }

                                QGCLabel { text: "" }
                                QGCLabel { text: object.chargeState.enumStringValue;                                        visible: batteryValuesAvailable.chargeStateAvailable }
                                QGCLabel { text: object.timeRemainingStr.value;                                             visible: batteryValuesAvailable.timeRemainingAvailable }
                                QGCLabel { text: object.percentRemaining.valueString + " " + object.percentRemaining.units }
                                QGCLabel { text: object.voltage.valueString + " " + object.voltage.units }
                                QGCLabel { text: object.mahConsumed.valueString + " " + object.mahConsumed.units;           visible: batteryValuesAvailable.mahConsumedAvailable }
                                QGCLabel { text: object.temperature.valueString + " " + object.temperature.units;           visible: batteryValuesAvailable.temperatureAvailable }
                                QGCLabel { text: object.function.enumStringValue;                                           visible: batteryValuesAvailable.functionAvailable }
                            }
                        }
                    }
                }
            }
        }
    }
}
