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
import QGroundControl.SkyClean     				   				
import QGroundControl.FactControls   				
import QGroundControl.FlightDisplay 				
import QGroundControl.FlightMap     				
           				

FirstRunPrompt {
    title:      qsTr("NOTA DE ATUALIZAÇÃO")
    promptId:   QGroundControl.corePlugin.updateNotesRunPromptId

    property real   _margins:               ScreenTools.defaultFontPixelWidth
    property var    _appSettings:           QGroundControl.settingsManager.appSettings
    property bool   _multipleFirmware:      !QGroundControl.singleFirmwareSupport
    property bool   _multipleVehicleTypes:  !QGroundControl.singleVehicleSupport
    property real   _fieldWidth:            ScreenTools.defaultFontPixelWidth * 16

    ColumnLayout {
        spacing: ScreenTools.defaultFontPixelHeight

        Rectangle {
            Layout.preferredHeight: unitsGrid.height + (_margins * 2)
            Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
            color:                  qgcPal.windowShade
            Layout.fillWidth:       true

            GridLayout {
                id:                 unitsGrid
                anchors.margins:    _margins
                anchors.top:        parent.top
                anchors.left:       parent.left
                rows:               _cVisibleFacts + 1
                flow:               GridLayout.TopToBottom

                QGCLabel { text: qsTr("O que há de novo ? ") }

                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*NOVO* - Ajuste de valor no failsafe da bateria")
                    visible:            _multipleFirmware
                }
                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*NOVO* - Sistema de avisos de segurança")
                    visible:            _multipleFirmware
                }
                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*NOVO* - Indicador de altura primária")
                    visible:            _multipleFirmware
                }
                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*NOVO* - Efeitos sonoros nos avisos de mensagens")
                    visible:            _multipleFirmware
                }
                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*NOVO* - Ajustes no log de telemetria")
                    visible:            _multipleFirmware
                }
                QGCLabel {
                    Layout.fillWidth:   true
                    text:               qsTr("*CORRIGIDO* - Bug que exibia nome do drone na toolbar")
                    visible:            _multipleFirmware
                }
            }
        }
    }
}