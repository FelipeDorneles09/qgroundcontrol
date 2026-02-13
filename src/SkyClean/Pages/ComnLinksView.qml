/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                      2.3
import QtQuick.Controls             2.4
import QtQuick.Dialogs              
import QtQuick.Layouts              1.2
import QtLocation                   5.3
import QtPositioning                5.3
import QtQuick.Window               2.2
import QtQml.Models                 2.1
import QGroundControl               1.0
import QGroundControl.Controls      1.0

import QGroundControl.FactControls    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

Rectangle{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"

    

    //private 
    QGCPalette { 
        id:qgcPal 
        colorGroupEnabled:  enabled 
    }
    property var _currentSelection:     null
    property int _firstColumnWidth:     ScreenTools.defaultFontPixelWidth * 12
    property int _secondColumnWidth:    ScreenTools.defaultFontPixelWidth * 30
    property int _rowSpacing:           ScreenTools.defaultFontPixelHeight / 2
    property int _colSpacing:           ScreenTools.defaultFontPixelWidth / 2
    
    Rectangle{
        //id:                         _linkRoot
        width:                      ScreenTools.defaultFontPixelWidth * 60
        height:                     parent.height 
        color:                      qgcPal.iconColor 
        x:                                          visible ? Math.min(ScreenTools.defaultFontPixelWidth * 9.8, 180) : -width 

        Behavior on x{
            PropertyAnimation{
                duration:           500
                easing.type:        Easing.InOutQuad
            }
        }

        Rectangle {
            id:                 _linkRoot
            color:              qgcPal.window
            anchors.fill:       parent
            anchors.margins:    ScreenTools.defaultFontPixelWidth

            property var _currentSelection:     null
            property int _firstColumnWidth:     ScreenTools.defaultFontPixelWidth * 12
            property int _secondColumnWidth:    ScreenTools.defaultFontPixelWidth * 30
            property int _rowSpacing:           ScreenTools.defaultFontPixelHeight / 2
            property int _colSpacing:           ScreenTools.defaultFontPixelWidth / 2


            function openCommSettings(originalLinkConfig) {
                settingsLoader.originalLinkConfig = originalLinkConfig
                if (originalLinkConfig) {
                    // Editando a configuração de link existente
                    settingsLoader.editingConfig = QGroundControl.linkManager.startConfigurationEditing(originalLinkConfig)
                } else {
                    // Criando uma nova configuração de link com o UDP como padrão
                    settingsLoader.editingConfig = QGroundControl.linkManager.createConfiguration(LinkConfiguration.TypeUdp, "")
                }
                settingsLoader.sourceComponent = commSettings
            }

            Component.onDestruction: {
                if (settingsLoader.sourceComponent) {
                    settingsLoader.sourceComponent = null
                    QGroundControl.linkManager.cancelConfigurationEditing(settingsLoader.editingConfig)
                }
            }

            QGCFlickable {
                clip:               true
                anchors.top:        parent.top
                width:              parent.width
                height:             parent.height - buttonRow.height
                contentHeight:      settingsColumn.height
                contentWidth:       _linkRoot.width
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id:                 settingsColumn
                    width:              _linkRoot.width
                    anchors.margins:    ScreenTools.defaultFontPixelWidth
                    spacing:            ScreenTools.defaultFontPixelHeight / 2
                    Repeater {
                        model: QGroundControl.linkManager.linkConfigurations
                        delegate: QGCButton {
                            anchors.horizontalCenter:   settingsColumn.horizontalCenter
                            width:                      _linkRoot.width * 0.5
                            text:                       object.name
                            autoExclusive:              true
                            visible:                    !object.dynamic
                            onClicked: {
                                checked = true
                                _currentSelection = object
                            }
                        }
                    }
                }
            }

            Row {
                id:                 buttonRow
                spacing:            ScreenTools.defaultFontPixelWidth
                anchors.bottom:     parent.bottom
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.horizontalCenter: parent.horizontalCenter
                QGCButton {
                    width:      ScreenTools.defaultFontPixelWidth * 10
                    text:       qsTr("Delete")
                    enabled:    _currentSelection && !_currentSelection.dynamic
                    onClicked:  deleteDialog.visible = true

                    MessageDialog {
                        id:         deleteDialog
                        visible:    false
                        buttons:    MessageDialog.Yes | MessageDialog.No
                        title:      qsTr("Remove Link Configuration")
                        text:       _currentSelection ? qsTr("Remove %1. Is this really what you want?").arg(_currentSelection.name) : ""

                        onAccepted: {
                            QGroundControl.linkManager.removeConfiguration(_currentSelection)
                            _currentSelection = null
                            deleteDialog.visible = false
                        }
                        onRejected: deleteDialog.visible = false
                    }
                }
                QGCButton {
                    text:       qsTr("Edit")
                    enabled:    _currentSelection && !_currentSelection.link
                    onClicked:  _linkRoot.openCommSettings(_currentSelection)
                }
                QGCButton {
                    text:       qsTr("Add")
                    onClicked:  _linkRoot.openCommSettings(null)
                }
                QGCButton {
                    text:       qsTr("Connect")
                    enabled:    _currentSelection && !_currentSelection.link
                    onClicked:  QGroundControl.linkManager.createConnectedLink(_currentSelection)
                }
                QGCButton {
                    text:       qsTr("Disconnect")
                    enabled:    _currentSelection && _currentSelection.link
                    onClicked:  _currentSelection.link.disconnect()
                }
                QGCButton {
                    text:       qsTr("MockLink Options")
                    visible:    _currentSelection && _currentSelection.link && _currentSelection.link.isMockLink
                    onClicked:  mainWindow.showPopupDialogFromSource("qrc:/unittest/MockLinkOptionsDlg.qml", { link: _currentSelection.link })
                }
            }

            Loader {
                id:             settingsLoader
                anchors.fill:   parent
                visible:        sourceComponent ? true : false

                property var originalLinkConfig:    null
                property var editingConfig:      null
            }

            //---------------------------------------------
            // Comm Settings
            Component {
                id: commSettings
                Rectangle {
                    id:             settingsRect
                    color:          qgcPal.window
                    anchors.fill:   parent
                    property real   _panelWidth:    width * 0.8

                    QGCFlickable {
                        id:                 settingsFlick
                        clip:               true
                        anchors.fill:       parent
                        anchors.margins:    ScreenTools.defaultFontPixelWidth
                        contentHeight:      mainLayout.height
                        contentWidth:       mainLayout.width

                        ColumnLayout {
                            id:         mainLayout
                            spacing:    _rowSpacing

                            QGCGroupBox {
                                title: originalLinkConfig ? qsTr("Edit Link Configuration Settings") : qsTr("Create New Link Configuration")

                                ColumnLayout {
                                    spacing: _rowSpacing

                                    GridLayout {
                                        columns:        2
                                        columnSpacing:  _colSpacing
                                        rowSpacing:     _rowSpacing

                                        QGCLabel { text: qsTr("Name") }
                                        QGCTextField {
                                            id:                     nameField
                                            Layout.preferredWidth:  _secondColumnWidth
                                            Layout.fillWidth:       true
                                            text:                   editingConfig.name
                                            placeholderText:        qsTr("Enter name")
                                        }

                                        QGCCheckBox {
                                            Layout.columnSpan:  2
                                            text:               qsTr("Automatically Connect on Start")
                                            checked:            editingConfig.autoConnect
                                            onCheckedChanged:   editingConfig.autoConnect = checked
                                        }

                                        QGCCheckBox {
                                            Layout.columnSpan:  2
                                            text:               qsTr("High Latency")
                                            checked:            editingConfig.highLatency
                                            onCheckedChanged:   editingConfig.highLatency = checked
                                        }

                                       QGCComboBox {
                                            Layout.preferredWidth:  _secondColumnWidth
                                            Layout.fillWidth:       true
                                            enabled:                originalLinkConfig == null
                                            model:                  QGroundControl.linkManager.linkTypeStrings

                                            // Define o índice de "UDP" como padrão no currentIndex
                                            Component.onCompleted: {
                                                var indexUDP = model.indexOf("UDP")
                                                if (indexUDP >= 0) {
                                                    currentIndex = indexUDP
                                                }
                                            }

                                            onActivated: {
                                                if (index !== editingConfig.linkType) {
                                                    // Salva o nome atual
                                                    var name = nameField.text
                                                    // Cria nova configuração de link
                                                    editingConfig = QGroundControl.linkManager.createConfiguration(index, name)
                                                }
                                            }
                                        }
                                    }

                                    Loader {
                                        id:     linksettingsLoader
                                        source: subEditConfig.settingsURL

                                        property var subEditConfig: editingConfig
                                    }
                                }
                            }

                            RowLayout {
                                Layout.alignment:   Qt.AlignHCenter
                                spacing:            _colSpacing

                                QGCButton {
                                    width:      ScreenTools.defaultFontPixelWidth * 10
                                    text:       qsTr("OK")
                                    enabled:    nameField.text !== ""

                                    onClicked: {
                                        // Save editing
                                        linksettingsLoader.item.saveSettings()
                                        editingConfig.name = nameField.text
                                        settingsLoader.sourceComponent = null
                                        if (originalLinkConfig) {
                                            QGroundControl.linkManager.endConfigurationEditing(originalLinkConfig, editingConfig)
                                        } else {
                                            // If it was edited, it's no longer "dynamic"
                                            editingConfig.dynamic = false
                                            QGroundControl.linkManager.endCreateConfiguration(editingConfig)
                                        }
                                    }
                                }

                                QGCButton {
                                    width:      ScreenTools.defaultFontPixelWidth * 10
                                    text:       qsTr("Cancel")
                                    onClicked: {
                                        settingsLoader.sourceComponent = null
                                        QGroundControl.linkManager.cancelConfigurationEditing(settingsLoader.editingConfig)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}