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

Rectangle{
    id:                             root 
    width:                          parent.width 
    height:                         parent.height 
    color:                          "transparent"

    //private 
    property var    _currentSelection:  null

    property string mapKey:             "lastMapType"

    property var    _settingsManager:   QGroundControl.settingsManager
    property var    _settings:          _settingsManager ? _settingsManager.offlineMapsSettings : null
    property var    _fmSettings:        _settingsManager ? _settingsManager.flightMapSettings : null
    property Fact   _mapboxFact:        _settingsManager ? _settingsManager.appSettings.mapboxToken : null
    property Fact   _mapboxAccountFact: _settingsManager ? _settingsManager.appSettings.mapboxAccount : null
    property Fact   _mapboxStyleFact:   _settingsManager ? _settingsManager.appSettings.mapboxStyle : null
    property Fact   _esriFact:          _settingsManager ? _settingsManager.appSettings.esriToken : null
    property Fact   _customURLFact:     _settingsManager ? _settingsManager.appSettings.customURL : null
    property Fact   _vworldFact:        _settingsManager ? _settingsManager.appSettings.vworldToken : null

    property string mapType:            _fmSettings ? (_fmSettings.mapProvider.value + " " + _fmSettings.mapType.value) : ""
    property bool   isMapInteractive:   false
    property var    savedCenter:        undefined
    property real   savedZoom:          3
    property string savedMapType:       ""
    property bool   _showPreview:       true
    property bool   _defaultSet:        offlineMapView && offlineMapView._currentSelection && offlineMapView._currentSelection.defaultSet
    property real   _margins:           ScreenTools.defaultFontPixelWidth * 0.5
    property real   _buttonSize:        ScreenTools.defaultFontPixelWidth * 12
    property real   _bigButtonSize:     ScreenTools.defaultFontPixelWidth * 16

    property bool   _saveRealEstate:          ScreenTools.isTinyScreen || ScreenTools.isShortScreen
    property real   _adjustableFontPointSize: _saveRealEstate ? ScreenTools.smallFontPointSize : ScreenTools.defaultFontPointSize

    property var    _mapAdjustedColor:  _map.isSatelliteMap ? "white" : "black"
    property bool   _tooManyTiles:      QGroundControl.mapEngineManager.tileCount > _maxTilesForDownload

    readonly property real minZoomLevel:    1
    readonly property real maxZoomLevel:    20
    readonly property real sliderTouchArea: ScreenTools.defaultFontPixelWidth * (ScreenTools.isTinyScreen ? 5 : (ScreenTools.isMobile ? 6 : 3))

    readonly property int _maxTilesForDownload: _settings ? _settings.maxTilesForDownload.rawValue : 0

    QGCPalette { id:qgcPal }

        function addNewSet() {
            isMapInteractive = true
            mapType = _fmSettings.mapProvider.value + " " + _fmSettings.mapType.value
            resetMapToDefaults()
            handleChanges()
            _map.visible = true
            _tileSetList.visible = false
            infoView.visible = false
            _exporTiles.visible = false
            addNewSetView.visible = true
        }

    Rectangle{
        id:                                 settings 
        width:                              600
        height:                             parent.height 
        color:                              qgcPal.iconColor
        x:                                  visible ? 150 : -width 
        z:                                  5

        Behavior on x{
            PropertyAnimation{
                duration:                   500
                easing:                     Easing.InOutQuad
            }
        }

        Column{
            id:                     outerColumn
            spacing:                100
            anchors{
                left:               parent.left 
                leftMargin:         10
                top:                parent.top
                topMargin:          10
            }
            Text{
                text:                           qsTr("Baixar Mapa")
                color:                          qgcPal.textColor
                font.bold:                      true 
                wrapMode:                       "WordWrap"
            }

            Column{
                
                OfflineMapButton {
                    id:             firstButton
                    text:           qsTr("Add New Set")
                    width:          _cacheList.width
                    height:         ScreenTools.defaultFontPixelHeight * (ScreenTools.isMobile ? 3 : 2)
                    currentSet:     _currentSelection
                    onClicked: {
                        //offlineMapView._currentSelection = null
                        checked = true
                        addNewSet()
                    }
                }
            }
        }
    }
}