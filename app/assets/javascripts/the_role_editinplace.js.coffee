showForm = (item) ->
  holder = item.parents('.holder')
  a_item = holder.children('span.a')
  b_item = holder.children('span.b')

  a_item.hide().off 'click'
  b_item.css('visibility', 'visible')

  holder.find('.btn-warning').click ->
    item = $ @ 
    hideForm item
    item.parents('form')[0].reset()

  holder.find('.btn-success').click ->
    $(@).parents('form')[0].submit()
  
  b_item.find('input').keypress (event) ->
    ENTER = 13
    form  = $(event.target).parents('form')
    form.submit() if event.which is ENTER

hideForm = (item) ->
  holder = item.parents('.holder')
  a_item = holder.children('span.a')
  b_item = holder.children('span.b')
  
  a_item.show()
  b_item.css('visibility', 'hidden')
  holder.find('.btn').off('click')
  a_item.click -> showForm item

$ -> $('span.a', 'h3, h5').click -> showForm $(@)