$().w2form({
    name   : 'folder-form',
    url: 'contentmanager/front/folder',
    fields : [
      { field: 'name', type: 'text', required: true, html: { caption: 'Name' } }
    ],
    actions: {
      'Cancel': function () { w2popup.close() },
      'Clear': function () { this.clear() },
      'Save': function (event) { this.save() }
    },
    postData: { authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=" },
    onSave: function(event) {
      w2popup.close()
      $("#foldertree").fancytree("getTree").reload()
    }
})