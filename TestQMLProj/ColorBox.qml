/* A simple rectangle with a border that has the custom property of objNum, curColor,
and savingColor so that it can be used to store custom colors as the rectangle's color
using Window2.qml.  Window2 relies on this file.

Created by Ethan Johnson*/

import QtQuick 2.7

Rectangle {
    id: container

    property int objNum: 0 //determines the position of the object
    property color curColor: "white"  //color of the object
    property bool savingColor: false

    width: 20
    height: 20
    color: curColor
    border.color: "black"
    border.width: 1

}
