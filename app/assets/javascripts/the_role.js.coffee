showForm = (e) ->
  $(e).children('span.a').hide()
  $(e).children('span.b').css('visibility', 'visible')
  $(e).children('span.a').off('click')
  $(e).find('.btn-warning').click ->
    hideForm(e)
    e.parentNode.reset()
  $(e).find('.btn-success').click ->
    e.parentNode.submit()
  $(e).children('span.b').find('input').keypress( (x) ->
    if x.which == 13
      e.parentNode.submit()
      console.log('enter pressed')
  )

hideForm = (e) ->
  $(e).children('span.a').show()
  $(e).children('span.b').css('visibility', 'hidden')
  $(e).find('.btn').off('click')
  $(e).children('span.a').click ->
    showForm(e)


$ ->
  $('.name span.a, .title span.a, .description span.a').click ->
    showForm(this.parentNode)
