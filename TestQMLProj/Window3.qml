/* This is the window that contains the color square where the color you see is determined
 by the position of the cursor in the box.  Clicking on the square will capture the current
color and lock that color as the square's color.  Clicking again will unlock the color, but
maintain the color as the selected color.  The values of this window are used in 'main.qml'.

Created by Ethan Johnson*/

import QtQuick 2.7
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.0

Window {
    id: win3
    title: qsTr("Color Box")
    width: dynamicColorBox.width + 5 + greysColorBox.width + 5 + staticColorBox.width + 10
    minimumWidth: dynamicColorBox.width + 5 + greysColorBox.width + 5 + staticColorBox.width + 10
    height: dynamicColorBox.height + 10
    minimumHeight: dynamicColorBox.height + 10

    Settings {
        property alias x: win3.x
        property alias y: win3.y
    }

    property alias locked: dynamicColorBox.locked
    property alias selectedColor: dynamicColorBox.selectedColor

    Rectangle { // Color box that changes color upon hovering the mouse over it
        property alias dcbMouseX: dcbMA.mouseX
        property alias dcbMouseY: dcbMA.mouseY
        property bool locked: false
        property color selectedColor: "white"

        id: dynamicColorBox
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: 250
        height: 250
        color: {
            if(locked)
                selectedColor
            else if(dcbMA.containsMouse)
                var c = Qt.rgba((dcbMouseX*1.0)/width, (dcbMouseY*1.0)/height,
                                (1-((dcbMouseX*1.0)/width + (dcbMouseY*1.0)/height)/2), 1)
            c ? c: selectedColor //checks if c is undefined, sets color to white if it is
        }
        border.color: "black"
        border.width: 1
        MouseArea {
            id: dcbMA
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            hoverEnabled: enabled
            onClicked: {
                if(!parent.locked)
                {
                    parent.selectedColor = parent.color
                    parent.locked = true
                    selectionBox.visible = false
                    greysSelection.visible = false
                }
                else
                {
                    parent.locked = false
                }
            }
        }
    }

    Rectangle { // Color box that shows every color besides greys to be selected
        property alias scbMouseX: scbMA.mouseX
        property alias scbMouseY: scbMA.mouseY
        property bool locked: false
        property color selectedColor: "white"

        id: staticColorBox
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 250
        height: 250
        rotation: -90
        gradient: Gradient {
            GradientStop {position: 0; color: Qt.rgba(255,0,0,255)} //red
            GradientStop {position: 1.0/6; color: Qt.rgba(255,255,0,255)} //yellow
            GradientStop {position: 1.0/3; color: Qt.rgba(0,255,0,255)} //green
            GradientStop {position: 0.5; color: Qt.rgba(0,255,255,255)} //teal
            GradientStop {position: 2.0/3; color: Qt.rgba(0,0,255,255)} //blue
            GradientStop {position: 5.0/6; color: Qt.rgba(255,0,255,255)} //pink
            GradientStop {position: 1; color: Qt.rgba(255,0,0,255)} //red
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            rotation: 90
            border.color: "black"
            border.width: 1
            gradient: Gradient {
                GradientStop {position: 0; color: Qt.rgba(255,255,255,255)}
                GradientStop {position: 0.5; color: Qt.rgba(127.5,127.5,127.5,0)}
                GradientStop {position: 1; color: Qt.rgba(0,0,0,255)}
            }
        }

        Rectangle {
            id: selectionBox
            width: 3
            height: 3
            border.color: "black"
            border.width: 1
            color: Qt.rgba(0,0,0,0)
            visible: false
        }

        MouseArea {
            id: scbMA
            width: parent.width-2 //compensate for the border size
            height: parent.height-2
            anchors.centerIn: parent
            onClicked: {
                var xPos = (mouseY*1.0/width) //because of rotation
                var yPos = (mouseX*1.0/height)
                var c = Qt.hsla(xPos, 1, yPos, 1)
                dynamicColorBox.selectedColor = c

                selectionBox.x = mouseX
                selectionBox.y = mouseY
                if(yPos < 0.25)
                    selectionBox.border.color = "grey"
                else
                    selectionBox.border.color = "black"
                greysSelection.visible = false
                selectionBox.visible = true
            }
        }
    }

    Rectangle { // Color box that shows greys to be selected
        id: greysColorBox
        width: 17
        height: 250
        anchors.right: staticColorBox.left
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        border.color: "black"
        border.width: 1
        gradient: Gradient {
            GradientStop {position: 0; color: Qt.hsla(0,0,1,1)}
            GradientStop {position: 1; color: Qt.hsla(0,0,0,1)}
        }

        Rectangle {
            id: greysSelection
            width: parent.width
            height: 3
            anchors.left: parent.left
            color: Qt.rgba(0,0,0,0)
            border.width: 1
            visible: false
        }

        MouseArea {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            onClicked: {
                selectedColor = Qt.hsla(0,0,1-mouseY/height,1)

                greysSelection.y = mouseY
                if(mouseY/height > 0.73)
                    greysSelection.border.color = "grey"
                else
                    greysSelection.border.color = "black"
                selectionBox.visible = false
                greysSelection.visible = true
            }
        }
    }
}
