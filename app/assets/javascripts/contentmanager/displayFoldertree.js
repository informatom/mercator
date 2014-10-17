function displayFoldertree() {
  $("#foldertree").fancytree({
    source: { url: "/contentmanager/front/show_foldertree" },
    extensions: ["dnd"],
    dnd: {
      droppable: {
        activeClass: "ui-state-default",
        hoverClass: "ui-state-hover"
      },
      dragStart: function(node, data) { return true },
      dragEnter: function(node, data) { return true },
      dragDrop: function(node, data) {
        if( !data.otherNode ){
          // It's a non-tree draggable
          var draggable = data.draggable.element[0]
          var contentElementId = parseInt(draggable.id.split("-")[2])

          Messenger().run({
            progressMessage: 'Baustein wird verschoben ...',
            successMessage: 'Baustein erfolgreich verschoben!',
            errorMessage: 'Baustein konnte nicht verschoben werden!',
            hideAfter: 3
          },{
            url:"/contentmanager/front/update_content_element/" + contentElementId,
            method: "POST",
            data: {
              authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=",
              folder_id: data.node.key
            },
            dataType: 'script',
            success: function(response){
              w2ui['contentelementsgrid'].load('/contentmanager/front/show_content_elements/' + response)
            }
          })

        } else {
          // It's a tree draggable
          data.otherNode.moveTo(node, data.hitMode)

          Messenger().run({
            progressMessage: 'Verzeichnisbaum wird aktualisiert ...',
            successMessage: 'Verzeichnisbaum erfolgreich aktualisiert!',
            errorMessage: 'Verzeichnisbaum konnte nicht aktualisiert werden!',
            hideAfter: 3
          },{
            url:"/contentmanager/front/update_folders",
            method: "POST",
            data: {
              authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=",
              folders: $("#foldertree").fancytree("getTree").toDict()
            },
            dataType: 'script'
          })
        }
      }
    },
    click: function(event, data) {
      w2ui['contentelementsgrid'].load('/contentmanager/front/show_content_elements/' + data.node.key)
    }
  })
}