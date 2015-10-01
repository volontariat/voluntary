@toggleText = ->
  showChar = 255
  ellipsesText = '...'
  moreText = 'Show more >'
  lessText = 'Show less'
  
  $('.more').each ->
    content = $(this).html()
    
    if content.length > showChar
      c = content.substr(0, showChar)
      h = content.substr(showChar, content.length - showChar)
      html = c + '<span class="more_ellipses">' + ellipsesText + '&nbsp;</span><span style="display:none;">' + h + '</span>&nbsp;&nbsp;<a href="" class="more_link" style="display:block;">' + moreText + '</a>'
      $(this).html html
    
  $('.more_link').click ->
    if $(this).hasClass('less')
      $(this).removeClass 'less'
      $(this).html moreText
    else
      $(this).addClass 'less'
      $(this).html lessText
    
    $(this).siblings('.more_ellipses').toggle()
    $(this).prev().toggle()
    
    false