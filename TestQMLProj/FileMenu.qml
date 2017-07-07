/* In QtQuick.Controls >= 2, there are no MenuBars, so I contained each menu in a button.
This is the File menu that contains options for the current window like save and exit.

Created by Ethan Johnson */

import QtQuick 2.7
import QtQuick.Controls 2.2

Button {
    property alias menus: menus
    property alias menusX: menus.x
    property alias menusY: menus.y
    property alias menuSave: menuSave

    width: 80
    height: 25
    anchors.left: parent.left
    anchors.top: parent.top
    text: "File..."

    Menu {
        id: menus
        title: qsTr("File")
        width: 130
        MenuItem { //TODO: Either find a use for the save button or remove it
            id: menuSave
            text: qsTr("Save")
            height: 25
        }
    /*        MenuItem {
                text: qsTr("Save As...")
                height: 25
            }*/

        MenuItem {
            text: qsTr("Exit")
            height: 25
            onTriggered: Qt.quit();
        }
    }
}

