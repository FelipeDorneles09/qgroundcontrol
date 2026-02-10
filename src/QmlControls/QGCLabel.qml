import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

Text {
    font.pointSize: ScreenTools.defaultFontPointSize
    font.family:    ScreenTools.normalFontFamily
    color:          qgcPal.text
    antialiasing:   true

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }
}
