import QtQuick 2.0
import QtQuick.Controls 1.2

import QGroundControl   1.0
import QGroundControl.Controls   1.0
import QGroundControl.Vehicle   1.0
import QGroundControl.ScreenTools   1.0

Rectangle {
    id: _root
    property QGCSlider qgcSlider: altSlider

    Column {
        id:     headerColumn
        anchors.margins:    _margins
        anchors.top    :    parent.top
        anchors.left   :    parent.left
        anchors.right:  parent.right

        QGCLabel {
            anchors.left:           parent.left
            anchors.right:          parent.right
            wrapMode:               Text.WordWrap
            horizontalAlignment:    Text.AlignHCenter
            text:                   qsTr("New Speed")
        }
    }

    function getSpeedValue(){
        return 1000 + Math.round(1000*altSlider.value)
    }

    QGCSlider {
        id:                 altSlider
        anchors.margins:    _margins
        anchors.top:        headerColumn.bottom
        anchors.bottom:     parent.bottom
        anchors.left:       parent.left
        anchors.right:      parent.right
        orientation:        Qt.Vertical
        minimumValue:       0
        maximumValue:       1
        zeroCentered:       true
        rotation:           180

        // We want slide up to be positive values
        transform: Rotation {
            origin.x:   altSlider.width  / 2
            origin.y:   altSlider.height / 2
            angle:      180
        }

        onValueChanged : {
            if (motorID != 0){
                conController.sendCommand("c")
                conController.sendCommand("pwm test -c " + motorID + " -p " + _speedSlider.getSpeedValue())
                console.log("pwm test -c " + motorID + " -p " + _speedSlider.getSpeedValue())
            }
        }
    }
}
