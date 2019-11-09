import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.FlightMap     1.0


Rectangle {

   id: basicDemo
   color:              qgcPal.window
   property alias guidedController: guidedActionsController
//   anchors.fill: parent
   GridLayout{
       id: grid
       columns: 3
       columnSpacing: 10

       QGCButton {
           height:             _buttonHeight
           text:               qsTr("Test 1")
           exclusiveGroup:     panelActionGroup
           Layout.fillWidth:   true
           onClicked: {
                guidedController.executeAction(10, null, null)
           }
       }

       QGCButton {
           height:             _buttonHeight
           text:               qsTr("Test 2")
           exclusiveGroup:     panelActionGroup
           Layout.fillWidth:   true

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

   // Orbit editing visuals
       QGCMapCircleVisuals {
           id:             orbitMapCircle
           mapControl:     parent
           mapCircle:      _mapCircle
           visible:        false

           property alias center:              _mapCircle.center
           property alias clockwiseRotation:   _mapCircle.clockwiseRotation
           readonly property real defaultRadius: 30

           Connections {
               target: mainWindow
               onActiveVehicleChanged: {
                   if (!activeVehicle) {
                       visible = false
                   }
               }
           }

           function show(coord) {
               _mapCircle.radius.rawValue = defaultRadius
               orbitMapCircle.center = coord
               orbitMapCircle.visible = true
           }

           function hide() {
               orbitMapCircle.visible = false
           }

           function actionConfirmed() {
               // Live orbit status is handled by telemetry so we hide here and telemetry will show again.
               hide()
           }

           function actionCancelled() {
               hide()
           }

           function radius() {
               return _mapCircle.radius.rawValue
           }

           Component.onCompleted: guidedActionsController.orbitMapCircle = orbitMapCircle

           QGCMapCircle {
               id:                 _mapCircle
               interactive:        true
               radius.rawValue:    30
               showRotation:       true
               clockwiseRotation:  true
           }
       }
}
