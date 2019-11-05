import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

Rectangle {
    id:                 _manualTestingRoot
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property alias  guidedController:              guidedActionsController
    property bool   activeVehicleJoystickEnabled:  activeVehicle ? activeVehicle.joystickEnabled : false
    property bool   mainIsMap:                     QGroundControl.videoManager.hasVideo ? QGroundControl.loadBoolGlobalSetting(_mainIsMapKey,  true) : true
    property bool   isBackgroundDark:              mainIsMap ? (mainWindow.flightDisplayMap ? mainWindow.flightDisplayMap.isSatelliteMap : true) : true

    property var    _missionController:             _planController.missionController
    property var    _geoFenceController:            _planController.geoFenceController
    property var    _rallyPointController:          _planController.rallyPointController
    property bool   _isPipVisible:                  QGroundControl.videoManager.hasVideo ? QGroundControl.loadBoolGlobalSetting(_PIPVisibleKey, true) : false
    property bool   _useChecklist:                  QGroundControl.settingsManager.appSettings.useChecklist.rawValue && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length
    property real   _savedZoomLevel:                0
    property real   _margins:                       ScreenTools.defaultFontPixelWidth / 2
    property real   _pipSize:                       mainWindow.width * 0.2
    property alias  _guidedController:              guidedActionsController
    property alias _speedSlider: speedSlider

    readonly property var       _dynamicCameras:        activeVehicle ? activeVehicle.dynamicCameras : null
    readonly property bool      _isCamera:              _dynamicCameras ? _dynamicCameras.cameras.count > 0 : false
    readonly property real      _defaultRoll:           0
    readonly property real      _defaultPitch:          0
    readonly property real      _defaultHeading:        0
    readonly property real      _defaultAltitudeAMSL:   0
    readonly property real      _defaultGroundSpeed:    0
    readonly property real      _defaultAirSpeed:       0
    readonly property string    _mapName:               "FlightDisplayView"
    readonly property string    _showMapBackgroundKey:  "/showMapBackground"
    readonly property string    _mainIsMapKey:          "MainFlyWindowIsMap"
    readonly property string    _PIPVisibleKey:         "IsPIPVisible"


//    Row{
//        id:                 buttonRow
//        spacing:            ScreenTools.defaultFontPixelWidth
//        anchors.margins:    ScreenTools.defaultFontPixelWidth
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter

//        QGCButton{
//            id:     wing1
//            text:   qsTr("Test motor")

//            onClicked: {
//                _guidedController.executeAction(22)
//            }
//        }
//        QGCButton{
//            id:     wing2
//            text:   qsTr("Stop testing")
//            onClicked: {
//                _guidedController.executeAction(23)
//            }
//        }


//    }

    MavlinkConsoleController {
        id: conController
    }

    Item{
        id:                                 droneIcon
        anchors.horizontalCenter:           parent.horizontalCenter
        anchors.verticalCenter:             parent.verticalCenter
        readonly property real sin30: 0.5
        readonly property real cos30: 0.866025404
        TestDroneMainIcon{
            anchors.horizontalCenter:   parent.horizontalCenter
            anchors.verticalCenter:     parent.verticalCenter
            id:                         mainDrone
        }
        TestWingIcon{
            anchors.top:        mainDrone.top
            anchors.left:       mainDrone.left
//            anchors.margins:    -_margin
            anchors.leftMargin: mainDrone.width / 2 - wing1.width / 2
            anchors.topMargin: -wing1.height / 2 + mainDrone.height / 22
            id:                 wing1
            textIdWing: "1"
            onClicked: {
                console.log("Menu Test:........... wing 1: clicked!!!")
                console.log("Menu Test:........... wing 1: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 1 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }            
        }
        TestWingIcon{
            anchors.top:            mainDrone.top
            anchors.left:          mainDrone.left
//            anchors.margins:        -_margin
            anchors.leftMargin: (mainDrone.width/2) * droneIcon.cos30 + mainDrone.width/2 - mainDrone.width/24 - wing2.width/2
            anchors.topMargin: mainDrone.height/2 - (mainDrone.height/2) * droneIcon.sin30 - wing2.height/2 + mainDrone.height/44
            id:                     wing2
            textIdWing: "2"
            onClicked: {
                console.log("Menu Test:........... wing 2: clicked!!!")
                console.log("Menu Test:........... wing 2: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 2 -p " + _speedSlider.getSpeedValue())
                    console.log("pwm test -c 2 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }
        }
        TestWingIcon{
            anchors.top:     mainDrone.top
            anchors.left:       mainDrone.left
//            anchors.margins:    -_margin
            anchors.leftMargin: (mainDrone.width/2) * droneIcon.cos30 + mainDrone.width/2 - mainDrone.width/24 - wing3.width/2
            anchors.topMargin: mainDrone.height/2 + (mainDrone.height/2) * droneIcon.sin30 - wing3.height/2 - mainDrone.height/44
            id:                 wing3
            textIdWing: "3"
            onClicked: {
                console.log("Menu Test:........... wing 3: clicked!!!")
                console.log("Menu Test:........... wing 3: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 3 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }
        }
        TestWingIcon{
            anchors.top:         mainDrone.top
            anchors.left:         mainDrone.left
//            anchors.margins:        -_margin
            anchors.leftMargin: mainDrone.width / 2 - wing3.width / 2
            anchors.topMargin: -wing3.height / 2 - mainDrone.height / 22 + mainDrone.height
            id:                     wing4
            textIdWing: "4"
            onClicked: {
                console.log("Menu Test:........... wing 4: clicked!!!")
                console.log("Menu Test:........... wing 4: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 4 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }
        }
        TestWingIcon{
            anchors.top:            mainDrone.top
            anchors.left:          mainDrone.left
//            anchors.margins:        -_margin
            anchors.leftMargin: mainDrone.width/2 - (mainDrone.width/2) * droneIcon.cos30 + mainDrone.width/24 - wing5.width/2
            anchors.topMargin: mainDrone.height/2 - (mainDrone.height/2) * droneIcon.sin30 - wing5.height/2 + mainDrone.height/44
            id:                     wing5
            textIdWing: "5"
            onClicked: {
                console.log("Menu Test:........... wing 5: clicked!!!")
                console.log("Menu Test:........... wing 5: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 5 -p " + _speedSlider.getSpeedValue())
                    console.log("pwm test -c 5 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }
        }
        TestWingIcon{
            anchors.top:     mainDrone.top
            anchors.left:       mainDrone.left
//            anchors.margins:    -_margin
            anchors.leftMargin: -(mainDrone.width/2) * droneIcon.cos30 + mainDrone.width/2 + mainDrone.width/24 - wing6.width/2
            anchors.topMargin: mainDrone.height/2 + (mainDrone.height/2) * droneIcon.sin30 - wing6.height/2 - mainDrone.height/44
            id:                 wing6
            textIdWing: "6"
            onClicked: {
                console.log("Menu Test:........... wing 6: clicked!!!")
                console.log("Menu Test:........... wing 6: running: ", running)

                if(running){
                    conController.sendCommand("pwm test -c 6 -p " + _speedSlider.getSpeedValue())
                }
                else{
                    conController.sendCommand("c")
                }
            }
        }

    }

    GuidedActionsController {
        id:                 guidedActionsController
        missionController:  _missionController
        confirmDialog:      guidedActionConfirm
        actionList:         guidedActionList
        altitudeSlider:     _altitudeSlider
        z:                  _flightVideoPipControl.z + 1

        onShowStartMissionChanged: {
            if (showStartMission) {
                confirmAction(actionStartMission)
            }
        }

        onShowContinueMissionChanged: {
            if (showContinueMission) {
                confirmAction(actionContinueMission)
            }
        }

        onShowLandAbortChanged: {
            if (showLandAbort) {
                confirmAction(actionLandAbort)
            }
        }

        /// Close all dialogs
        function closeAll() {
            guidedActionConfirm.visible = false
            guidedActionList.visible    = false
            altitudeSlider.visible      = false
        }
    }

    //-- Speed slider
    MotorSpeedSlider {
        id:                 speedSlider
        anchors.margins:    _margins
        anchors.right:      parent.right
        anchors.topMargin:  ScreenTools.toolbarHeight + _margins
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        z:                  _guidedController.z
        radius:             ScreenTools.defaultFontPixelWidth / 2
        width:              ScreenTools.defaultFontPixelWidth * 10
        color:              qgcPal.window
        visible:            true
    }
}
