/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.3
import QtMultimedia             5.5

import QGroundControl           1.0
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2


import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Palette       1.0

Rectangle {
    id:                 _root
    width:              parent.width
    height:             parent.height
    color:              Qt.rgba(0,0,0,0.75)
    clip:               true
    anchors.centerIn:   parentImage
    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle

    property var    rollValue:  qsTr( "rollValue:" + _activeVehicle.roll.enumOrValueString)
    property var    pitchValue:  qsTr( "pitchValue:" + _activeVehicle.pitch.enumOrValueString)
    property var    altValue:  qsTr( "altValue:" + _activeVehicle.altitudeRelative.enumOrValueString)
    property var    yawValue:  qsTr( "yawValue:" + _activeVehicle.heading.enumOrValueString)
    property var    latGpsValue:  qsTr( "latGpsValue:" + _activeVehicle.gps.lat.enumOrValueString)
    property var    lonGpsValue:  qsTr( "lonGpsValue:" + _activeVehicle.gps.lon.enumOrValueString)
    property var    textImage: qsTr("File Name,Lat (decimal degrees),Lon (decimal degrees),Alt (meters MSL),Roll (decimal degrees),Pitch (decimal degrees),Yaw (decimal degrees)")
    property var    dataImage: latGpsValue + lonGpsValue + altValue + rollValue + pitchValue + yawValue

    property var    rollValue1:  qsTr(_activeVehicle.roll.enumOrValueString + ",")
    property var    pitchValue1:  qsTr( _activeVehicle.pitch.enumOrValueString + ",")
    property var    altValue1:  qsTr( _activeVehicle.altitudeRelative.enumOrValueString + ",")
    property var    yawValue1:  qsTr( _activeVehicle.heading.enumOrValueString)
    property var    latGpsValue1:  qsTr( _activeVehicle.gps.lat.enumOrValueString + ",")
    property var    lonGpsValue1:  qsTr( _activeVehicle.gps.lon.enumOrValueString, ",")
    property var    textImage1: qsTr("File Name,Lat (decimal degrees),Lon (decimal degrees),Alt (meters MSL),Roll (decimal degrees),Pitch (decimal degrees),Yaw (decimal degrees)")
    property var    dataImage1: latGpsValue1 + lonGpsValue1 + altValue1 + rollValue1 + pitchValue1 + yawValue1

    function adjustAspectRatio()
    {
        //-- Set aspect ratio
        var size = camera.viewfinder.resolution
        if(size.height > 0 && size.width > 0) {
            var ar = size.width / size.height
            _root.height = parent.height * ar
        }
    }

//    Item {
//        width: 320
//        height: 510
//        Camera {
//            id: camera
//            imageCapture {
//                onImageCaptured: {
//                    // Show the preview in an Image
//                    photoPreview.source = preview
//                }
//                onImageSaved: {
//                    text.text = qsTr("Last Captured Image (%1):").arg(camera.imageCapture.capturedImagePath)
//                }
//            }
//        }
//        Column {
//            Text {
//                height: 15
//                text: qsTr("Preview (Click to capture):")
//            }
//            VideoOutput {
//                source: camera
//                focus: visible // To receive focus and capture key events when visible
//                width: 320; height: 240
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: camera.imageCapture.capture()
//                }
//            }
//            Text {
//                id: text
//                height: 15
//                text: qsTr("Last Captured Image (none)")
//            }
//            Image {
//                id: photoPreview
//                width: 320; height: 240
//            }
//        }
//    }

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
    Text {
                 height: 15
                 property Fact fact: _activeVehicle.getFact("Vehicle")
                 text: dataImage + camera.imageCapture.capturedImagePath
                }

    Text {
        text: qsTr("Last Captured Image (%1):").arg(camera.imageCapture.capturedImagePath)
        }
    QGCColoredImage {
        anchors.top:                parent.top
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        width:                      height * 0.625
        sourceSize.width:           width
        source:                     "/qmlimages/CameraIcon.svg"
        visible:                    recordBtnBackground.visible
        fillMode:                   Image.PreserveAspectFit
        color:                      "white"
    }
    MouseArea {
        anchors.fill:   parent
        enabled:        true
        onClicked: {

                camera.sourceSize("1280*720")
                camera.imageCapture.capture();
                console.log(camera.imageCapture.capturedImagePath + ","  + dataImage1 )
    }
}
}
