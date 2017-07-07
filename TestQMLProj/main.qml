/* In this project, a window with several ColorBoxes are generated.  ColorBoxes are used
 to store custom colors by hitting 'Save Color' and then clicking on whichever box you
want to save the color to.  The color is determined by the color of the background of
the main window.  This is changed by hitting the 'Change Color' button.

In addition, there is a 'Color Window...' menu that allows the user to open a separate
window that changes color based on the position of the mouse in the window.  When the user
clicks inside of the colored area, the color that was shown will be locked as the color of
that window.  Clicking again will unlock the color of the window, allowing for a new color
to be selected.  Once a color is selected, going to the 'Color Window...' menu and clicking
'Save' will save the selected color to one of the save slots in the 'Color Window... -> Load...'
 menu.

Created by Ethan Johnson*/

import QtQuick 2.7
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

ApplicationWindow {

    //Dependent on Window2:
    readonly property int maxColorBoxes: 32 //the number of color boxes that will show up. Max is 255

    //Dependent on Window3:
    property var win //This is the window that is created upon hitting the Open menu item
    property var component: Qt.createComponent("Window3.qml"); //the color wheel window
    readonly property int maxSaveSlots: 8 //the max number of Window3's that can be saved
    property int curSaves: 0 //tracks the current number of save slots that have been used
    property var menuSaveSlots: []; //the array of save slots
    //saveSlotStr is a menu item representing the save state of a Window3
    property string saveSlotStr: {"import QtQuick 2.7; import QtQuick.Controls 2.2;
                                    MenuItem {
                                        property color saveColor;

                                        height: 25
                                        enabled: false
                                        text: qsTr('Save ') + (menuSaveSlots.length+1).toString();
                                        onTriggered: {
                                            if(win && win.visible)
                                            {
                                                win.selectedColor = saveColor;
                                                win.locked = true;
                                            }
                                            else
                                            {
                                                win = component.createObject(mainWin, {'selectedColor': saveColor,
                                                                             'locked': saveLocked});
                                                win.show();
                                            }
                                        }
                                    }"}

    id: mainWin
    visible: true
    width: 640
    minimumWidth: 200
    height: 480
    minimumHeight: 150
    title: qsTr("Test Window")

    Settings { //The properties that will be saved upon closing and reopening
        //FIXME: The none of the settings are saving at all.  They should overwrite the default values.
        property alias x: mainWin.x
        property alias y: mainWin.y
        property alias width: mainWin.width
        property alias height: mainWin.height
    }

    Component.onCompleted: {
        //Adds all of the Window3 save slots to the 'Load...' menu.
        for(var i = 0; i < maxSaveSlots; i++)
        {
            var newSaveSlot = Qt.createQmlObject(saveSlotStr, menuSaves)
            menuSaves.addItem(newSaveSlot)
            menuSaveSlots.push(menuSaves.itemAt(i))
        }
    }

    Menu { //The menu for the color windows (Window3)
        id: menuCW
        title: qsTr("Color Windows")
        width: 160
        MenuItem {
            height: 25
            text: qsTr("New Window")
            onTriggered: { /* Determines whether a Window3 is already visible and creates a
                new one if one isn't. Otherwise, the selected color is set to white. */
                if(win && win.visible)
                    win.selectedColor = 'white'
                else
                {   //Creates a new Window3 component and shows it
                    win = component.createObject(mainWin);
                    if(component.status === Component.Error)
                        console.debug("Error:"+ component.errorString() )
                    else if(component.status === Component.Ready)
                        win.show();
                }
            }
        }
        MenuItem {
            height: 25
            id: menuLoad
            text: qsTr("Load...")
            onTriggered: menuSaves.open()
        }
        MenuItem {
            height: 25
            id: menuSave
            text: qsTr("Save")
            onTriggered: { // Saves the currently opened window to the appropriate slot
                if(win && win.visible)
                {
                    if(win.selectedColor === Qt.rgba(1, 1, 1, 1))
                    {
                        console.log(qsTr("Error: white selected.  Pick a different color"))
                        return
                    }
                    if(curSaves < maxSaveSlots)
                    {
                        console.log(qsTr("Saving..."))

                        for(var i = 0; i < curSaves; i++)
                            if(menuSaveSlots[i].saveColor === win.selectedColor)
                            {
                                console.log(qsTr("Color already saved to '" + menuSaveSlots[i].text + "'."))
                                return
                            }

                        menuSaveSlots[curSaves].saveColor = win.selectedColor
                        menuSaveSlots[curSaves].enabled = true
                        curSaves++

                        console.log(qsTr("Completed"))
                    }
                    else
                        console.log(qsTr("Maximum save slots reached"))
                }
                else
                    console.log(qsTr("No window to save"))
            }
        }
    }
    Menu { //The menu containing the saves for each of the color windows (Window3)
        id: menuSaves
        title: qsTr("Saves")
        x: fileMenu.width + 80
        y: btnCW.height + menuLoad.y
    }

    function adjustBoxes() { /* (Window2) Can replace 30 with a custom number by
        //adding the appropriate parameter */
        var interval = mainWin.width/30 /* The number of boxes in each row.
        30 is due to the width of the color boxes and their left margin. */
        if(interval >= maxColorBoxes)
            return
        if(interval < 1)
        {
            mainWin.minimumWidth = 100
            mainWin.minimumHeight = 60
            return
        }

        var rows = 1
        for(var i = parseInt(interval); i < maxColorBoxes; i += parseInt(interval))
        {
            mainWindow.cbList[i].anchors.bottom = mainWindow.cbList[i-1].top
            mainWindow.cbList[i].anchors.bottomMargin = 10
            mainWindow.cbList[i].anchors.left = mainWindow.left
            rows++
        }
        mainWin.minimumHeight = 30 + rows*30
    }
    //Interface for the main window
    Window2 { //The contents of the main window including color boxes and buttons
        id: mainWindow
        anchors.centerIn: parent
        maxColors: maxColorBoxes
        onWidthChanged: { /* Ensures that no color boxes go off of the right side of the window and
            prevents more rows from being created than is necessary */
            for(var i = 1; i < maxColorBoxes; i++)
            {
                var cba = mainWindow.cbList[i].anchors
                if(cba.bottomMargin === 10)
                {
                    cba.left = mainWindow.cbList[i-1].right
                    cba.bottom = mainWindow.cbList[i-1].bottom
                    cba.bottomMargin = 0
                }
            }
            adjustBoxes()
        }
    }
    FileMenu {
        id: fileMenu
        onClicked: {
            fileMenu.menusY = fileMenu.height
            fileMenu.menus.open()
        }
    }
    //This is the Color Window menu button
    Button { //(FileMenu) menu bar
        id: btnCW
        width: 115
        height: 25
        anchors.left: fileMenu.right
        anchors.top: parent.top
        text: "Color Window..."
        onClicked: {
            menuCW.x = fileMenu.width
            menuCW.y = btnCW.height
            menuCW.open()
        }
    }
}
