/* This is a dialog window that pops up when trying to browse file directories on the local
machine.  Filters are applied to prevent unknown file types from being chosen.

Created by Ethan Johnson*/

import QtQuick 2.7
import QtQuick.Dialogs 1.2

FileDialog {
    property alias filters: fs.nameFilters

    id: fs
    title: "Please choose a file"
    folder: shortcuts.home
    //These are the file types of QLibrary files, so not useful in QML.  Should be reassigned.
    nameFilters: ["All (*.dll *.DLL *.so *.a *.so(HP-UXi) *.sl *.dylib *.bundle)",
    "Windows (*.dll *.DLL)","Unix/Linux (*.so)","AIX (*.a)",
    "HP-UX (*.sl *.so (HP-UXi))","macOS and iOS (*.dylib *.bundle *.so)"]
}
