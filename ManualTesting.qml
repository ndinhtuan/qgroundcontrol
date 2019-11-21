import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts 1.2

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
    property int motorID: 0

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
    property var motorIDs : [false, false, false, false, false, false]
    property var threshMeasurings: [1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900]
    property int oldSliderValue: 0
    property int threshChangeSliderValue: 30
    property bool firstDoingRotating: true

    function getRotatingMotors(){
        var s = ""
        for(var i = 0; i < motorIDs.length; i++){
            if(motorIDs[i]){
                s += i + 1
            }
        }

        return s
    }

    function resetRotatingMotors(){
        motorIDs = [false, false, false, false, false, false]
        wing1.running = false
        wing2.running = false
        wing3.running = false
        wing4.running = false
        wing5.running = false
        wing6.running = false
        conController.sendCommand("c")
        firstDoingRotating = true
    }

    function doRotatingMotors(){
        var s = getRotatingMotors()

        if(s === "") {
            conController.sendCommand("c")
            console.log("Only send 'c' command")
            return
        }

        var currentSpeedSlider = _speedSlider.getSpeedValue()
        if (!firstDoingRotating && Math.abs(currentSpeedSlider - oldSliderValue) < threshChangeSliderValue){

            return
        }
        if (firstDoingRotating){
            firstDoingRotating = false;
        }

        oldSliderValue = currentSpeedSlider

        conController.sendCommand("c")
        conController.sendCommand("pwm test -c " + s + " -p " + currentSpeedSlider)
        console.log("pwm test -c " + s + " -p " + currentSpeedSlider)
    }

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

                if (speedSlider.isStart){
                    return
                }

                running = !running
                console.log("Menu Test:........... wing 1: clicked!!!")
                console.log("Menu Test:........... wing 1: running: ", running)

                if(running){
                    //conController.sendCommand("pwm test -c " + rotatingMotor + " -p " + _speedSlider.getSpeedValue())
                    //motorID = 1
                    motorIDs[0] = true
                }
                else{
                    //conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[0] = false
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

                if (speedSlider.isStart){
                    return
                }

                running = !running

                console.log("Menu Test:........... wing 2: clicked!!!")
                console.log("Menu Test:........... wing 2: running: ", running)


                if(running){
                   //conController.sendCommand("pwm test -c 2 -p " + _speedSlider.getSpeedValue())
//                    console.log("pwm test -c 2 -p " + _speedSlider.getSpeedValue())
                    //motorID = 2
                    motorIDs[1] = true
                }
                else{
                    conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[1] = false
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

                if (speedSlider.isStart){
                    return
                }

                running = !running
                console.log("Menu Test:........... wing 3: clicked!!!")
                console.log("Menu Test:........... wing 3: running: ", running)

                if(running){
                    //conController.sendCommand("pwm test -c 3 -p " + _speedSlider.getSpeedValue())
                    //motorID = 3
                    motorIDs[2] = true
                }
                else{
                    //conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[2] = false
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

                if (speedSlider.isStart){
                    return
                }

                running = !running

                console.log("Menu Test:........... wing 4: clicked!!!")
                console.log("Menu Test:........... wing 4: running: ", running)

                if(running){
                    //conController.sendCommand("pwm test -c 4 -p " + _speedSlider.getSpeedValue())
                    //motorID = 4
                    motorIDs[3] = true
                }
                else{
                    //conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[3] = false
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

                if (speedSlider.isStart){
                    return
                }

                running = !running

                console.log("Menu Test:........... wing 5: clicked!!!")
                console.log("Menu Test:........... wing 5: running: ", running)

                if(running){
                    //conController.sendCommand("pwm test -c 5 -p " + _speedSlider.getSpeedValue())
//                    console.log("pwm test -c 5 -p " + _speedSlider.getSpeedValue())
                    //motorID = 5
                    motorIDs[4] = true
                }
                else{

                    //conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[4] = false
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

                if (speedSlider.isStart){
                    return
                }

                running = !running

                console.log("Menu Test:........... wing 6: clicked!!!")
                console.log("Menu Test:........... wing 6: running: ", running)

                if(running){
                    //conController.sendCommand("pwm test -c 6 -p " + _speedSlider.getSpeedValue())
                    //motorID = 6
                    motorIDs[5] = true
                }
                else{
                    //conController.sendCommand("c")
                    //motorID = 0
                    motorIDs[5] = false
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

    // InformationDrone
    InformationDrone{
        id:     inforDrone
        anchors.top:    parent.top
        anchors.left: parent.left
        height: 250
    }

    // Measuring threshold threst for motor
    Text{
        text: "Measuring: "
        anchors.bottom: threshMeasuringValues.top
        anchors.left: threshMeasuringValues.left
        color: "#7fff00"
        font.pointSize: 20
    }

    RowLayout{
        focus: true
        id: threshMeasuringValues
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        TextEdit {
            id: motorText
//            activeFocusOnPress: true
            property string placeholderText: "Enter motor ID here..."
            width: 100
            height: 50
            color: "#fff"

            Text {
                 text: motorText.placeholderText
                 color: "#fff"
                 visible: !motorText.text
            }
        }

        Repeater{
            focus: true
            model: 10

            delegate:
                ColumnLayout{
                    focus: true
                    TextEdit{
//                        activeFocusOnPress: true
                        focus: true
                        Text {
                             text: threshMeasurings[index]
                             color: "#fff"
                             visible: !parent.text
                        }
                    }

                    Button{
                        text: threshMeasurings[index]
                        onClicked: {
//                            var tmp = valueMotor.text?valueMotor.text: threshMeasurings[index]
                            conController.sendCommand("pwm test -c " + motorText.text + " -p " + threshMeasurings[index])
                            console.log("pwm test -c " + motorText.text + " -p " + threshMeasurings[index])
                        }
                    }
                }
        }
    }
}
