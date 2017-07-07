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
    width: dynamicColorBox.width + 5 + staticColorBox.width + 10
    minimumWidth: dynamicColorBox.width + 5 + staticColorBox.width + 10
    height: dynamicColorBox.height + 10
    minimumHeight: dynamicColorBox.height + 10

    Settings {
        property alias x: win3.x
        property alias y: win3.y
    }

    property alias locked: dynamicColorBox.locked
    property alias selectedColor: dynamicColorBox.selectedColor
    readonly property double slope: 1.732
    //readonly property double h: 288.675134595 //250/sin(60)

    Rectangle {
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
                }
                else
                {
                    parent.locked = false
                }
            }
        }
    }
    Rectangle { //TODO: Finish making the static color box
        /*The cb should start out with red on the left and end with
        red on the right with a rainbow in between the two reds.
        It should get brighter near the top and darker near the
        bottom (use alpha gradient).*/
        id: staticColorBox
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 250
        height: 250
        border.color: "black"
        border.width: 1


        MouseArea {
            id: scbMA
            width: parent.width-2 //compensate for the border size
            height: parent.height-2
            anchors.centerIn: parent
            onClicked: {
                if(!parent.parent.locked)
                {
                    parent.parent.selectedColor = "orange"
                    parent.parent.locked = true
                }
                else
                {
                    parent.parent.locked = false
                }
            }
        }
    }
}
