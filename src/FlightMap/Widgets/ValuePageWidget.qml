/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2
import QtMultimedia     5.5


import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Palette       1.0
import QGroundControl               1.0


/// Value page for InstrumentPanel PageView
Column {
    id:         _largeColumn
    width:      pageWidth
    spacing:    _margins

    property bool showSettingsIcon: true

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle
    property real   _margins:       ScreenTools.defaultFontPixelWidth / 2

    QGCPalette { id:qgcPal; colorGroupEnabled: true }

    ValuesWidgetController {
        id: controller
    }

    function showSettings() {
        mainWindow.showComponentDialog(propertyPicker, qsTr("Value Widget Setup"), mainWindow.showDialogDefaultWidth, StandardButton.Ok)
    }

    function listContains(list, value) {
        for (var i=0; i<list.length; i++) {
            if (list[i] === value) {
                return true
            }
        }
        return false
    }

    Repeater {
        model: _activeVehicle ? controller.largeValues : 0
        Loader {
            sourceComponent: fact ? largeValue : undefined
            property Fact fact: _activeVehicle.getFact(modelData.replace("Vehicle.", ""))
        }
    } // Repeater - Large

    Flow {
        id:                 _smallFlow
        width:              parent.width
        layoutDirection:    Qt.LeftToRight
        spacing:            _margins

        Repeater {
            model: _activeVehicle ? controller.smallValues : 0
            Loader {
                sourceComponent: fact ? smallValue : undefined
                property Fact fact: _activeVehicle.getFact(modelData.replace("Vehicle.", ""))
            }
        } // Repeater - Small
    } // Flow

    Component {
        id: largeValue

        Column {
            width:  _largeColumn.width
            property bool largeValue: listContains(controller.altitudeProperties, fact.name)

            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                wrapMode:               Text.WordWrap
                text:                   fact.shortDescription + (fact.units ? " (" + fact.units + ")" : "")
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize * (largeValue ? 1.3 : 1.0)
                font.family:            largeValue ? ScreenTools.demiboldFontFamily : ScreenTools.normalFontFamily
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.enumOrValueString
            }
        }
    }

    Component {
        id: smallValue

        Column {
            width:  (pageWidth / 2) - (_margins / 2) - 0.1
            clip:   true

            QGCLabel {
                width:                  parent.width
                wrapMode:               Text.WordWrap
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.isTinyScreen ? ScreenTools.smallFontPointSize * 0.75 : ScreenTools.smallFontPointSize
                text:                   fact.shortDescription
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.enumOrValueString
            }
            QGCLabel {
                width:                  parent.width
                horizontalAlignment:    Text.AlignHCenter
                font.pointSize:         ScreenTools.isTinyScreen ? ScreenTools.smallFontPointSize * 0.75 : ScreenTools.smallFontPointSize
                fontSizeMode:           Text.HorizontalFit
                text:                   fact.units
            }
        }
    }

    Component {
        id: propertyPicker

        QGCViewDialog {
            id: _propertyPickerDialog

            QGCFlickable {
                anchors.fill:       parent
                contentHeight:      column.height
                flickableDirection: Flickable.VerticalFlick
                clip:               true

                Column {
                    id:             column
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    spacing:        _margins

                    /*
                      Leaving this here for now just in case
                    FactCheckBox {
                        text:       qsTr("Show large compass")
                        fact:       _showLargeCompass
                        visible:    _showLargeCompass.visible

                        property Fact _showLargeCompass: QGroundControl.settingsManager.appSettings.showLargeCompass
                    }
                    */

                    Item {
                        width:  1
                        height: _margins
                    }

                    QGCLabel {
                        id:     _label
                        anchors.left:   parent.left
                        anchors.right:  parent.right
                        wrapMode:       Text.WordWrap
                        text:   qsTr("Select the values you want to display:")
                    }

                    Loader {
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        sourceComponent:    factGroupList

                        property var    factGroup:     _activeVehicle
                        property string factGroupName: "Vehicle"
                    }

                    Repeater {
                        model: _activeVehicle.factGroupNames

                        Loader {
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            sourceComponent:    factGroupList

                            property var    factGroup:     _activeVehicle.getFactGroup(modelData)
                            property string factGroupName: modelData
                        }

                    }
                }
            }
        }
    }

    Component {
        id: factGroupList

        // You must push in the following properties from the Loader
        // property var factGroup
        // property string factGroupName

        Column {
            spacing:    _margins

            SectionHeader {
                id:             header
                anchors.left:   parent.left
                anchors.right:  parent.right
                text:           factGroupName.charAt(0).toUpperCase() + factGroupName.slice(1)
                checked:        false
            }

            Column {
                spacing:    _margins
                visible:    header.checked

                Repeater {
                    model: factGroup ? factGroup.factNames : 0

                    RowLayout {
                        spacing: _margins
                        visible: factGroup.getFact(modelData).shortDescription !== ""

                        property string propertyName: factGroupName + "." + modelData

                        function removeFromList(list, value) {
                            var newList = []
                            for (var i=0; i<list.length; i++) {
                                if (list[i] !== value) {
                                    newList.push(list[i])
                                }
                            }
                            return newList
                        }

                        function addToList(list, value) {
                            var found = false
                            for (var i=0; i<list.length; i++) {
                                if (list[i] === value) {
                                    found = true
                                    break
                                }
                            }
                            if (!found) {
                                list.push(value)
                            }
                            return list
                        }

                        function updateValues() {
                            if (_addCheckBox.checked) {
                                if (_largeCheckBox.checked) {
                                    controller.largeValues = addToList(controller.largeValues, propertyName)
                                    controller.smallValues = removeFromList(controller.smallValues, propertyName)
                                } else {
                                    controller.smallValues = addToList(controller.smallValues, propertyName)
                                    controller.largeValues = removeFromList(controller.largeValues, propertyName)
                                }
                            } else {
                                controller.largeValues = removeFromList(controller.largeValues, propertyName)
                                controller.smallValues = removeFromList(controller.smallValues, propertyName)
                            }
                        }

                        QGCCheckBox {
                            id:                     _addCheckBox
                            text:                   factGroup.getFact(modelData).shortDescription
                            checked:                listContains(controller.smallValues, propertyName) || _largeCheckBox.checked
                            onClicked:              updateValues()
                            Layout.fillWidth:       true
                            Layout.minimumWidth:    ScreenTools.defaultFontPixelWidth * 20

                            Component.onCompleted: {
                                if (checked) {
                                    header.checked = true
                                }
                            }
                        }

                        QGCCheckBox {
                            id:                     _largeCheckBox
                            text:                   qsTr("Large")
                            checked:                listContains(controller.largeValues, propertyName)
                            enabled:                _addCheckBox.checked
                            onClicked:              updateValues()
                        }
                    }
                }
            }
        }
    }

    //-- Video Recording
    property bool   _communicationLost:     activeVehicle ? activeVehicle.connectionLost : false
    property var    _videoReceiver:         QGroundControl.videoManager.videoReceiver
    property bool   _recordingVideo:        _videoReceiver && _videoReceiver.recording
    property bool   _videoRunning:          _videoReceiver && _videoReceiver.videoRunning
    property bool   _streamingEnabled:      QGroundControl.settingsManager.videoSettings.streamConfigured
    property var    _dynamicCameras:        activeVehicle ? activeVehicle.dynamicCameras : null
    property int    _curCameraIndex:        _dynamicCameras ? _dynamicCameras.currentCamera : 0
    property bool   _isCamera:              _dynamicCameras ? _dynamicCameras.cameras.count > 0 : false
    property var    _camera:                _isCamera ? (_dynamicCameras.cameras.get(_curCameraIndex) && _dynamicCameras.cameras.get(_curCameraIndex).paramComplete ? _dynamicCameras.cameras.get(_curCameraIndex) : null) : null

    QGCLabel {
       text:            _recordingVideo ? qsTr("Stop Recording") : qsTr("Record Stream")
       font.pointSize:  ScreenTools.smallFontPointSize
       visible:         (!_camera || !_camera.autoStream) && QGroundControl.settingsManager.videoSettings.showRecControl.rawValue
    }
    // Button to start/stop video recording
    Item {
        anchors.margins:    ScreenTools.defaultFontPixelHeight / 2
        height:             ScreenTools.defaultFontPixelHeight * 2
        width:              height
        Layout.alignment:   Qt.AlignHCenter
        visible:            (!_camera || !_camera.autoStream) && QGroundControl.settingsManager.videoSettings.showRecControl.rawValue
        Rectangle {
            id:                 recordBtnBackground
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            width:              height
            radius:             _recordingVideo ? 0 : height
            color:              "red"
            SequentialAnimation on opacity {
                running:        _recordingVideo
                loops:          Animation.Infinite
                PropertyAnimation { to: 0.5; duration: 500 }
                PropertyAnimation { to: 1.0; duration: 500 }
            }
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
                     QGroundControl.videoManager.uvcEnabled = false ;
            }
        }
    }
}
