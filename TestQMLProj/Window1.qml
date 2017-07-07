/*This window has no actual use since QLibrary is available under QApplication and this is a QtQuick window.

This window uses FileSearch to browse for a URL on the current computer with the correct file type.
The user then inputs the name of the function that calls the proper function from the library that will open the window.
The load button will only detect whether the proper inputs are in the ComboBoxes and nothing else since this is the wrong
type of application.

Created by Ethan Johnson*/

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Window {
    minimumWidth: rowBrowseDir.width + 10
    minimumHeight: rowBrowseDir.height + rowLibName.height + rowLoad.height + 20
    width: 500
    height: 400

    Item{ //Row containing the browse label, combo box, and button

        id: rowBrowseDir
        anchors.bottom: rowLibName.top
        anchors.horizontalCenter: rowLibName.horizontalCenter

        //width is the width of all of the contained objects + 10 for some space between objects
        width: lblLibDir.width + btnBrowse.width + cbFile.width + 20
        height: 40

/*        Rectangle { //Rectangle to show the area of the row
            id: rectBrowseDir
            color: "skyblue"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }*/

        FileSearch {
            id: fsMain
            visible: false
            onAccepted: lmFiles.insert(0, {text: ""+fsMain.fileUrl})
        }

        Label {
            id: lblLibDir
            text: "Library\nDirectory:"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        Button {
            id: btnBrowse
            text: "Browse..."
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            onClicked: fsMain.visible = true
            Component.onCompleted: btnBrowse.__behavior.cursorShape = Qt.PointingHandCursor
        }
        ComboBox {
            id: cbFile
            width: 250
            anchors.left: lblLibDir.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10

            ListModel {
                id: lmFiles
                ListElement {text: ""}
            }
            model: lmFiles
        }
    }
    Item{ //Row containing the library name label and combo box

        id: rowLibName
        anchors.centerIn: parent
        width: rowBrowseDir.width
        height: 34

/*        Rectangle { //Rectangle to show the area of the row
            id: rectLibName
            color: "tan"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }*/

        Label {
            id: lblLibNames
            text: "Window name:"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        ComboBox {
            id: cbLibNames
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            editable: true
            width: 200

            ListModel {
                id: lmLibNames
                ListElement {text: ""}
            }
            model: lmLibNames
            onAccepted:{
                var currText = cbLibNames.currentText
                if(cbLibNames.find(currText) === -1)
                    lmLibNames.insert(0, {text: ""+currText})
            }
        }
    }
    Item{ //Row containing the status label and the load button

        id: rowLoad
        anchors.top: rowLibName.bottom
        anchors.horizontalCenter: rowLibName.horizontalCenter
        width: rowBrowseDir.width
        height: 50

/*        Rectangle { //Rectangle to show the area of the row
            id: rectLoad
            color: "cyan"
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }*/
        Label {
            id: lblStatus
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: 150
            text: "Please select a file and a window name then hit load."
            wrapMode: Text.Wrap
        }
        Button {
            id: btnLoad
            anchors.centerIn: parent
            text: "Load\nWindow"
            onClicked: {
                if(cbFile.currentText !== "")
                {
                    if(cbLibNames.currentText !== "")
                    {

                    }
                    else
                        lblStatus.text = "Error: no window name selected."
                }
                else
                    lblStatus.text = "Error: no file directory selected."
            }
        }
    }
}
