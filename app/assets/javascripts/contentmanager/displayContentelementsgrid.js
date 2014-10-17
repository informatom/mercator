function displayContentelementsgrid() {
  $('#contentelementsgrid').w2grid({
    name: 'contentelementsgrid',
    header: 'List of Content Elements',
    method: 'GET',
    show: { toolbar: true,
            footer: true,
            selectColumn: true },
    columns: [
      { field: 'recid', caption: 'ID', size: '50px', sortable: true, attr: "align=center", hidden: true },
      { field: 'name_de', caption: 'Name DE', size: '150px', sortable: true,
        render: function (record) {
          return '<div id ="content-element-' + record.recid + '" class="draggable">' + record.name_de + '</div>'
        }},
      { field: 'name_en', caption: 'Name EN', size: '150px', sortable: true, hidden: true },
      { field: 'markup', caption: 'Markup', size: '40px', hidden: true },
      { field: 'content_de', caption: 'Inhalt DE', size: '50%', sortable: true},
      { field: 'content_en', caption: 'Inhalt EN', size: '300px', hidden: true, sortable: true },
      { field: 'created_at', caption: 'erzeugt', size: '130px', hidden: true, sortable: true,
        render: function (record) { return moment(record.created_at).format("YYYY-MM-DD HH:mm:ss") } },
      { field: 'updated_at', caption: 'geändert', size: '130px' , sortable: true,
        render: function (record) { return moment(record.updated_at).format("YYYY-MM-DD HH:mm:ss") } },
      { field: 'document_file_name', caption: 'Dokument', size: '150px', sortable: true },
      { field: 'photo_file_name', caption: 'Photo', size: '150px', sortable: true },
      { field: 'thumb_url', caption: 'Photo Path', size: '150px', hidden: true } ],
    searches: [
      { field: 'name_de', caption: 'Name DE', type: 'text' },
      { field: 'name_en', caption: 'Name EN', type: 'text' },
      { field: 'content_de', caption: 'Inhalt DE', type: 'text' },
      { field: 'content_en', caption: 'Inhalt EN', type: 'text' } ],
    sortData: [{ field: 'name_de', direction: 'ASC' } ],

    onClick: function(event) {
      event.onComplete = function () {
        var sel = this.getSelection()
        previewImage(this.get(sel).thumb_url)
      }
    },
    onRefresh: function(event) {
      event.onComplete = function () {
        $('.draggable').draggable({
          cursor: 'crosshair',
          opacity: 0.9,
          helper: "clone",
          containment: ".myLayout",
          zIndex: 10000,
          appendTo: "body",
          connectToFancytree: true,
          cursorAt: { top: -5, left: -5 }
        })
      }
    }
  })
}