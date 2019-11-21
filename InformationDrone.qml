import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts              1.11
import QtQuick.Dialogs              1.3

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0


TableView {

    id: parent


    MAVLinkInspectorController {
        id: controller
    }

    TableViewColumn{
        role: "info"
        title: "Information"
        width: 100
    }

    TableViewColumn{
        role: "value"
        title: "Value"
        width: 170
    }

    model: infoModel


    ListModel {
        id: infoModel
        property var curVehicle:        controller ? controller.activeVehicle : null
        property var messageAttitude:        curVehicle && curVehicle.messages.count ? curVehicle.messages.get(5) : null
        property var messageServoOutput:        curVehicle && curVehicle.messages.count ? curVehicle.messages.get(7) : null

        property real roll: messageAttitude ? messageAttitude.fields.get(1).value: null
        property real pitch: messageAttitude ? messageAttitude.fields.get(2).value: null
        property real yaw: messageAttitude ? messageAttitude.fields.get(3).value: null

        property int pwm1: messageServoOutput ? messageServoOutput.fields.get(2).value: null
        property int pwm2: messageServoOutput ? messageServoOutput.fields.get(3).value: null
        property int pwm3: messageServoOutput ? messageServoOutput.fields.get(4).value: null
        property int pwm4: messageServoOutput ? messageServoOutput.fields.get(5).value: null
        property int pwm5: messageServoOutput ? messageServoOutput.fields.get(6).value: null
        property int pwm6: messageServoOutput ? messageServoOutput.fields.get(7).value: null

        property bool ready: curVehicle & messageAttitude & messageServoOutput

        property bool completed: false

        Component.onCompleted: {
            append({"info": "Roll", value: 0});
            append({"info": "Pitch", value: 0});
            append({"info": "Yaw", value: 0});

            append({"info": "PWM1", value: 0});
            append({"info": "PWM2", value: 0});
            append({"info": "PWM3", value: 0});
            append({"info": "PWM4", value: 0});
            append({"info": "PWM5", value: 0});
            append({"info": "PWM6", value: 0});

            completed = true;
        }

        onRollChanged: {
            setProperty(0, "value", roll);
        }
        onPitchChanged: {
            setProperty(1, "value", pitch)
        }
        onYawChanged: {
            setProperty(2, "value", yaw)
        }

        onPwm1Changed: {
            setProperty(3, "value", pwm1)
        }
        onPwm2Changed: {
            setProperty(4, "value", pwm2)
        }
        onPwm3Changed: {
            setProperty(5, "value", pwm3)
        }
        onPwm4Changed: {
            setProperty(6, "value", pwm4)
        }
        onPwm5Changed: {
            setProperty(7, "value", pwm5)
        }
        onPwm6Changed: {
            setProperty(8, "value", pwm6)
        }
    }
}

