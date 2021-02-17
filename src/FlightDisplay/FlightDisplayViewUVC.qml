/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.3
import QtMultimedia             5.5
//import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QGroundControl           1.0

Rectangle {
    id:                 _root
    width:              parent.width
    height:             parent.height
    color:              Qt.rgba(0,0,0,0.75)
    clip:               true
    anchors.centerIn:   parent
    property int numGridRow: 3
    property int numGridCol: 5
    function adjustAspectRatio()
    {
        //-- Set aspect ratio
        var size = camera.viewfinder.resolution
        if(size.height > 0 && size.width > 0) {
            var ar = size.width / size.height
            _root.height = parent.height * ar
        }
    }

    Camera {
        id:             camera
        deviceId:       QGroundControl.videoManager.videoSourceID
        captureMode:    Camera.CaptureViewfinder
        onDeviceIdChanged: {
            adjustAspectRatio()
        }
        onCameraStateChanged: {
            if(camera.cameraStatus === Camera.ActiveStatus) {
                adjustAspectRatio()
            }
        }
    }
    VideoOutput {
        source:         camera
        anchors.fill:   parent
        fillMode:       VideoOutput.PreserveAspectCrop
        visible:        !QGroundControl.videoManager.isGStreamer
    }
    onVisibleChanged: {
        if(visible)
            camera.start()
        else
            camera.stop()
    }


//    GridLayout {
//        id:     gridLayout
//        flow:   GridLayout.TopToBottom
//        rows:   720

//        property int dynamicRows: 10


//    }
    MouseArea {
      property vector2d dragStart
      acceptedButtons: Qt.LeftButton
      anchors.fill: parent
      onPressed: {
        dragStart = Qt.vector2d(mouseX, mouseY)
      }
      onReleased: {
        mouseRect.height = 0;
      }
      onPositionChanged: {
        if(pressed) {
          mouseRect.x = Math.min(mouseX, dragStart.x)
          mouseRect.width = Math.abs(mouseX - dragStart.x)
          mouseRect.y = Math.min(mouseY, dragStart.y)
          mouseRect.height = Math.abs(mouseY - dragStart.y)
        }
      }
    }

    Rectangle {
      id: mouseRect
      color: "#808080ff"
    }

    Column {
      anchors.fill: parent
      Repeater {
        model: _root.numGridRow
        Rectangle {
          width: _root.width
          height: _root.height / _root.numGridRow
          color: "transparent"
          border {
            color: "black"
            width: 1
          }
        }
      }
    }

    Row {
      anchors.fill: parent
      Repeater {
        model: _root.numGridCol
        Rectangle {
          width: _root.width / _root.numGridCol
          height: _root.height
          color: "transparent"
          border {
            color: "black"
            width: 1
          }
        }
      }
    }

//    Grid {
//      columns: root.numGridCol
//      Repeater {
//        model: root.numGridCol * root.numGridRow
//        Rectangle {
//          width: root.width / root.numGridCol
//          height: root.height / root.numGridRow
//          color: "transparent"
//          border {
//            color: "black"
//            width: 1
//          }
//          MouseArea {
//            anchors.fill: parent
//            onClicked: {
//              console.log(index)
//            }
//          }
//        }
//      }
//    }

}
//    Rectangle {
//        id: root
//        anchors.fill: parent
//        color: "#ccc"

//        TextArea {
//          anchors.centerIn: parent
//          text: "TEXT BEHIND GRID"
//          font.pointSize: 24
//          style: TextAreaStyle {
//            textColor: "darkblue"
//            backgroundColor: "gray"
//          }
//        }

//        property int numGridRow: 80
//        property int numGridCol: 20


//    }
