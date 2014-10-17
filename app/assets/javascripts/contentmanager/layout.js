$(function () {
  w2utils.locale('/assets/contentmanager/de-de.json')

  $('#myLayout').w2layout({
    name: 'contentmanager',
    panels: [
      { type: 'top', size: 60, resizable: true, title: 'Content Manager' },
      { type: 'left', size: 250, resizable: true, title: 'Website Structure', content: "<div id='pagetree'></div>" },
      { type: 'main', title: 'Webpage', resizable: true, content: "<div id='webpage' style='height:100%;'></div>" },
      { type: 'preview', size: 400, resizable: true, title: 'Assignments', content: "<div id='assignments' style='height:100%' ></div>" },
      { type: 'right', size: 1300, resizable: true}
    ],
    onRender: function(event) {
      event.onComplete = function () {
        displayWebpageTree()
        displayWebpage()
        displayAssignmentsgrid()
      }
    }
  })

  $().w2layout({
    name: 'elementexplorer',
    panels: [
      { type: 'main', resizable: true, title: 'Folder Structure',
        content: "<div id='foldertree-toolbar' style='height:5%'></div><div id='foldertree' style='height:95%'></div>" },
      { type: 'right', resizable: true, size: 1100, title: 'Content Elements',
        content: "<div id='contentelementsgrid' style='height:100%'></div>" },
      { type: 'preview', size: 200, resizable: true, title: 'Preview', content: "<div id='preview'></div>" }
    ],
    onRender: function(event) {
      event.onComplete = function () {
        displayFoldertreeToolbar()
        displayFoldertree()
        displayContentelementsgrid()
      }
    }
  })

  w2ui['contentmanager'].content('right', w2ui['elementexplorer'])
})