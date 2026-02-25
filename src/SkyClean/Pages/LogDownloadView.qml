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
import QGroundControl.FactControls    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

Rectangle{
    id:                                         root 
    width:                                      parent.width 
    height:                                     parent.height 
    color:                                      "transparent"

    QGCPalette { id:qgcPal }
    LogDownloadController { id: logController }
    BoxWindowAlert{ 
        id:             laserAlert
        visible:        false
    setWidth:       ScreenTools.defaultFontPixelWidth * 84
    setHeight:      ScreenTools.defaultFontPixelHeight * 8.75
        buttonVisible:  true
        titleName:      qsTr("LOG")
        setDescri:      qsTr("O drone precisa estar conectado")
        z:              30
    }

    Rectangle{
        id:                                     settings 
        width:                                  ScreenTools.defaultFontPixelWidth * 56
        height:                                 parent.height 
        color:                                  qgcPal.iconColor
        x:                                      visible ? Math.min(ScreenTools.defaultFontPixelWidth * 9.8, 180) : -width 
        z:                                      5

        Behavior on x{
            PropertyAnimation{
                duration:                       500
                easing:                         Easing.InOutQuad
            }
        }

        QGCFlickable {
            clip:                               true
            anchors.fill:                       parent
            contentHeight:                      outerColumn.height
            contentWidth:                       outerColumn.width 
            Column{
                id:                             outerColumn
                spacing:                        ScreenTools.defaultFontPixelHeight * 0.581
                anchors{
                    left:                       parent.left 
                    leftMargin:                 10
                    top:                        parent.top
                    topMargin:                  10
                }
                
                Text{
                    text:                           qsTr("Histórico de voos")
                    color:                          qgcPal.textColor
                    font.bold:                      true 
                    wrapMode:                       "WordWrap"
                }

                Text {
                    id: historyDescription
                    textFormat: Text.RichText
                    width: outerColumn.width - (ScreenTools.defaultFontPixelWidth * 1.4)
                    wrapMode: Text.WordWrap
                    color: qgcPal.textColor
                    // link color set to palette cleanColor and link text bold
                    text: "Aqui você pode conferir o histórico de voos realizados com o SkyClean. Para fazer o download dos logs de voos, você deve conectar seu drone ao computador e acessá-lo através do software SkyDrones, conforme o tutorial neste link " +"<a href=\"https://docs.skydrones.com.br/manutencao-basica/skydrones-desktop\" style=\"color: " + qgcPal.cleanColor + "; font-weight: bold; text-decoration: underline;\">tutorial SkyDrones Desktop</a>."
                    onLinkActivated: function(link) { Qt.openUrlExternally(link) }
                }
                
                Rectangle{
                    id:                                 backLog
                    width:                              ScreenTools.defaultFontPixelWidth * 54.6
                    height:                             ScreenTools.defaultFontPixelHeight * 18.956
                    color:                              qgcPal.iconColor
                    border.color:                       qgcPal.cleanColor
                    border.width:                       ScreenTools.defaultFontPixelHeight * 0.147
                    radius:                             ScreenTools.defaultFontPixelWidth * 0.7


                    Flickable {
                        clip:               true
                        anchors.fill:       parent
                        contentHeight:      logFlick.height
                
                        Column {
                            id:                     logFlick
                            width: parent.width
                            spacing: ScreenTools.defaultFontPixelHeight * 2.044

                            Repeater {
                                model: logController.model
                                delegate: Item {
                                    width: parent.width
                                    height: ScreenTools.defaultFontPixelHeight * 1.75 

                                    Column {
                                        width: parent.width
                                        spacing: 5
                                        padding: 10
                                        Rectangle {
                                            color: "#E6E6E6"
                                            radius: ScreenTools.defaultFontPixelWidth * 0.7
                                            border.color: qgcPal.cleanColor
                                            border.width: ScreenTools.defaultFontPixelHeight * 0.0581
                                            width: ScreenTools.defaultFontPixelWidth * 53.2
                                            height: ScreenTools.defaultFontPixelHeight * 2.919
                                            Row {
                                                spacing: ScreenTools.defaultFontPixelHeight * 0.875
                                                anchors.fill: parent
                                                anchors.margins: ScreenTools.defaultFontPixelWidth * 0.7

                                                /* Check */
                                                QGCCheckBox {
                                                    Layout.alignment: Qt.AlignLeft
                                                    checked: modelData.selected
                                                    onClicked: modelData.selected = checked
                                                }

                                                /* ID */
                                                QGCLabel {
                                                    text: {
                                                        var o = modelData
                                                        return o ? "" + o.id : "ID: N/A"
                                                    }
                                                    font.bold: true
                                                    color: "#000"
                                                }
                                                /* DATA */
                                                QGCLabel {
                                                    text: {
                                                        var o = modelData
                                                        if (o && o.received) {
                                                            var d = o.time
                                                            if (d.getUTCFullYear() < 2010) {
                                                                return qsTr("Date Unknown")
                                                            } else {
                                                                var year = d.getUTCFullYear()
                                                                var month = ('0' + (d.getUTCMonth() + 1)).slice(-2)
                                                                var day = ('0' + d.getUTCDate()).slice(-2)
                                                                var hours = ('0' + d.getUTCHours()).slice(-2)
                                                                var minutes = ('0' + d.getUTCMinutes()).slice(-2)
                                                                var seconds = ('0' + d.getUTCSeconds()).slice(-2)
                                                                return year + "-" + month + "-" + day + " " + hours + ":" + minutes
                                                            }
                                                        }
                                                        return "Date: N/A"
                                                    }
                                                    font.bold: true
                                                    color: "#000"
                                                }
                                                /* TAMANHO */
                                                QGCLabel {
                                                    text: {
                                                        var o = modelData
                                                        return o ? "" + o.sizeStr : "Size: N/A"
                                                    }
                                                    font.bold: true
                                                    color: "#000"
                                                }
                                                /* STATUS */
                                                QGCLabel {
                                                    text: {
                                                        var o = modelData
                                                        return o ? "" + o.status : "Status: N/A"
                                                    }
                                                    font.bold: true
                                                    color: "#000"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Row{
                    spacing:                            ScreenTools.defaultFontPixelHeight
                    anchors.bottomMargin:               ScreenTools.defaultFontPixelHeight * 2
                    ButtonAction{                        
                        setWidth:                       ScreenTools.defaultFontPixelWidth * 26.6
                        setHeight:                      ScreenTools.defaultFontPixelHeight * 2.191
                        setText:                        qsTr("Atualizar")
                        onClicked: {
                            
                            if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                                laserAlert.visible = true;
                            } else {
                                logController.refresh()
                            }
                        }
                    }
                    ButtonAction {
                        enabled: !logController.requestingList && !logController.downloadingLogs && logController.model.count > 0
                        setWidth: ScreenTools.defaultFontPixelWidth * 26.6
                        setHeight: ScreenTools.defaultFontPixelHeight * 2.191
                        setText: qsTr("Baixar")
                        onClicked: {
                            var logsSelected = logController.model.count > 0;
                            for (var i = 0; i < logController.model.count; i++) {
                                var o = logController.model.get(i);
                                if (o && o.selected) {
                                    logsSelected = true;
                                    break;
                                }
                            }
                            if (!logsSelected) {
                                mainWindow.showMessageDialog(qsTr("Baixar Log"), qsTr("Você precisa selecionar qual arquivo deseja baixar."));
                                return;
                            }

                            if (ScreenTools.isMobile) {
                                logController.download();
                            } else {
                                fileDialog.title = qsTr("Selecione diretório");
                                fileDialog.folder = QGroundControl.settingsManager.appSettings.logSavePath;
                                fileDialog.selectFolder = true;
                                fileDialog.openForLoad();
                            }
                        }
                    }
                }
                ButtonAction{
                    enabled:                        !logController.requestingList && !logController.downloadingLogs && logController.model.count > 0
                    setWidth:                       ScreenTools.defaultFontPixelWidth * 54.6
                    setHeight:                      ScreenTools.defaultFontPixelHeight * 2.919
                    visible:                        false
                    setText:                        qsTr("Deletar")
                    onClicked:  mainWindow.showComponentDialog(
                        eraseAllMessage,
                        qsTr("Apagar Todos Os Arquivos"),
                        mainWindow.showDialogDefaultWidth,
                        Dialog.Yes | Dialog.No)
                    Component {
                        id: eraseAllMessage
                        QGCViewMessage {
                            message:    qsTr("Ao selecionar 'Apagar Todos' os arquivos serão deletados permanentimente. Deseja Continuar ?")
                            function accept() {
                                logController.eraseAll()
                                hideDialog()
                            }
                        }
                    }
                }
            }
            QGCFileDialog {
                id: fileDialog
                onAcceptedForLoad: {
                    logController.download(file)
                    close()
                }
            }
        }
    }
}