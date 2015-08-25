$(document).ready ->
  $.get '/workflow/user/stories', (data) ->
   $('#stories').html data
   
  $('#workflow_user_tabs a').click (e) ->
    e.preventDefault()
    
    $.get $(this).data('url'), (data) =>
      $($(this).attr('href')).html data
    
    $(this).tab 'show'