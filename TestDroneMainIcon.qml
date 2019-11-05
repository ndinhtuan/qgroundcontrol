/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick          2.3
import QtQuick.Controls 2.4

import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

Item {
    id:                 button
    height:             ScreenTools.defaultFontPixelHeight * 12
    width:              height

    QGCColoredImage {
        anchors.centerIn:       parent
        id:                     _icon
        //            height:                 ScreenTools.defaultFontPixelHeight * 9
        height:                 button.height
        width:                  height
        sourceSize.height:      parent.height
        fillMode:               Image.PreserveAspectFit
        //            color:                  logo ? "white" : (button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText)
        color:                  button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText
        source:                 "/qmlimages/resources/main_drone.svg"
    }

}
