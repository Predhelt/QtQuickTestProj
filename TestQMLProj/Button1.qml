/*A custom button with a blank text field and a corresponding mouse area.  The button changes
gradient depending on whether it is pressed or not.

Created by Ethan Johnson*/

import QtQuick 2.7

Rectangle {
    property alias mouseArea: mouseArea
    property alias btnText: btnText

    id: btnRect
    anchors.centerIn:parent
    width:100
    height: 35
    border.color: "dark grey"
    border.width: 1
    gradient: rectReleasedColors
    Text {
        id: btnText
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
    }

    MouseArea {
        id: mouseArea
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        cursorShape: Qt.PointingHandCursor
        onPressed: btnRect.gradient = rectPressedColors
        onReleased: btnRect.gradient = rectReleasedColors
        onExited: btnRect.gradient = rectReleasedColors
        onEntered: if(mouseArea.pressed)
            btnRect.gradient = rectPressedColors
    }
    property Gradient rectPressedColors: Gradient{
        GradientStop {position: 0.0; color: "grey"}
        GradientStop {position: 0.35; color: "light grey"}
        GradientStop {position: 0.6; color: "light grey"}
        GradientStop {position: 1.0; color: "white"}
    }
    property Gradient rectReleasedColors: Gradient{
        GradientStop {position: 0.0; color: "light grey"}
        GradientStop {position: 0.15; color: "white"}
        GradientStop {position: 0.45; color: "white"}
        GradientStop {position: 0.75; color: "light grey"}
        GradientStop {position: 1;  color: "grey"}
    }
}
