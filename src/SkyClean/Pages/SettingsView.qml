/**
 * Copyright (c) 2024, Project SkyDrones Tecnologia Avionica ----   <https://skydrones.com.br/>
 * @Author Jhones Bomfim <jhones.yure@skydrones.com.br>
 * All rights reserved.
 */

import QtQuick                              2.12
import QtQuick.Controls                     2.4
import QtQuick.Dialogs                     
import QtQuick.Layouts                      1.12
import QtLocation                           5.3
import QtPositioning                        5.3
import QtQuick.Window                       2.2
import QtQml.Models                         2.1
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.FactControls          1.0
import QGroundControl.FlightDisplay         1.0
import QGroundControl.FlightMap             1.0
import QGroundControl.SkyClean              1.0
import Qt5Compat.GraphicalEffects           

Rectangle{
    id:                                     root 
    width:                                  parent.width 
    height:                                 parent.height 
    color:                                  "transparent"

    QGCPalette { id:qgcPal }
    
    //private
    property var    _activeVehicle:                     QGroundControl.multiVehicleManager.activeVehicle
    property bool _initialDownloadComplete:             _activeVehicle ? _activeVehicle.initialConnectComplete : true
    property Fact _savePath:                            QGroundControl.settingsManager.appSettings.savePath
    property Fact _appFontPointSize:                    QGroundControl.settingsManager.appSettings.appFontPointSize
    property Fact _userBrandImageIndoor:                QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:               QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property Fact _virtualJoystick:                     QGroundControl.settingsManager.appSettings.virtualJoystick
    property Fact _virtualJoystickAutoCenterThrottle:   QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle
    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 20
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property Fact   _followTarget:              QGroundControl.settingsManager.appSettings.followTarget
    property real   _panelWidth:                _root.width * _internalWidthRatio
    property real   _margins:                   ScreenTools.defaultFontPixelWidth
    property var    _planViewSettings:          QGroundControl.settingsManager.planViewSettings
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig
    property bool   _disableAllDataPersistence: QGroundControl.settingsManager.appSettings.disableAllPersistence.rawValue
    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"
    property Fact laserDistance:                controllerLoader.item.getParameterFact(-1, "AVOID_MARGIN")
    property Fact alertBatt:                    controllerLoader.item.getParameterFact(-1, "USR_SD_BAT1")
    property Fact critialBatt:                  controllerLoader.item.getParameterFact(-1, "USR_SD_BAT2")

    Loader {
        id: controllerLoader
        active: _initialDownloadComplete
        sourceComponent: factPanelControllerComponent
    }

    Component {
        id: factPanelControllerComponent
        FactPanelController {
            id:         controller;
        }
    }

    BoxWindowAlert{ 
        id:                                         laserAlert
        visible:                                    false
    // Converted from fixed pixels to ScreenTools-based sizing
    setWidth:                                   ScreenTools.defaultFontPixelWidth * 84
    setHeight:                                  ScreenTools.defaultFontPixelHeight * 8.68
        buttonVisible:                              true
        titleName:                                  qsTr("LOG")
        setDescri:                                  qsTr("O drone precisa ser reiniciado")
        z:                                          30
    }

    Rectangle{
        id:                                 settings 
        // Converted from fixed pixels to ScreenTools based width
        width:                              ScreenTools.defaultFontPixelWidth * 45.5
        height:                             parent.height 
        color:                              qgcPal.iconColor
        x:                                  visible ? Math.min(ScreenTools.defaultFontPixelWidth * 9.8, 180) : -width 
        z:                                  5

        Behavior on x{
            PropertyAnimation{
                duration:                   500
                easing:                     Easing.InOutQuad
            }
        }

        QGCFlickable {
            clip:                           true
            anchors.fill:                   parent
            contentHeight:                  outerColumn.height
           
            
            Column{
                id:                         outerColumn
                // spacing and margins converted to ScreenTools-relative values
                spacing:                    ScreenTools.defaultFontPixelHeight * 0.868
                anchors{
                    left:                   parent.left 
                    leftMargin:             ScreenTools.defaultFontPixelWidth * 2.1
                    top:                    parent.top
                    topMargin:              ScreenTools.defaultFontPixelHeight * 0.287
                }
                Text{
                    text:                   qsTr("Configurações")
                    color:                  qgcPal.textColor
                    font.bold:              true 
                    wrapMode:               "WordWrap"
                }
                Column{
                    spacing:                ScreenTools.defaultFontPixelHeight * 0.581
                    // Laser 
                    Column{
                        id:                             laser    
                        visible:                        _activeVehicle ? _activeVehicle.initialConnectComplete : false  
                        spacing:                        _margins
                        Text{
                            text:                       qsTr("Laser")
                            font.italic:                true 
                            color:                      qgcPal.textColor                       
                        }                    
                        SwitchAction {                            
                            property bool laserOn: controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value === 3

                            setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                            setHeight:                 ScreenTools.defaultFontPixelHeight * 2.919
                            falseImg:                   "/skyclean/LaserOff"
                            trueImg:                    "/skyclean/LaserOn"
                            falseTxt:                   qsTr("Desligado")
                            trueTxt:                    qsTr("Ligado")
                            isChecked:                  laserOn

                            Connections {
                                target: controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE")

                                onValueChanged: {
                                    laserOn = value === 3
                                    isChecked = laserOn
                                }
                            }

                            onClicked: {
                                if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
                                    mainWindow.showMessageDialog(qsTr("Definir Laser"), qsTr("Você precisa estar conectado ao drone."))
                                } else {
                                    laserOn = isChecked
                                    controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value = laserOn ? 3 : 1
                                    console.log("Valor a ser enviado para AVOID_ENABLE: ", controllerLoader.item.getParameterFact(-1, "AVOID_ENABLE").value)
                                }            
                            }
                        }
                                                
                    }
                    Column{
                        visible:                        _activeVehicle ? _activeVehicle.initialConnectComplete : false
                        Row {
                            spacing: ScreenTools.defaultFontPixelWidth * 1.4
                            height: baseFontEdit.height * 1.6

                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text:                       qsTr("Distância da parede")
                                font.italic:                true 
                                color:                      qgcPal.textColor  
                            }

                            

                            Rectangle {
                                id: helpBtnLaserTitle
                                width: ScreenTools.defaultFontPixelWidth * 2.5
                                height: width
                                radius: width / 2
                                color: qgcPal.buttonHighlight
                                border.color: qgcPal.buttonHighlightText
                                border.width: ScreenTools.defaultFontPixelHeight * 0.028
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "?"
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.5
                                    font.bold: true
                                    color: qgcPal.buttonHighlightText
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: mainWindow.showPopupDialogFromComponent(laserDistanceHelpComponent)
                                }
                            }
                        }

                        // Margem adicional embaixo da sessão
                        Item {
                            width: parent.width
                            height: _margins / 2
                        }

                        Item {
                            width:                          _comboFieldWidth
                            height:                         baseFontEdit.height * 1.5
                            visible:                        _appFontPointSize.visible
                            Layout.alignment:               Qt.AlignVCenter                                          
                            Row {
                                spacing:                    ScreenTools.defaultFontPixelWidth * 1.75
                                                    
                                ButtonOp {
                                    setWidth:               ScreenTools.defaultFontPixelWidth * 5.25
                                    setHeight:              setWidth
                                    setOperator:            "-"
                                    onClicked: {
                                        laserDistance.value = (laserDistance.value - 0.100).toFixed(2)                                                            
                                        laserDistance.valueString = laserDistance.value.toString()
                                    }
                                }
                                QGCLabel {
                                    property string valorLaser: parseFloat(laserDistance.valueString)
                                    width:                  ScreenTools.defaultFontPixelWidth * 4.2
                                    text:                   (valorLaser * 100 ).toFixed(0) + " cm" 
                                    horizontalAlignment:    Text.AlignHCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    font.pointSize:         50
                                    font.bold:              true 
                                }

                                ButtonOp {
                                    setWidth:               ScreenTools.defaultFontPixelWidth * 5.25
                                    setHeight:              setWidth
                                    setOperator:            "+"
                                    onClicked: {                                                                             
                                        laserDistance.value = (laserDistance.value + 0.100).toFixed(2)                                                            
                                        laserDistance.valueString = laserDistance.value.toString()
                                    }
                                }
                                Image {
                                    //id: img
                                    source: "/skyclean/Edit"
                                    layer.enabled: true
                                    width: ScreenTools.defaultFontPixelWidth * 4.2
                                    height: ScreenTools.defaultFontPixelHeight * 2.1
                                    layer.effect: ColorOverlay {
                                        // indoorPalette.rawValue === 0 -> dark theme
                                        color: QGroundControl.settingsManager.appSettings.indoorPalette.rawValue === 0 ? "#000000" : '#ffffff'
                                    }
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: setText.visible = !setText.visible
                                    }
                                }
                            }                                                
                        }
                        
                        // Margem adicional embaixo da sessão
                        Item {
                            width: parent.width
                            height: ScreenTools.defaultFontPixelHeight * 1.4
                        }
                    }       
                               
                    Column{
                        id:                                             setText
                        anchors.topMargin:                              ScreenTools.defaultFontPixelHeight * 2.1
                        
                        spacing:                                        ScreenTools.defaultFontPixelHeight * 0.875
                        visible: false
                        
                        Text{
                            text:                       qsTr("Insira o valor em centimetros")
                            font.italic:                true 
                            color:                      qgcPal.textColor
                            font.pointSize:             8                       
                        }  
                        Row{                                
                            spacing:                                        ScreenTools.defaultFontPixelWidth * 1.75
                                                     
                            Item {
                                width: ScreenTools.defaultFontPixelWidth * 25.2
                                height: ScreenTools.defaultFontPixelHeight * 2

                                TextField{ 
                                    id:                                         valueTxt         
                                    anchors.fill:                               parent
                                    rightPadding:                                ScreenTools.defaultFontPixelWidth * 5
                                    placeholderText:                            qsTr("Ex: 1000 cm")
                                    inputMethodHints:                           Qt.ImhDigitsOnly
                                }

                                // help button moved to the section title for clarity
                            }
                            ButtonAction{
                                setWidth:                                   ScreenTools.defaultFontPixelWidth * 12.6
                                setHeight:                                  ScreenTools.defaultFontPixelHeight * 2
                                setText:                                    qsTr("Ok")
                                onClicked: {
                                    var txt = valueTxt.text ? valueTxt.text.trim() : "";
                                    if (txt === "" || isNaN(txt)) {
                                        // show the error text placed below the row
                                        alertTxtLaser.visible = true;
                                    } else {
                                        // usuário informa valor em centímetros; armazenamos em metros
                                        laserDistance.value = parseFloat(txt) / 100.0;
                                        setText.visible = false;
                                    }
                                }
                            }
                        }
                        Text{
                            id: alertTxtLaser
                            text: qsTr("Insira um valor válido em centímetros")
                            color: "red"
                            visible: false
                            Timer{
                                interval: 5000
                                running: true
                                repeat: true
                                onTriggered: alertTxtLaser.visible = false;
                            }
                        }

                        Component {
                            id: laserDistanceHelpComponent
                            QGCPopupDialog {
                                title: qsTr("Distância da parede")
                                buttons: Dialog.Ok

                                ColumnLayout {
                                    QGCLabel {
                                        wrapMode: Text.WordWrap
                                        text: qsTr("Este parâmetro configura a distância máxima que o drone poderá se aproximar da parede. A referência é a posição do sensor localizado ao lado da câmera no drone.")
                                        Layout.fillWidth: true
                                        Layout.maximumWidth: mainWindow.width / 2
                                    }
                                }
                            }
                        }
                    }  

                    // --- LINE ---
                    Rectangle{
                            width:                      ScreenTools.defaultFontPixelWidth * 42
                            height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                            color:                      qgcPal.textColor
                        }        

                    //bateria value
                    Column{
                        visible:                                        _activeVehicle
                            
                        Row {
                            spacing: ScreenTools.defaultFontPixelWidth
                            height: baseFontEdit.height * 1.6

                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text:                       qsTr("Alerta de aviso de bateria")
                                font.italic:                true 
                                color:                      qgcPal.textColor                       
                            }

                            Rectangle {
                                id: helpBtnAlertTitle
                                width: ScreenTools.defaultFontPixelWidth * 2.5
                                height: width
                                radius: width / 2
                                color: qgcPal.buttonHighlight
                                border.color: qgcPal.buttonHighlightText
                                border.width: ScreenTools.defaultFontPixelHeight * 0.028
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "?"
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.5
                                    font.bold: true
                                    color: qgcPal.buttonHighlightText
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: mainWindow.showPopupDialogFromComponent(alertBattHelpComponent)
                                }
                            }
                        }
                        Column{
                            //id:                                             setText
                            spacing:                                        ScreenTools.defaultFontPixelHeight * 1.25
                           
                            Text{
                                text:                       qsTr("Valor atual é: %1").arg(alertBatt.value)
                                font.italic:                true 
                                color:                      qgcPal.textColor
                                font.pointSize:             8                       
                            }  
                            Row{                                
                                spacing:                                        ScreenTools.defaultFontPixelWidth * 1.75
                                                      
                                Item {
                                    width: ScreenTools.defaultFontPixelWidth * 25.2
                                    height: ScreenTools.defaultFontPixelHeight * 2

                                    TextField{ 
                                        id:                                         valueTxtBatt         
                                        anchors.fill:                               parent
                                        rightPadding:                                ScreenTools.defaultFontPixelWidth * 5
                                        placeholderText:                            qsTr("Escolha de %1 a %2").arg(20).arg(30)
                                        inputMethodHints:                           Qt.ImhDigitsOnly
                                    }

                                    // help button moved to the section title for clarity
                                }
                                ButtonAction{    
                                    setWidth:                                   ScreenTools.defaultFontPixelWidth * 12.6
                                    setHeight:                                  ScreenTools.defaultFontPixelHeight * 2
                                    setText:                                    qsTr("Ok")
                                    onClicked: {                                        
                                            if (!isNaN(valueTxtBatt.text) && valueTxtBatt.text >= 20 && valueTxtBatt.text <= 30) {
                                            alertBatt.value = valueTxtBatt.text;
                                            setText.visible = false;
                                            check1Txt.visible = true;
                                            // laserAlert disabled in no-laser build
                                            laserAlert.visible = false;
                                        } else {
                                            alertTxt1.visible = true 
                                        }
                                    }
                                }
                            }
                            Text{
                                id:                                         alertTxt1
                                text:                                       qsTr("Insira um valor entre 20 a 30")
                                color:                                      "red"
                                visible:                                    false   
                                Timer{
                                    interval:                               5000
                                    running:                                true 
                                    repeat:                                 true   
                                    onTriggered:                            alertTxt1.visible = false;                      
                                }                                
                            }
                            Text{
                                id:                                         check1Txt
                                text:                                       qsTr("valor inserido com sucesso")
                                color:                                      "green"
                                visible:                                    false      
                                Timer{
                                    interval:                               5000
                                    running:                                true 
                                    repeat:                                 true   
                                    onTriggered:                            check1Txt.visible = false;                      
                                }                        
                            }    
                        } 
                        Component {
                            id: alertBattHelpComponent
                            QGCPopupDialog {
                                title: qsTr("Alerta de aviso de bateria")
                                buttons: Dialog.Ok

                                ColumnLayout {
                                    QGCLabel {
                                        wrapMode: Text.WordWrap
                                        text: qsTr("Configure o valor desejado (entre 20% e 30%) para que o aplicativo no rádio controle emita os avisos sonoros e visuais para que o drone seja pousado e a bateria trocada.")
                                        Layout.fillWidth: true
                                        Layout.maximumWidth: mainWindow.width / 2
                                    }
                                }
                            }
                        }
                    }

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                        visible:                    _activeVehicle
                            
                    }      

                    //  Definir FailSafe da Bateria
                    Column{
                         visible:                                        _activeVehicle
                            
                        Row {
                            spacing: ScreenTools.defaultFontPixelWidth
                            height: baseFontEdit.height * 1.6

                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                text:                       qsTr("Alerta crítico de bateria")
                                font.italic:                true 
                                color:                      qgcPal.textColor                       
                            }

                            Rectangle {
                                id: helpBtnCritTitle
                                width: ScreenTools.defaultFontPixelWidth * 2.5
                                height: width
                                radius: width / 2
                                color: qgcPal.buttonHighlight
                                border.color: qgcPal.buttonHighlightText
                                border.width: ScreenTools.defaultFontPixelHeight * 0.028
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "?"
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.5
                                    font.bold: true
                                    color: qgcPal.buttonHighlightText
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: mainWindow.showPopupDialogFromComponent(critBattHelpComponent)
                                }
                            }
                        }
                        Column{
                            //id:                                             setText
                            spacing:                                        ScreenTools.defaultFontPixelHeight * 1.25
                            //visible: false
                            
                            Text{
                                text:                       qsTr("Valor atual é: %1").arg(critialBatt.value)
                                font.italic:                true 
                                color:                      qgcPal.textColor
                                font.pointSize:             8                       
                            }  
                            Row{                                
                                spacing:                                        ScreenTools.defaultFontPixelWidth * 1.75
                                                      
                                Item {
                                    width: ScreenTools.defaultFontPixelWidth * 25.2
                                    height: ScreenTools.defaultFontPixelHeight * 2

                                    TextField{ 
                                        id:                                         valueBatt        
                                        anchors.fill:                               parent
                                        rightPadding:                                ScreenTools.defaultFontPixelWidth * 5
                                        placeholderText:                            qsTr("Escolha de %1 a %2").arg(10).arg(20)
                                        inputMethodHints:                           Qt.ImhDigitsOnly
                                    }

                                    // help button moved to the section title for clarity
                                }
                                    ButtonAction{
                                        setWidth:                                   ScreenTools.defaultFontPixelWidth * 12.6
                                        setHeight:                                  ScreenTools.defaultFontPixelHeight * 2
                                        setText:                                    qsTr("Ok")
                                        onClicked: {
                                        
                                            if (!isNaN(valueBatt.text) && valueBatt.text >= 10 && valueBatt.text <= 20) {
                                                critialBatt.value = valueBatt.text;
                                                setText.visible = false;
                                                check2Txt.visible = true;
                                                // laserAlert disabled in no-laser build
                                                laserAlert.visible = false;
                                            } else {
                                                alertTxt2.visible = true 
                                            }
                                        }
                                    }
                            }
                            Component {
                                id: critBattHelpComponent
                                QGCPopupDialog {
                                    title: qsTr("Alerta crítico de bateria:")
                                    buttons: Dialog.Ok

                                    ColumnLayout {
                                        QGCLabel {
                                            wrapMode: Text.WordWrap
                                            text: qsTr("Configure o valor desejado (entre 10% e 20%) para que o aplicativo no rádio controle emita os avisos sonoros e visuais e que o drone entre no modo de pouso (LAND), iniciando a descida automática e bloqueando comandos para cima no rádio controle. IMPORTANTE: Este valor deve ser mais alto para trabalhos localizados em alturas maiores, para que haja tempo hábil e seguro para o pouso e posicionamento do drone em casos críticos.")
                                            Layout.fillWidth: true
                                            Layout.maximumWidth: mainWindow.width / 2
                                        }
                                    }
                                }
                            }
                            Text{
                                id:                                         alertTxt2
                                text:                                       qsTr("Insira um valor entre 10 a 20")
                                color:                                      "red"
                                visible:                                    false      
                                Timer{
                                    interval:                               5000
                                    running:                                true 
                                    repeat:                                 true   
                                    onTriggered:                            alertTxt2.visible = false;                      
                                }                        
                            }
                            Text{
                                id:                                         check2Txt
                                text:                                       qsTr("valor inserido com sucesso")
                                color:                                      "green"
                                visible:                                    false      
                                Timer{
                                    interval:                               5000
                                    running:                                true 
                                    repeat:                                 true   
                                    onTriggered:                            check2Txt.visible = false;                      
                                }                        
                            }
                            
                        } 
                    }   

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                        visible:                    _activeVehicle
                    }     

                    //Camera 
                    Column {
                        spacing:                    ScreenTools.defaultFontPixelHeight * 0.581
                        Text {
                            id:         videoSourceLabel
                            text:       qsTr("Fonte")
                            color:      qgcPal.textColor
                            visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible
                        }
                        FactComboBox {
                            id:                     videoSource
                            width:  ScreenTools.defaultFontPixelWidth * 40.6
                            indexModel:             false
                            fact:                   _videoSettings.videoSource
                            visible:                videoSourceLabel.visible
                        }
                        /*

                        QGCLabel {
                            id:         udpPortLabel
                            text:       qsTr("Porta UDP")
                            visible:    !_videoAutoStreamConfig && (_isUDP264 || _isUDP265 || _isMPEGTS) && _videoSettings.udpPort.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  580
                            fact:                   _videoSettings.udpPort
                            visible:                udpPortLabel.visible
                        }
                        Image {
                            visible:                                !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                            source:                                 "/skyclean/Edit"        
                            MouseArea{
                                anchors.fill:                       parent 
                                onClicked: {
                                    rtspUrlLabel.visible = !rtspUrlLabel.visible 
                                }
                            }                     
                        }
                        */
                        QGCLabel {
                            id:         rtspUrlLabel
                            text:       qsTr("RTSP URL")
                            visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible && _videoSource === _videoSettings.rtspVideoSource && _videoSettings.rtspUrl.visible
                        }
                        FactTextField {
                            id:                     rtspUrlField
                            width:                  ScreenTools.defaultFontPixelWidth * 41.3
                            fact:                   _videoSettings.rtspUrl
                            visible:                rtspUrlLabel.visible
                            text:                   "rtsp://192.168.144.25:8554/main.254"
                            onTextChanged: SiYi.camera.analyzeIp(text)
                        }
                        ButtonAction{
                            visible:                                rtspUrlLabel.visible
                            setWidth:                               ScreenTools.defaultFontPixelWidth * 41.3
                            height:                                 ScreenTools.defaultFontPixelHeight * 2.919
                            setText:                                qsTr("Ok")
                            onClicked:{
                                // Aplica/valida a URL sem esconder o campo
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                if (typeof mainWindow !== 'undefined' && mainWindow.showMessageDialog) {
                                    mainWindow.showMessageDialog(qsTr("RTSP"), qsTr("RTSP URL aplicada"))
                                }
                            }
                        }           

                        // Botão para forçar reenvio/reaplicação do RTSP URL — zera e restaura
                        ButtonAction{
                            visible:                                rtspUrlLabel.visible
                            setWidth:                               ScreenTools.defaultFontPixelWidth * 41.3
                            height:                                 ScreenTools.defaultFontPixelHeight * 2.919
                            setText:                                qsTr("Reenviar RTSP")
                            onClicked: {
                                var cur = _videoSettings.rtspUrl.value
                                // Forçar mudança para disparar qualquer listener que só reage a mudança
                                _videoSettings.rtspUrl.value = ""
                                _videoSettings.rtspUrl.value = cur
                                console.log("Reenviando RTSP URL:", cur)
                                // Tentar reutilizar a rotina de análise/validação
                                SiYi.camera.analyzeIp(cur)
                                // Feedback ao usuário
                                if (typeof mainWindow !== 'undefined' && mainWindow.showMessageDialog) {
                                    mainWindow.showMessageDialog(qsTr("RTSP"), qsTr("Reenviando RTSP URL"))
                                }
                            }
                        }

                        /*
                        QGCLabel {
                            id:         tcpUrlLabel
                            text:       qsTr("TCP URL")
                            visible:    !_videoAutoStreamConfig && _isTCP && _videoSettings.tcpUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  400
                            fact:                   _videoSettings.tcpUrl
                            visible:                tcpUrlLabel.visible
                        }
                        */

                    }    

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                        visible:                    _activeVehicle
                    }                   
                    
                    /* Idioma */
                    Text{
                        text:                       qsTr("Idioma")
                        font.italic:                true 
                        color:                      qgcPal.textColor                       
                    }                    
                    SwitchAction{
                        id:                         languageSwitch
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.919
                        falseImg:                   "/skyclean/BrazilIcon"
                        trueImg:                    "/skyclean/EUAIcon"
                        falseTxt:                   qsTr("Português")
                        trueTxt:                    qsTr("English")
                        isChecked:                  QGroundControl.settingsManager.appSettings.qLocaleLanguage.rawValue === 29
                        
                        Component.onCompleted: {
                            // Ensure UI reflects current saved locale on creation
                            languageSwitch.isChecked = QGroundControl.settingsManager.appSettings.isLocaleEnglish()
                        }

                        onClicked: (checked) => {
                            if (checked) {
                                QGroundControl.settingsManager.appSettings.setLocaleEnglish()
                            } else {
                                QGroundControl.settingsManager.appSettings.setLocalePortuguese()
                            }
                        }
                        
                        Connections {
                            target: QGroundControl.settingsManager.appSettings.qLocaleLanguage
                            onRawValueChanged: languageSwitch.isChecked = (QGroundControl.settingsManager.appSettings.qLocaleLanguage.rawValue === 29)
                        }
                    }   
                    FactComboBox {
                        Layout.preferredWidth:      _comboFieldWidth
                        fact:                       QGroundControl.settingsManager.appSettings.qLocaleLanguage
                        indexModel:                 false
                        visible:                    false   //QGroundControl.settingsManager.appSettings.qLocaleLanguage.visible
                    }    

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }    

                    /* Cor de Tema */
                    Text{
                        text:                       qsTr("Cor de Tema")
                        font.italic:                true   
                        color:                      qgcPal.textColor                     
                    }       
                    SwitchAction{
                        property bool backend:      QGroundControl.settingsManager.appSettings.indoorPalette.rawValue === 0
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.919
                        falseImg:                   "/skyclean/MoomMode"
                        trueImg:                    "/skyclean/SunMode"
                        falseTxt:                   qsTr("Modo Escuro")
                        trueTxt:                    qsTr("Modo Claro")
                        isChecked:                  backend
                        onClicked: {
                            backend = isChecked
                            QGroundControl.settingsManager.appSettings.indoorPalette.rawValue = backend ? 0 : 1
                            console.log("valor é: ", backend)
                        }

                    }             

                    FactComboBox {
                        Layout.preferredWidth:      200 // ou defina para _comboFieldWidth se estiver no contexto
                        fact:                       QGroundControl.settingsManager.appSettings.indoorPalette
                        indexModel:                 false
                        visible:                    false  //QGroundControl.settingsManager.appSettings.indoorPalette.visible
                    }

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }   

                    /* Escala do Aplicativo */
                    Text{
                        text:                       qsTr("Escala UI")
                        font.italic:                true 
                        color:                      qgcPal.textColor 
                        anchors.bottomMargin:        ScreenTools.defaultFontPixelHeight * 0.581
                    }

                    Item {
                        width: parent.width
                        height: _margins / 2
                    }

                    Item {
                        width:                      _comboFieldWidth
                        height:                     baseFontEdit.height * 1.5
                        visible:                    _appFontPointSize.visible
                        Layout.alignment:           Qt.AlignVCenter
                        /* Component.onCompleted: {
                            _appFontPointSize.value =   ScreenTools.platformFontPointSize * 0.71;
                        } */
                        Row {
                            spacing:                ScreenTools.defaultFontPixelWidth
                            anchors.verticalCenter: parent.verticalCenter
                             ButtonOp {
                                setWidth:               ScreenTools.defaultFontPixelWidth * 5.25
                                setHeight:              setWidth
                                setOperator:            "-"
                                onClicked: {
                                    if (_appFontPointSize.value > _appFontPointSize.min) {
                                        _appFontPointSize.value = _appFontPointSize.value - 1
                                    }
                                }
                            }
                            QGCLabel {
                                id:                     baseFontEdit
                                width:                  ScreenTools.defaultFontPixelWidth * 4.2
                                text:                   (QGroundControl.settingsManager.appSettings.appFontPointSize.value / ScreenTools.platformFontPointSize * 100).toFixed(0) + "%"
                                horizontalAlignment:    Text.AlignHCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                font.pointSize:         30
                                font.bold:              true 
                            }

                            ButtonOp {
                                setWidth:               ScreenTools.defaultFontPixelWidth * 5.25
                                setHeight:              setWidth
                                setOperator:            "+"
                                onClicked: {
                                    if (_appFontPointSize.value < _appFontPointSize.max) {
                                        _appFontPointSize.value = _appFontPointSize.value + 1
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: _margins / 2
                    }

                    Rectangle{
                            width:                      ScreenTools.defaultFontPixelWidth * 42
                            height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                            color:                      qgcPal.textColor
                        }
                        ButtonAction{
                            visible:                                _activeVehicle ? _activeVehicle.initialConnectComplete : false  
                            setWidth:                               ScreenTools.defaultFontPixelWidth * 41.3
                            height:                                 ScreenTools.defaultFontPixelHeight * 2.919
                            setText:                                qsTr("Configurar Laser")
                            onClicked:{
                                /*  if(_activeVehicle ? _activeVehicle.loadProgress){
                                    showLaserSafety()
                                } */
                                showLaserSafety()
                            }
                        }                 
                    
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 7
                        height:                     ScreenTools.defaultFontPixelHeight * 0.581
                        color:                      "transparent"
                    }

                    Column{
                        visible: false
                        spacing: ScreenTools.defaultFontPixelHeight * 0.581
                        Text{
                            text:                       qsTr("Ajustes de Telemetria")
                            font.italic:                true 
                            color:                      qgcPal.textColor 
                        }
                        FactCheckBox {
                            id:         promptSaveLog
                            text:       qsTr("Salvar registro após cada voo")
                            fact:       _telemetrySave
                            visible:    _telemetrySave.visible
                            enabled:    true // !_disableAllDataPersistence
                            property Fact _telemetrySave: QGroundControl.settingsManager.appSettings.telemetrySave
                        }
                        FactCheckBox {
                            id:         logIfNotArmed
                            text:       qsTr("Save logs even if vehicle was not armed")
                            fact:       _telemetrySaveNotArmed
                            visible:    false// _telemetrySaveNotArmed.visible
                            enabled:    true // promptSaveLog.checked && !_disableAllDataPersistence
                            property Fact _telemetrySaveNotArmed: QGroundControl.settingsManager.appSettings.telemetrySaveNotArmed
                        }
                        FactCheckBox {
                            id:         promptSaveCsv
                            text:       qsTr("Salvar log CSV de dados de telemetria")
                            fact:       _saveCsvTelemetry
                            visible:    _saveCsvTelemetry.visible
                            enabled:    true // !_disableAllDataPersistence
                            Component.onCompleted: {
                                if (!_saveCsvTelemetry.value) {
                                    _saveCsvTelemetry.value = true
                                }
                            }
                            property Fact _saveCsvTelemetry: QGroundControl.settingsManager.appSettings.saveCsvTelemetry
                        }
                    }

                     Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 7
                        height:                     ScreenTools.defaultFontPixelHeight * 0.581
                        color:                      "transparent"
                    }
                }                
            }
        }
    }
}