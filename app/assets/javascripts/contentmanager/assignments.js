function displayAssignmentsgrid() {
  $('#assignments').w2grid({
    name: 'assignments',
    method: 'GET',
    show: { selectColumn: true },
    columns: [
      { field: 'used_as', caption: 'used as', size: '50%', sortable: true },
      { field: 'content_element_name', caption: 'Content Element', size: '50%',
        render: function (record) {
          return '<div id="assignment-' + record.recid + '" class="droppable">' +
                  (record.content_element_name || '<span style="color: #ff0000"> not assigned</span>') + '</div>'
      }}
    ],
    sortData: [ { field: 'used_as', direction: 'ASC' } ],

    onRefresh: function(event) {
      event.onComplete = function () {
        $( ".droppable" ).droppable({
          activeClass: "ui-state-default",
          hoverClass: "ui-state-hover",
          drop: function( event, ui ) {
            var draggable = ui.draggable[0]
            var contentElementId = parseInt(draggable.id.split("-")[2])
            var associationID = parseInt(this.id.split("-")[1])

            Messenger().run({
              progressMessage: 'Baustein wird zugeordnet ...',
              successMessage: 'Baustein erfolgreich zugeordnet!',
              errorMessage: 'Baustein konnte nicht zugeordnet werden!',
              hideAfter: 3
            },{
              url:"/contentmanager/front/update_page_content_element_assignment/" + associationID,
              method: "POST",
              data: {
                authenticity_token: "jAKl2wsqpvqYwBKZx5sT4Isf+mQXAy46ONBd2xVrw7E=",
                content_element_id: contentElementId
              },
              dataType: 'script',
              success: function(response){
                w2ui['assignments'].load('/contentmanager/front/show_assignments/' + response)
              }
            })
          }
        })
      }
    }
  })
}