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

Button {
    id:                 button
    height:             ScreenTools.defaultFontPixelHeight * 4
    width:              height
    autoExclusive:      true
    state:              "stop"
    readonly property int _margin: button.width / 4.2
    property string textIdWing
    property bool running: false
    background: Rectangle {
        anchors.fill: parent
        //        color:  logo ? qgcPal.brandingPurple : (checked ? qgcPal.buttonHighlight : Qt.rgba(0,0,0,0))
        color:  checked ? qgcPal.buttonHighlight : Qt.rgba(0,0,0,0)
    }
    Text {
        id: idWing
        text: textIdWing
        color: "white"
    }
    QGCColoredImage {
        anchors.centerIn:       parent
        id:                     _icon
        //            height:                 ScreenTools.defaultFontPixelHeight * 9
        height:                 button.height
        width:                  height
        sourceSize.height:      parent.height
        fillMode:               Image.PreserveAspectFit
        //            color:                  logo ? "white" : (button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText)
        //        color:                  button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText
        color: "#2980b9"
        source:                 "/qmlimages/resources/fan.svg"
    }
    states: [
        State {
            name: "stop"
            when: running == false
            PropertyChanges {
                target: _icon
            }
        },
        State {
            name: "running"
            when: running == true
            PropertyChanges { target: _icon; rotation: 360 }
        }
    ]
    transitions: Transition {
        from: "stop"; to: "running";
        ParallelAnimation {
            NumberAnimation {
                properties:     "rotation"
                duration:       200
                easing.type:    Easing.InOutQuad
                loops:          Animation.Infinite
            }
        }
    }
//    onClicked: {
//        running = !running
//    }
}
