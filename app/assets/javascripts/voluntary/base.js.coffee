$(document).ready ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip() 

  $( '.accordions' ).each (k, v) ->
    $(v).accordion({ autoHeight: false });
    
  $('.tabs').each (k, v) ->
    $(v).tabs
      autoHeight: false
      
      beforeLoad: (event, ui) ->
        ui.jqXHR.error ->
          json = null
          
          try
            json = jQuery.parseJSON(ui.jqXHR.responseText)
          catch e
          
          error = if json && json['error'] then json['error'] else 'Something went wrong'
          
          ui.panel.html error
    
  $(document).on "click", ".ui-tabs-panel .pagination a", (event) ->
    event.preventDefault()
    
    $.get($(this).attr('href'), (data) ->
      panel = $('.ui-tabs-panel[style*="display: block"]')[0]
      panel = $('.ui-tabs-panel')[0] unless panel
      $(panel).html(data)
    ).fail (jqXHR, textStatus, errorThrown) ->
      json = null
      
      try
        json = jQuery.parseJSON(jqXHR.responseText)
      catch e
        
      error = if json && json['error'] then json['error'] else 'Something went wrong'
    
      $($('.ui-tabs-panel[style*="display: block"]')[0]).html(error)
    
  $('form').on 'click', '.remove_fields', (event) ->
    #$(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').remove()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    target = $(this)
    
    if $(this).data('target')
      target = $('#' + $(this).data('target'))
      
    target.before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
  
  $('input[data-autocomplete]').each (k, v) ->
    $(v).autocomplete({
      source: $(this).attr('data-autocomplete'),
      select: (event, ui) ->
        $(this).val(ui.item.value)
        
        if ($(this).attr('id_element'))
          $($(this).attr('id_element')).val(ui.item.id)
        
        return false;
    });
    
  $( ".datepicker" ).each (k, v) ->
    $(v).datepicker({ dateFormat: "yy-mm-dd", changeYear: true, yearRange: "c-100:c+10" });
    
  $(document.body).on "click", ".remote_links", (event) ->
    $this = $(this)
    
    $.ajax(url: $this.attr('href'), type: "GET", dataType: "html").success (data) ->
      $($this.data("replace")).html(data)
      
    event.preventDefault()
    
  $(document.body).on "click", ".remote_modal_link", (event) ->
    $this = $(this)
    
    $.ajax(url: $this.attr('href'), type: "GET", dataType: "html").success (data) ->
      $('#bootstrap_modal').html(data)
      $('#bootstrap_modal').modal('show')
      
    event.preventDefault()
    
  $(document.body).on "click", "#close_bootstrap_modal_button", (event) ->
    $('#bootstrap_modal').modal('hide')
    event.preventDefault()
    