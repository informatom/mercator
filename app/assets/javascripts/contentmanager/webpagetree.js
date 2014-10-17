function displayWebpageTree() {
  $("#pagetree").fancytree({
    source: { url: "/contentmanager/front/show_webpagestree" },
    extensions: ["dnd"],
    dnd: {
      dragStart: function(node, data) { return true },
      dragEnter: function(node, data) { return true },
      dragDrop: function(node, data) {
        data.otherNode.moveTo(node, data.hitMode)

        Messenger().run({
          progressMessage: 'Kategoriebaum wird aktualisiert ...',
          successMessage: 'Kategoriebaum erfolgreich aktualisiert!',
          errorMessage: 'Kategoriebaum konnte nicht aktualisiert werden!',
          hideAfter: 3
        },{
          url:"/contentmanager/front/update_webpages",
          method: "POST",
          data: {
            authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=",
            webpages: $("#pagetree").fancytree("getTree").toDict()
          },
          dataType: 'script'
        })
      }
    },
    click: function(event, data) {
      w2ui['assignments'].load('/contentmanager/front/show_assignments/' +  data.node.key)
      w2ui['webpage'].load('/contentmanager/front/show_webpage/' +  data.node.key)
    }
  })
}