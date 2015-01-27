window.Likes or= {}

window.Likes.List = class List
  constructor: ->
    $(document.body).on "click", ".like_link", (event) ->
      event.preventDefault()
      table = $(this).closest('table')
      
      $.post("/like/" + table.data('target_type') + "/" + table.data('target_id')).done(=>
        $(this).hide()
        $(this).closest('table').find('.undo_like_link').show()
        likes_count = parseInt($(this).closest('table').find('.likes_counter_column').text()) + 1
        $(this).closest('table').find('.likes_counter_column').html(likes_count)
        $(this).closest('table').find('.dislike_link').data('liked', true)
        
        if $(this).data('disliked')
          $(this).closest('table').find('.undo_dislike_link').hide()
          $(this).closest('table').find('.dislike_link').show()
          dislikes_count = parseInt($(this).closest('table').find('.dislikes_counter_column').text()) - 1
          $(this).closest('table').find('.dislikes_counter_column').html(dislikes_count)
          $(this).data('disliked', false)
      ) 
    $(document.body).on "click", ".undo_like_link", (event) ->
      event.preventDefault()
      table = $(this).closest('table')
      
      $.post("/unlike/" + table.data('target_type') + "/" + table.data('target_id')).done(=>
        $(this).hide()
        $(this).closest('table').find('.like_link').show()
        $(this).closest('table').find('.dislike_link').data('liked', false)
        likes_count = parseInt($(this).closest('table').find('.likes_counter_column').text()) - 1
        $(this).closest('table').find('.likes_counter_column').html(likes_count)
      ).fail(->
        alert "Undoing like failed!"
      )
      
    $(document.body).on "click", ".dislike_link", (event) ->
      event.preventDefault()
      table = $(this).closest('table')
      
      $.post("/dislike/" + table.data('target_type') + "/" + table.data('target_id')).done(=>
        event.preventDefault()
        $(this).hide()
        $(this).closest('table').find('.undo_dislike_link').show()
        dislikes_count = parseInt($(this).closest('table').find('.dislikes_counter_column').text()) + 1
        $(this).closest('table').find('.dislikes_counter_column').html(dislikes_count)
        $(this).closest('table').find('.like_link').data('disliked', true)
        
        if $(this).data('liked')
          $(this).closest('table').find('.undo_like_link').hide()
          $(this).closest('table').find('.like_link').show()
          likes_count = parseInt($(this).closest('table').find('.likes_counter_column').text()) - 1
          $(this).closest('table').find('.likes_counter_column').html(likes_count)
          $(this).data('liked', false)
      ).fail(->
        alert "Disliking failed!"
      )
        
    $(document.body).on "click", ".undo_dislike_link", (event) ->
      event.preventDefault()
      table = $(this).closest('table')
      
      $.post("/unlike/" + table.data('target_type') + "/" + table.data('target_id')).done(=>
        $(this).hide()
        $(this).closest('table').find('.dislike_link').show()
        $(this).closest('table').find('.like_link').data('disliked', false)
        dislikes_count = parseInt($(this).closest('table').find('.dislikes_counter_column').text()) - 1
        $(this).closest('table').find('.dislikes_counter_column').html(dislikes_count)      
      ).fail(->
        alert "Undoing dislike failed!"
      )