// This is directly dependent on ColorBox.qml
/* This class creates a window where the background color can be changed to a random color by pressing
  the appropriate button.  To save a color, click the save button, then click a color box in the bottom left.
  Clicking on the color box when not saving will cause the background to become that color.
  the color box rectangle is made in a separate class and its mouse area is generated by this class.

Created by Ethan Johnson */

import QtQuick 2.7
import QtQuick.Window 2.2

Item {
    property int maxColors: 8 //Default value for the max number of color boxes
    property var cbComponent: Qt.createComponent("ColorBox.qml")
    property var cbList: [] //ColorBox list
    property var cbMAList: [] //ColorBox MouseArea list
    property bool savingColor: false

    id: root
    width: parent.width
    height: parent.height

    Component.onCompleted: { /*Generates the color boxes and their mouse areas
                               at relative positions*/
        if(maxColors > 255)
        {
            console.log("Error: max color size is too large.")
            return
        }
        //This is the first color box and it will always be white
        cbList.push(cbComponent.createObject(root, {"objNum":0}))
        //Set the position of the colorBox to be in the bottom-left
        cbList[0].anchors.left = root.left
        cbList[0].anchors.bottom = root.bottom
        cbList[0].anchors.leftMargin = 10
        cbList[0].anchors.bottomMargin = 10
        var newObject = Qt.createQmlObject("import QtQuick 2.7;
                MouseArea {anchors.centerIn: parent;
                width: parent.width; height: parent.height;
                cursorShape: Qt.PointingHandCursor; onClicked: {
                    if(!parent.savingColor)
                        windowBackground.color = parent.curColor;
                    else
                        winCannotEdit.visible = true}}",
                cbList[0]);
        cbMAList.push(newObject)

        for(var i = 1; i < maxColors; i++)
        {
            cbList.push(cbComponent.createObject(root, {"objNum":i}))
            //Anchor the color boxes to the previous color box
            cbList[i].anchors.left = cbList[i-1].right
            cbList[i].anchors.bottom = cbList[i-1].bottom
            cbList[i].anchors.leftMargin = 10
            //Creates the mouse area of the ColorBox local to this window
            newObject = Qt.createQmlObject('import QtQuick 2.7;
                MouseArea {anchors.centerIn: parent;
                width: parent.width; height: parent.height;
                cursorShape: Qt.PointingHandCursor; onClicked: {
                    if(parent.savingColor)
                    {
                        parent.curColor = windowBackground.color;
                        windowMA.cursorShape = Qt.ArrowCursor;
                        onSuccessfulSave();
                        btnSave.btnText.text = qsTr("Save color");
                    }
                    else
                        windowBackground.color = parent.curColor}}',
               cbList[i]);
            cbMAList.push(newObject)
        }
    }

    function onSuccessfulSave() {
        for(var i = 0; i < maxColors; i++)
            cbList[i].savingColor = false;
        savingColor = false
    }

    //FIXME:  Find a way to draw the buttons above the color boxes.
    Rectangle {
        id: windowBackground
        anchors.centerIn:parent
        width:parent.width
        height:parent.height
        MouseArea { //The mouse area of windowBackground
            id: windowMA
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }
        Button1 { //The "Change color" button
            id: btnCW
            z: 1
            anchors.verticalCenterOffset: -20
            btnText.text: qsTr("Change color")
            mouseArea.onClicked: windowBackground.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0)
        }
        Button1 { //The "Save color" button
            id: btnSave
            z: 1
            anchors.verticalCenterOffset: 20
            btnText.text: qsTr("Save color")
            mouseArea.onClicked: {
                if(!savingColor)
                {
                    for(var i = 0; i < maxColors; i++)
                        cbList[i].savingColor = true
                    savingColor = true
                    windowMA.cursorShape = Qt.WhatsThisCursor
                    btnSave.btnText.text = qsTr("Cancel")
                }
                else
                {
                    for(i = 0; i < maxColors; i++)
                        cbList[i].savingColor = false
                    savingColor = false
                    windowMA.cursorShape = Qt.ArrowCursor
                    btnSave.btnText.text = qsTr("Save color")
                }
            }

/*            Window {
                //This is the warning window that pops up when there are no more custom color slots left
                id: winMaxColors
                maximumWidth: txtWarning.width
                minimumWidth: maximumWidth
                maximumHeight: 80
                minimumHeight: maximumHeight
                title: "Warning"
                visible: false
                Text {
                    id: txtWarning
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    width: 220
                    text: "There are no color slots left!"
                }
            }*/
            Window { //Warning window indicating that the left-most color cannot be edited
                id: winCannotEdit
                maximumWidth: txtWarning.width
                minimumWidth: maximumWidth
                maximumHeight: 80
                minimumHeight: maximumHeight
                title: qsTr("Warning")
                visible: false
                Text {
                    id: txtWarning
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    width: 220
                    text: qsTr("The left-most color cannot be edited!")
                }
            }
        }
/*        Text { //Tests text hyperlink
            anchors.centerIn: parent
            text: "test hyperlink: <a href='http://www.asciitable.com/'>ascii</a>"
            onLinkActivated: Qt.openUrlExternally(link)
        }*/
    }
}
