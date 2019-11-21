import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.2

import QGroundControl   1.0
import QGroundControl.Controls   1.0
import QGroundControl.Vehicle   1.0
import QGroundControl.ScreenTools   1.0

Rectangle {
    id: _root
    property QGCSlider qgcSlider: altSlider
    property bool isStart: false

    Column {
        id:     headerColumn
        anchors.margins:    _margins
        anchors.top    :    parent.top
        anchors.left   :    parent.left
        anchors.right:  parent.right

        QGCLabel {
            id  : status
            anchors.left:           parent.left
            anchors.right:          parent.right
            wrapMode:               Text.WordWrap
            horizontalAlignment:    Text.AlignHCenter
            text:                   "Stop"
        }

        GridLayout {
            columns: 2
            columnSpacing: 6
            anchors.right: parent.right

            QGCButton {
                height:             _buttonHeight
                text:               qsTr("Start")

                Layout.fillWidth:   true
                onClicked: {
                    if(isStart){
                        return
                    }

                    doRotatingMotors()
                    isStart = true
                    status.text = "Start"
                }
            }
            QGCButton {
                height:             _buttonHeight
                text:               qsTr("Stop")
                Layout.fillWidth:   true
                onClicked: {
//                    if(!isStart){
//                        return
//                    }

                    isStart = false
                    resetRotatingMotors()
                    status.text = "Stop"
                }
            }
        }

        QGCLabel {
            id: textSlider
            anchors.left:           parent.left
            anchors.right:          parent.right
            wrapMode:               Text.WordWrap
            horizontalAlignment:    Text.AlignHCenter
            text:                   "Speed " +_speedSlider.getSpeedValue()
        }
    }

    function getSpeedValue(){ //[1000, 1500]
        return 1000 + Math.round(500*altSlider.value)
//        return Math.round(altSlider.value)
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

        onValueChanged:{
            textSlider.text = "Speed " + _speedSlider.getSpeedValue()
        }

        onPressedChanged : {

            textSlider.text = "Speed " + _speedSlider.getSpeedValue()
            if(!isStart || pressed){
                return
            }
            doRotatingMotors()
        }
    }
}
