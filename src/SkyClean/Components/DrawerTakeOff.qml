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
import QGroundControl.ScreenTools   1.0			
import QGroundControl.Vehicle       				
import SiYi.Object                  				
import QGroundControl.SkyClean                      

Item{
    id:                                             root 
    width:                                          parent.width 
    height:                                         parent.height 

    // private 

    QGCPalette { id: qgcPal } 

    Loader{
        id:                                         controllerLoader
        active:                                     _initialDownloadComplete 
        sourceComponent:                            factParameters 
    }

    Component{
        id:                                         factParameters
        FactPanelController {
            id:                                     controller
        }
    }

    Rectangle{
        id:                                         rectangleId
        width:                                      600
        height:                                     parent.height 
        color:                                      qgcPal.iconColor 
        x:                                          visible ? 0 : -width 
        anchors{
            bottomMargin:                           20
        }
        
        Behavior on x{
            PropertyAnimation{
                duration:                           500
                easing.type:                        Easing.InOutQuad
            }
        }

        // Closed
        Rectangle{
            id:                                     close 
            width:                                  100
            height:                                 100 
            color:                                  qgcPal.iconColor 
            radius:                                 80
            border.width:                           1.266
            border.color:                           qgcPal.textColor
            z:                                      20
            anchors{
                top:                                parent.top 
                topMargin:                          5
                right:                              parent.right 
                rightMargin:                        -40
            }
            Text{
                text:                               "X"
                color:                              qgcPal.textColor
                font.bold:                          true 
                font.pointSize:                     16 
                anchors.centerIn:                   parent
            }
            MouseArea{
                anchors.fill:                       parent 
                onClicked:{
                    root.visible = false
                }
            }
        }

        QGCFlickable {
            clip:                                   true
            anchors.fill:                           parent
            contentHeight:                          outerColumn.height
            contentWidth:                           outerColumn.width 

            Column{
                id:                                 outerColumn
                spacing:                            60
                anchors{            
                    left:                           parent.left 
                    leftMargin:                     15
                    top:                            parent.top
                    topMargin:                      30
                }
                Text{
                    text:                           qsTr("Orientação")
                    color:                          qgcPal.textColor
                    font.bold:                      true 
                    wrapMode:                       "WordWrap"
                }

                //  LARGURA DE FAIXA 
                Column{ 
                    spacing:                        20
                        Text{
                        text:                       qsTr("Largura de faixa")
                        color:                      qgcPal.textColor
                        font.bold:                  true 
                        wrapMode:                   "WordWrap"
                    }
                
                    Row{
                        spacing:                    30
                        
                        // subtração 
                        ButtonOp{
                            setWidth:               75
                            setHeight:              75
                            setOperator:            "-"
                        }
                        // valores
                        Text{
                            text:                   "0.0"
                            font.bold:              true 
                            font.pointSize:         16
                            color:                  qgcPal.textColor
                            anchors.bottom:         parent.bottom
                        }
                        // adição 
                        ButtonOp{
                            setWidth:               75
                            setHeight:              75
                            setOperator:            "+"
                        }
                    }
                }

                // REPETIÇÃO DE LINHA
                //  LARGURA DE FAIXA 
                Column{ 
                    spacing:                        20
                        Text{
                        text:                       qsTr("Repetir Linha")
                        color:                      qgcPal.textColor
                        font.bold:                  true 
                        wrapMode:                   "WordWrap"
                    }
                
                    Row{
                        spacing:                    30
                        
                        Rectangle {
                            id:                     barraMunicao
                            width:                  550
                            height:                 50
                            color:                  "transparent" //qgcPal.cleanColor
                            border.color:           qgcPal.cleanColor
                            border.width:           7
                            radius:                 100

                            // Círculo representando a esfera (será movido na barra)
                            Rectangle {
                                id:                 esfera
                                width:              60
                                height:             60
                                color:              qgcPal.cleanColor
                                radius:             width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                x:                  calcularPosicaoEsfera()
                                
                                Text {
                                    id:             valorTexto
                                    text:           bandejaFront.valorMunicao.toString()
                                    font.bold:      true 
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                    color:          qgcPal.iconColor
                                }
                                MouseArea {
                                    id:             dragArea
                                    anchors.fill:   parent
                                    drag.target:    esfera
                                    enabled:        _activeVehicle ? !_activeVehicle.armed : true
                                    onPositionChanged: {
                                        if (esfera.x < 0) {
                                            esfera.x = 0;
                                        } else if (esfera.x > barraMunicao.width - esfera.width) {
                                            esfera.x = barraMunicao.width - esfera.width;
                                        }

                                        var percentagem = esfera.x / (barraMunicao.width - esfera.width);
                                        var valor = Math.round(percentagem * 6);

                                        if (valor >= 0 && valor <= 6) {
                                            valorTexto.text = valor.toString();
                                            bandejaFront.valorMunicao = valor;
                                        }
                                    }
                                }
                            }

                            function calcularPosicaoEsfera() {
                                return (barraMunicao.width - esfera.width) * (bandejaFront.valorMunicao / 12);
                            }

                            function atualizarValorEsfera(valor) {
                                bandejaFront.valorMunicao = valor;
                                esfera.x = calcularPosicaoEsfera();
                                valorTexto.text = valor.toString();
                            }
                        }
                    }
                }

                //  VELOCIDADE
                Column{
                    spacing:                        40
                        Text{
                        text:                           qsTr("Velocidade (m/s)")
                        color:                          qgcPal.textColor
                        font.bold:                      true 
                        wrapMode:                       "WordWrap"
                    }
                
                    Row{
                        spacing:                        30
                        // subtração 
                        ButtonOp{
                            setWidth:                   75
                            setHeight:                  75
                            setOperator:                    "-"
                        }
                        // valores
                        Text{
                            text:                       "0.0"
                            font.bold:                  true 
                            font.pointSize:             16
                            color:                      qgcPal.textColor
                            anchors.bottom:             parent.bottom
                        }
                        // adição 
                        ButtonOp{
                            setWidth:                   75
                            setHeight:                  75
                            setOperator:                    "+"
                        }
                    }
                }

                //  Distância
                Column{
                    spacing:                        40
                    Text{
                        text:                           qsTr("Distância do drone (cm)")
                        color:                          qgcPal.textColor
                        font.bold:                      true 
                        wrapMode:                       "WordWrap"
                    }
                
                    Row{
                        spacing:                        30
                        // subtração 
                        ButtonOp{
                            setWidth:                   75
                            setHeight:                  75
                            setOperator:                "-"
                        }
                        // valores
                        Text{
                            text:                       "0.0"
                            font.bold:                  true 
                            font.pointSize:             16
                            color:                      qgcPal.textColor
                            anchors.bottom:             parent.bottom
                        } 
                        // adição 
                        ButtonOp{
                            setWidth:                   75
                            setHeight:                  75
                            setOperator:                "+"
                        }
                    }
                }

                Button {
                    id:                             btn
                    width:                          550
                    height:                         100

                    Rectangle {
                        id:                         progressBar
                        width:                      0
                        height:                     parent.height
                        color:                      "green"
                        radius:                     20
                        anchors.left:               parent.left
                        border.color:               "green"
                    }

                    background: Rectangle {
                        color: btn.down ? "#FFFFFF" : "green"
                        radius:                     20
                        border.color:               "green"
                    }

                    Text {
                        text:                       qsTr("Iniciar automação")
                        color:                      btn.down ? "#FFFFFF" : "#FFFFFF"
                        font.bold:                  true
                        anchors.centerIn:           parent
                        anchors.bottom:             parent.bottom
                    }

                    onPressed: {
                        progressTimer.start()
                        closed.start()
                    }

                    onReleased: {
                        progressTimer.stop()
                        progressBar.width = 0
                        closed.stop()
                    }

                    Timer {
                        id:                         progressTimer
                        interval:                   2000
                        running:                    false
                        repeat:                     false
                        onTriggered: {
                            progressBar.width = btn.width
                        }

                        onRunningChanged: if (!running) {
                            progressBar.width = btn.width * progressTimer.elapsed / progressTimer.interval;
                        }

                    }

                    Timer{
                        id:                         closed
                        interval:                   3000
                        running:                    false 
                        repeat:                     false 
                        onTriggered: {
                            root.visible = false ;
                        }
                    }

                    PropertyAnimation {
                        target:                     progressBar
                        property:                   "width"
                        to:                         btn.width
                        duration:                   2000
                        running:                    btn.down
                    }
                }
                Rectangle{
                    width:                          100
                    height:                         30
                    color:                          "transparent"
                }
                
            }
        }
    }
}
