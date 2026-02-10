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
import QGroundControl.Airspace      				
import QGroundControl.Airmap        				
import QGroundControl.Controllers   				
import QGroundControl.Controls      				
import QGroundControl.FactSystem    				
import QGroundControl.FlightDisplay 				
import QGroundControl.FlightMap     				
import QGroundControl.Palette       				
import QGroundControl.ScreenTools 1.0
import QGroundControl.Vehicle       				
import SiYi.Object                  				
import Qt5Compat.GraphicalEffects                        

Rectangle{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 
    color:                                          "transparent"

    // Called when the calibration access password is provided by the user.
    // Replace the body with real validation if you have one; by default
    // it simply opens the setup tool.
    function performCalibrationAccess(password) {
        // TODO: validate `password` here (call backend / controller if needed)
        mainWindow.showSetupTool()
    }

    QGCPalette { id:qgcPal }

    Rectangle{
        id:                                         settings 
        width:                                      ScreenTools.defaultFontPixelWidth * 45.5
        height:                                     parent.height 
        color:                                      qgcPal.iconColor
        x:                                          visible ? Math.min(ScreenTools.defaultFontPixelWidth * 9.8, 180) : -width 
        z:                                          10

        Behavior on x{
            PropertyAnimation{
                duration:                           500
                easing:                             Easing.InOutQuad
            }
        }

        QGCFlickable {
            clip:                                   true
            anchors.fill:                           parent
            contentHeight:                          outerColumn.height
           
            
            Column{
                id:                                 outerColumn
                spacing:                            ScreenTools.defaultFontPixelHeight * 0.875
                anchors{
                    left:                           parent.left 
                    leftMargin:                     ScreenTools.defaultFontPixelWidth * 2.1
                    top:                            parent.top
                    topMargin:                      ScreenTools.defaultFontPixelHeight * 0.294
                }
                Text{
                    text:                           qsTr("Ajustes")
                    color:                          qgcPal.textColor
                    font.bold:                      true 
                    wrapMode:                       "WordWrap"
                }

                Column{
                    spacing:                        30


                    Text{
                        text:                       qsTr("Distância Horizontal")
                        font.italic:                true  
                        color:                      qgcPal.textColor                      
                    }                    
                    DropView{
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.191
                        fact:                       QGroundControl.settingsManager.unitsSettings.horizontalDistanceUnits
                    }

                    // --- LINE --- 
                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }  

                    /* Distância Vertical */
                    Text{
                        text:                       qsTr("Distância Vertical")
                        font.italic:                true  
                        color:                      qgcPal.textColor                      
                    }                    
                    DropView{
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.191
                        fact:                       QGroundControl.settingsManager.unitsSettings.verticalDistanceUnits
                    }   

                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }  

                    /* Area */
                    Text{
                        text:                       qsTr("Área")
                        font.italic:                true  
                        color:                      qgcPal.textColor                      
                    }                    
                    DropView{
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.191
                        fact:                       QGroundControl.settingsManager.unitsSettings.areaUnits
                    }

                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }  

                    /* Velôcidade */
                    Text{
                        text:                       qsTr("Velocidade")
                        font.italic:                true   
                        color:                      qgcPal.textColor                     
                    }                    
                    DropView{
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.191
                        fact:                       QGroundControl.settingsManager.unitsSettings.speedUnits
                    }

                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }  

                    /* Temperatura */
                    Text{
                        text:                       qsTr("Temperatura")
                        font.italic:                true  
                        color:                      qgcPal.textColor                      
                    }                    
                    DropView{
                        setWidth:                   ScreenTools.defaultFontPixelWidth * 40.6
                        setHeight:                  ScreenTools.defaultFontPixelHeight * 2.191
                        fact:                       QGroundControl.settingsManager.unitsSettings.temperatureUnits
                    }   

                    Rectangle{
                        width:                      ScreenTools.defaultFontPixelWidth * 42
                        height:                     ScreenTools.defaultFontPixelHeight * 0.0875
                        color:                      qgcPal.textColor
                    }  

                    Row{
                        spacing:                        ScreenTools.defaultFontPixelWidth * 0.7
                        ButtonAction{
                            setWidth:                   ScreenTools.defaultFontPixelWidth * 16.38
                            setHeight:                  ScreenTools.defaultFontPixelHeight * 2.156
                            setText:                    qsTr("Calibrar")
                            onClicked:{
                                mainWindow.showPopupDialogFromComponent(calibratePasswordDialogComponent)
                            }
                        } 
                        Rectangle{
                            width:                      ScreenTools.defaultFontPixelWidth * 7
                            height:                     ScreenTools.defaultFontPixelHeight * 2.919
                            color:                      "transparent"
                        }
                    }

                    Component {
                        id: calibratePasswordDialogComponent

                        QGCPopupDialog {
                            id: calibratePasswordDialog
                            title: qsTr("Senha requerida")
                            buttons: StandardButton.None

                            // generatedPassword follows same rule as in APMSensorsComponent.qml
                            property string generatedPassword: {
                                var d = new Date()
                                function pad(n) { return n < 10 ? '0' + n : '' + n }
                                return 'vant' + pad(d.getDate()) + pad(d.getMonth() + 1)
                            }

                            ColumnLayout {
                                anchors.margins: ScreenTools.defaultFontPixelWidth

                                QGCLabel {
                                    wrapMode: Text.WordWrap
                                    text: qsTr("Para prosseguir com a calibração insira a senha de acesso.")
                                }

                                TextField {
                                    id: pwdInput
                                    placeholderText: qsTr("Digite a senha")
                                    font.pointSize: ScreenTools.defaultFontPixelSize * 1.25
                                    echoMode: TextInput.Password
                                    focus: true
                                    Layout.fillWidth: true
                                }

                                QGCLabel {
                                    id: errorLabel
                                    color: "red"
                                    visible: false
                                    text: qsTr("Senha incorreta")
                                }

                                RowLayout {
                                    spacing: ScreenTools.defaultFontPixelWidth

                                    QGCButton {
                                        text: qsTr("Confirmar")
                                        onClicked: {
                                            errorLabel.visible = false
                                            if (pwdInput.text.length === 0) {
                                                errorLabel.text = qsTr("Insira a senha")
                                                errorLabel.visible = true
                                                return
                                            }

                                            if (pwdInput.text === calibratePasswordDialog.generatedPassword) {
                                                root.performCalibrationAccess(pwdInput.text)
                                                hideDialog()
                                            } else {
                                                errorLabel.text = qsTr("Senha incorreta")
                                                errorLabel.visible = true
                                            }
                                        }
                                    }

                                    QGCButton {
                                        text: qsTr("Cancelar")
                                        onClicked: {
                                            hideDialog()
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
}