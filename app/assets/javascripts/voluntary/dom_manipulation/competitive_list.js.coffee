window.Voluntary or= {}; window.Voluntary.DomManipulation or= {}

window.Voluntary.DomManipulation.CompetitiveList = class CompetitiveList
  constructor: ->
    $(document.body).on "click", ".competitive_list_start_link", (event) ->
      event.preventDefault()
      window.Voluntary.DomManipulation.CompetitiveList.start()
      
    $(document.body).on "click", ".cancel_tournament_button", (event) ->
      event.preventDefault()
      window.Voluntary.DomManipulation.CompetitiveList.cancelTournament()   
      
    $(document.body).on "click", ".select_winner_button", (event) ->
      event.preventDefault()
      window.Voluntary.DomManipulation.CompetitiveList.appointWinnerOfMatchByInput()
    
  @start: () ->     
    matchesAlreadyExist = false
        
    if window.matches == undefined
      window.matches = []
    
    if window.matches.length > 0
      matchesAlreadyExist = true
      
    window.competitors = jQuery.map($('.competitive_list li'), (c) ->
      return $(c).data('id')
    )
    window.competitorsOfCompetitor = {} 
    window.defeatedCompetitorsByCompetitor = {}
    window.outmatchedCompetitorsByCompetitor = {}
    window.matchesWon = {}
    
    if matchesAlreadyExist
      if confirm('Remove previous results and start over?')
        window.matches = []
      else
        window.Voluntary.DomManipulation.CompetitiveList.removeMatchesOfNonExistingCompetitors() 
    
    window.Voluntary.DomManipulation.CompetitiveList.generateMatches()
    
    matchesWithoutWinner = jQuery.map(window.matches, (m) ->
      if m['winner_competitor'] == undefined
        return m
    )
    
    window.matchesLeft = matchesWithoutWinner.length
    
    if window.Voluntary.DomManipulation.CompetitiveList.nextMatch()
      $('#bootstrap_modal').modal('show')
      
  @removeMatchesOfNonExistingCompetitors: () ->
    $.each window.matches, (index, match) ->
      notExistingCompetitors = jQuery.map(match['competitors'], (c) ->
        if $.inArray(c, window.competitors) == -1
          return c
      )
      
      if notExistingCompetitors.length > 0
        window.Voluntary.DomManipulation.CompetitiveList.removeMatch(match)
      else
        if window.competitorsOfCompetitor[match['competitors'][0]] == undefined
          window.competitorsOfCompetitor[match['competitors'][0]] = []
        
        window.competitorsOfCompetitor[match['competitors'][0]].push match['competitors'][1]
      
        if window.competitorsOfCompetitor[match['competitors'][1]] == undefined
          window.competitorsOfCompetitor[match['competitors'][1]] = []
        
        window.competitorsOfCompetitor[match['competitors'][1]].push match['competitors'][0]
        
        unless match['winner_competitor'] == undefined
          loserId = window.Voluntary.DomManipulation.CompetitiveList.otherCompetitorOfMatch(match, match['winner_competitor'])
          window.Voluntary.DomManipulation.CompetitiveList.incrementMatchesWon(match['winner_competitor'], loserId)
  
  @removeMatch: (match) ->
    list = []
    
    $.each window.matches, (index, workingMatch) ->
      
      unless JSON.stringify(workingMatch) == JSON.stringify(match)
        list.push workingMatch
        
    window.matches = list 
          
  @generateMatches: () ->
    $.each window.competitors, (index, competitor_id) ->
      if window.competitorsOfCompetitor[competitor_id] == undefined
        window.competitorsOfCompetitor[competitor_id] = []
        
      $.each window.competitors, (index, otherCompetitorId) ->
        if window.competitorsOfCompetitor[otherCompetitorId] == undefined
          window.competitorsOfCompetitor[otherCompetitorId] = []
        
        if competitor_id != otherCompetitorId && $.inArray(otherCompetitorId, window.competitorsOfCompetitor[competitor_id]) == -1
          window.matches.push { competitors: [competitor_id, otherCompetitorId] }
          window.competitorsOfCompetitor[competitor_id].push otherCompetitorId
          window.competitorsOfCompetitor[otherCompetitorId].push competitor_id
          
  @nextMatch: () ->
    window.currentMatch = null
    
    $.each window.matches, (index, match) ->
      if match['winner_competitor'] == undefined
        window.currentMatch = match
        window.currentMatchIndex = index
        
        return
    
    if window.currentMatch == null
      alert 'No matches to rate left.'
      
      return false
    else  
      radioButtons = ""
      i = 0
      
      $.each window.currentMatch['competitors'], (index, competitorId) ->
        competitorDomElement = $('#competitor_' + competitorId)
        checked = ' checked="checked"'
        checked = '' if i == 1
        radioButtons += '<input type="radio" ' + checked + ' name="winner" value="' + competitorId + '" style="position:relative; left: -10px; top:-5px "/>' +
        $(competitorDomElement).find('.competitorName').html()
        radioButtons += '&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' if i == 0
        i += 1
        
      $('#bootstrap_modal').html(
        '<form class="form-inline" style="margin:0px;">' +
        '<div class="modal-header">' +
        '<button type="button" id="close_bootstrap_modal_button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
        '<h3>Appoint Winner (' + window.matchesLeft + ' matches left)</h3>' +
        '</div>' +
        '<div class="modal-body" style="overflow-y:none;">' +
        '<div class="controls" style="margin-left:50px">' + radioButtons + '</div>' +
        '</div>' +
        '<div class="modal-footer" style="text-align:left;">' +
        '<p>' +
        '<button type="button" class="cancel_tournament_button" class="btn">Cancel</button> &nbsp;&nbsp;&nbsp;&nbsp; ' +
        '<button type="button" class="select_winner_button" class="btn btn-primary">Submit</button>' +
        '</p>' +
        '</form>'
      )  
      
      return true
    
  @letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser: (winnerId, loserId) ->
    $.each window.matches, (index, match) ->  
      matchOfWinner = $.inArray(winnerId, match['competitors'])
      matchCompetitorsWhichIncludeLoser = null
      
      unless matchOfWinner == -1
        matchCompetitorsWhichIncludeLoser = jQuery.map(match['competitors'], (c) ->
          if $.inArray(c, window.Voluntary.DomManipulation.CompetitiveList.defeatedCompetitorsByCompetitor(loserId)) > -1
            return c
        )
        
      if matchOfWinner > -1 && matchCompetitorsWhichIncludeLoser.length > 0
        window.matches[index]['winner_competitor'] = winnerId

  @defeatedCompetitorsByCompetitor: (competitorId) ->
    if window.defeatedCompetitorsByCompetitor[competitorId] == undefined
      window.defeatedCompetitorsByCompetitor[competitorId] = []
      
    return window.defeatedCompetitorsByCompetitor[competitorId]

  @otherCompetitorOfMatch: (match, competitorId) ->
    otherCompetitors = jQuery.map(match['competitors'], (c) ->
      if c != competitorId
        return c
    )
    return otherCompetitors[0]

  @appointWinnerOfMatchByInput: () ->
    winnerId = parseInt($("input[name='winner']:checked").val())
    loserId = window.Voluntary.DomManipulation.CompetitiveList.otherCompetitorOfMatch(window.currentMatch, winnerId)
    
    window.Voluntary.DomManipulation.CompetitiveList.appointWinnerOfMatch(window.currentMatchIndex, winnerId, loserId)
    
    unless window.Voluntary.DomManipulation.CompetitiveList.nextMatch()
      window.Voluntary.DomManipulation.CompetitiveList.sortByMostMatchesWon()
      $('#bootstrap_modal').modal('hide')
      
  @appointWinnerOfMatch: (matchIndex, winnerId, loserId) ->
    window.matches[matchIndex]['winner_competitor'] = winnerId
    window.matchesLeft = window.matchesLeft - 1
    
    window.Voluntary.DomManipulation.CompetitiveList.incrementMatchesWon(winnerId, loserId)
    window.Voluntary.DomManipulation.CompetitiveList.letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser(winnerId, loserId)
    window.Voluntary.DomManipulation.CompetitiveList.letOutMatchedCompetitorsOfWinnerWinAgainstLoser(winnerId, loserId)
    
  @letOutMatchedCompetitorsOfWinnerWinAgainstLoser: (winnerId, loserId) ->
    $.each window.Voluntary.DomManipulation.CompetitiveList.outmatchedCompetitorsByCompetitor(winnerId), (index, competitorId) ->
      window.Voluntary.DomManipulation.CompetitiveList.letCompetitorWinMatchAgainstOtherCompetitor(competitorId, loserId)

  @outmatchedCompetitorsByCompetitor: (competitorId) ->
    if window.outmatchedCompetitorsByCompetitor[competitorId] == undefined
      window.outmatchedCompetitorsByCompetitor[competitorId] = []
      
    return window.outmatchedCompetitorsByCompetitor[competitorId]

  @letCompetitorWinMatchAgainstOtherCompetitor: (winnerId, loserId) ->
    $.each window.matches, (index, match) ->
      if $.inArray(winnerId, match['competitors']) > -1 && $.inArray(loserId, match['competitors']) > -1 && window.matches[index]['winner_competitor'] != winnerId
        window.Voluntary.DomManipulation.CompetitiveList.appointWinnerOfMatch(index, winnerId, loserId)
        
        return

  @incrementMatchesWon: (winnerId, loserId) ->
    if window.matchesWon[winnerId] == undefined
      window.matchesWon[winnerId] = 0
      
    window.matchesWon[winnerId] = window.matchesWon[winnerId] + 1
    
    window.Voluntary.DomManipulation.CompetitiveList.defeatedCompetitorsByCompetitor(winnerId)  
    window.defeatedCompetitorsByCompetitor[winnerId].push loserId  
    
    window.Voluntary.DomManipulation.CompetitiveList.outmatchedCompetitorsByCompetitor(loserId)  
    window.outmatchedCompetitorsByCompetitor[loserId].push winnerId
     
  @cancelTournament: ->
    window.Voluntary.DomManipulation.CompetitiveList.sortByMostMatchesWon()
    $('#bootstrap_modal').modal('hide')
      
  @sortByMostMatchesWon: ->
    $.each window.competitors, (index, competitorId) ->
      count = 0
      
      unless window.matchesWon[competitorId] == undefined 
        count = window.matchesWon[competitorId]
      
      $('#competitor_' + competitorId).data('wins', count)
      
    $wrapper = $('.competitive_list')
    
    $wrapper.find('li').sort((a, b) ->
      +parseInt($(b).data('wins')) - +parseInt($(a).data('wins'))
    ).appendTo $wrapper
    
    positions = {}
    currentPosition = 1
    
    $.each $('.competitive_list li'), (index, element) ->
      positions[currentPosition] = $(element).data('id')
      $(element).data('position', currentPosition)  
      $(element).find('.competitorPosition').html(currentPosition)
      currentPosition += 1  
      
    data = { _method: 'put', positions: positions, matches: JSON.stringify(window.matches) }  
    $.post $('.competitive_list').data('update-all-positions-path'), data    
