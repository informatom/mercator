function displayWebpage() {
  $('#webpage').w2grid({
    name: 'webpage',
    method: 'GET',
    columns : [
      { field: 'attribute', caption: 'Attribut', size: '50%' },
      { field: 'value', caption: 'Wert', size: '50%'}
    ]
  })
}