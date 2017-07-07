//Functions to save the data of the Window3
function saveFile(fileUrl) {
    fileUrl.toString()
    var jsonStr = '{ "colors" : ['
    for(var i = 0; i < maxSaveSlots; i++)
    {
        jsonStr += ' { "col' + i + '" : ' +  + ' } '
    }
    jsonStr += ']}'
}
function saveFileAs() {

}
//Function to determine the position of something in relation to the root parent
function getAbsolutePosition(node) {
      var returnPos = {};
      returnPos.x = 0;
      returnPos.y = 0;
      if(node !== undefined && node !== null) {
          var parentValue = getAbsolutePosition(node.parent);
          returnPos.x = parentValue.x + node.x;
          returnPos.y = parentValue.y + node.y;
      }
      return returnPos;
}
