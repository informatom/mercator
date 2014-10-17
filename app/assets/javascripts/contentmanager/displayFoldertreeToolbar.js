function displayFoldertreeToolbar() {
  $('#foldertree-toolbar').w2toolbar({
    name: 'foldertree-toolbar',
    items: [
      { type: 'button',  id: 'add',     caption: 'Add',    icon: 'fa fa-folder' },
      { type: 'button',  id: 'edit',  caption: 'Edit', icon: 'fa fa-edit' },
      { type: 'button',  id: 'delete',  caption: 'Delete', icon: 'fa fa-close' }
    ],
    onClick: function (event) {
      switch (event.target) {
      case 'add':
        w2popup.open({
          title: 'Create Folder',
          body: '<div id="folder-form"></div>',
          onOpen  : function (event) {
            event.onComplete = function () {
              $('#folder-form').w2render('folder-form')
            }
          }
        })
        break
      case 'delete':
        var active_node = $("#foldertree").fancytree("getTree").getActiveNode()
        if (active_node) {
          w2confirm('Are you sure?', function (button) {
            if (button =='Yes') {

              Messenger().run({
                progressMessage: 'Verzeichnis wird gelöscht ... ...',
                successMessage: 'Verzeichnis erfolgreich gelöscht!',
                errorMessage: 'Verzeichnis konnte nicht gelöscht werden!',
                hideAfter: 3
              },{
                url:"/contentmanager/front/delete_folder/" + active_node.key,
                method: "POST",
                data: { authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=" },
                dataType: 'script',
                success: function(response){
                  $("#foldertree").fancytree("getTree").reload()
                },
                error: function(response){
                  return response.responseText
                }
              })
            }
          })
        } else {
          w2alert('No folder selected')
        }
        break
      case 'edit':
        var active_node = $("#foldertree").fancytree("getTree").getActiveNode()
        if (active_node) {
          w2popup.open({
            title: 'Create Folder',
            body: '<div id="folder-form"></div>',
            onOpen  : function (event) {
              event.onComplete = function () {
                w2ui['folder-form'].recid = active_node.key
                $('#folder-form').w2render('folder-form')
              }
            }
          })
        } else {
          w2alert('No folder selected')
        }
        break
      }
    }
  })
}