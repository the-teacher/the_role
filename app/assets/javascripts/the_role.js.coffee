showForm = (event) ->
  item   = $ event

  a_item = item.children('span.a')
  b_item = item.children('span.b')

  a_item.hide().off 'click'
  b_item.css('visibility', 'visible')

  item.find('.btn-warning').click ->
    hideForm(event)
    event.parentNode.reset()

  item.find('.btn-success').click -> event.parentNode.submit()
  
  b_item.find('input').keypress (e) ->
    ENTER = 13
    event.parentNode.submit() if e.which is ENTER

hideForm = (event) ->
  item   = $ event
  a_item = item.children('span.a')
  b_item = item.children('span.b')
  
  a_item.show()
  b_item.css('visibility', 'hidden')
  item.find('.btn').off('click')
  a_item.click -> showForm(event)

$ ->
  $('span.a', '.title, .name, .description').click -> showForm @parentNode