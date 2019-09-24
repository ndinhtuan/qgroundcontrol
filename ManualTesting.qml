import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

Rectangle {
    id:                 _manualTestingRoot
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    Row{
        id:                 buttonRow
        spacing:            ScreenTools.defaultFontPixelWidth
        anchors.margins:    ScreenTools.defaultFontPixelWidth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        QGCButton{
            id:     wing1
            text:   qsTr("Wing 1")
        }
        QGCButton{
            id:     wing2
            text:   qsTr("Wing 2")
        }
    }
}
