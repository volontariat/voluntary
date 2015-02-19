class @CompetitiveList
  competitiveListOptions: []
  competitors: []
  competitorsOfCompetitor: {}
  defeatedCompetitorsByCompetitor: {}
  outmatchedCompetitorsByCompetitor: {}
  matchesLeft: 0
  currentMatch: null
  currentMatchIndex: 0
  currentAutoWinnerMatches: []
  
  constructor: (options) ->
    @competitiveListOptions = options
    @competitiveListOptions ||= {}
    
    $(document.body).on "click", ".competitive_list_start_link", (event) =>
      event.preventDefault()
      @start()
      
    $(document.body).on "click", ".cancel_tournament_button", (event) =>
      event.preventDefault()
      @cancelTournament()   
      
    $(document.body).on "click", ".select_winner_button", (event) =>
      event.preventDefault()
      @appointWinnerOfMatchByInput()
    
    $(document.body).on "click", ".read_current_auto_winner_matches_button", (event) =>
      event.preventDefault()
      
      unless @nextMatch()
        @sortByMostWins()
        $('#bootstrap_modal').modal('hide')
    
  start: () ->     
    matchesAlreadyExist = false
    window.matches ||= []
    
    if window.matches.length > 0
      matchesAlreadyExist = true
      
    @competitors = jQuery.map($('.competitive_list li'), (c) ->
      return $(c).data('id')
    )
    @competitorsOfCompetitor = {}
    @defeatedCompetitorsByCompetitor = {}
    @outmatchedCompetitorsByCompetitor = {}
    
    if matchesAlreadyExist
      if confirm('Remove previous results and start over?')
        window.matches = []
      else
        @removeMatchesOfNonExistingCompetitors() 
    
    @generateMatches()
    
    matchesWithoutWinner = jQuery.map(window.matches, (m) ->
      if m['winner_competitor'] == undefined
        return m
    )
    
    @matchesLeft = matchesWithoutWinner.length
    
    if @nextMatch()
      $('#bootstrap_modal').modal('show')
      
  removeMatchesOfNonExistingCompetitors: () ->
    $.each window.matches, (index, match) =>
      notExistingCompetitors = jQuery.map(match['competitors'], (c) =>
        if $.inArray(c, @competitors) == -1
          return c
      )
      
      if notExistingCompetitors.length > 0
        window.matches = @removeItemFromArray(window.matches, match)
      else
        @competitorsOfCompetitor[match['competitors'][0]] ||= []
        @competitorsOfCompetitor[match['competitors'][0]].push match['competitors'][1]
        @competitorsOfCompetitor[match['competitors'][1]] ||= []
        @competitorsOfCompetitor[match['competitors'][1]].push match['competitors'][0]
        
        unless match['winner_competitor'] == undefined
          loserId = @otherCompetitorOfMatch(match, match['winner_competitor'])
          @updateDefeatedAndOutmatchedCompetitorsByCompetitor(match['winner_competitor'], loserId)
  
  removeItemFromArray: (array, item) ->
    list = []
    
    $.each array, (index, workingItem) =>
      unless JSON.stringify(workingItem) == JSON.stringify(item)
        list.push workingItem
        
    return list
          
  generateMatches: () ->
    $.each @competitors, (index, competitorId) =>
      @competitorsOfCompetitor[competitorId] ||= []
        
      $.each @competitors, (index, otherCompetitorId) =>
        @competitorsOfCompetitor[otherCompetitorId] ||= []
        
        if competitorId != otherCompetitorId && $.inArray(otherCompetitorId, @competitorsOfCompetitor[competitorId]) == -1
          window.matches.push { competitors: [competitorId, otherCompetitorId] }
          @competitorsOfCompetitor[competitorId].push otherCompetitorId
          @competitorsOfCompetitor[otherCompetitorId].push competitorId
          
  nextMatch: () ->
    if @currentAutoWinnerMatches.length > 0
      @showCurrentAutoWinnerMatches()
      
      return true
      
    @currentMatch = null
    
    $.each window.matches, (index, match) =>
      if match['winner_competitor'] == undefined
        @currentMatch = match
        @currentMatchIndex = index
        
        return false
    
    if @currentMatch == null
      alert 'No matches to rate left.'
      
      return false
    else  
      radioButtons = []
      competitorStrings = []
      i = 0
      
      $.each @currentMatch['competitors'], (index, competitorId) =>
        checked = ' checked="checked"'
        checked = '' if i == 1
        radioButtons.push ('<input type="radio" ' + checked + ' name="winner" value="' + competitorId + '" style="position:relative; top:-5px "/>')
        competitorStrings.push @nameOfCompetitor(competitorId, true)  
          
        i += 1
        
      html = """
<form class="form-inline" style="margin:0px;">
  <div class="modal-header">
    <button type="button" id="close_bootstrap_modal_button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Appoint Winner (#{@matchesLeft} matches left)</h3>
  </div>
  <div class="modal-body" style="overflow-y:none;">
    <div class="controls" style="margin-left:50px">
      <table><tr>      
          <td style="width:325px">
            #{competitorStrings[0]}
          </td>
          <td>#{radioButtons[0]}</td>
          <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>
          <td>#{radioButtons[1]}</td>
          <td>
            &nbsp;&nbsp;&nbsp;
          </td>
          <td style="width:325px">
            #{competitorStrings[1]}
          </td>
        </tr>
      </table>
    </div>
  </div>
  <div class="modal-footer" style="text-align:left;">
    <p>
      <button type="button" class="cancel_tournament_button" class="btn">Cancel</button> &nbsp;&nbsp;&nbsp;&nbsp;
      <button type="button" class="select_winner_button" class="btn btn-primary">Submit</button>
    </p>
  </div>
</form>
"""

      $('#bootstrap_modal').html(html)
      
      return true
    
  showCurrentAutoWinnerMatches: () ->
    @currentMatch = window.matches[@currentMatchIndex]
    rows = ""
    
    $.each @currentAutoWinnerMatches, (index, match) =>
      even_or_odd = ''
      
      if index % 2 == 0
        even_or_odd = 'even'
      else
        even_or_odd = 'odd'
        
      rows +=     html = """
<tr class="#{even_or_odd}">
  <td style="width:200px">#{@nameOfCompetitor(match['winner_competitor'], false)}</td>
  <td><input type="radio" checked="checked" disabled="disabled"/></td>
  <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>
  <td><input type="radio" disabled="disabled"/></td>
  <td>&nbsp;&nbsp;&nbsp;</td>
  <td style="width:200px">#{@nameOfCompetitor(@otherCompetitorOfMatch(match, match['winner_competitor']), false)}</td>
  <td style="text-align:center">
    <a class="bootstrap_tooltip" href="#" data-toggle="tooltip" data-html="true" title="#{match['auto_winner_reason']}">
      <i class="icon-question-sign"/>
    </a>
  </td>
  <td style="width:200px">#{@nameOfCompetitor(match['foot_note_competitor'], false)}</td>
</tr>        
"""     
        
    html = """  
<div class="modal-header">
  <button type="button" id="close_bootstrap_modal_button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
  <h3>Auto Winners due to Result of last Match</h3>
</div>
<div class="modal-body" style="overflow-y:none;">
  <table>
    <tr>
      <td><strong>Last Match was:&nbsp;&nbsp;</strong></td>
      <td>#{@nameOfCompetitor(@currentMatch['winner_competitor'], false)}</td>
      <td>&nbsp;&nbsp;<input type="radio" checked="checked" disabled="disabled"/></td>
      <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>
      <td><input type="radio" disabled="disabled"/></td>
      <td>&nbsp;&nbsp;&nbsp;</td>
      <td>#{@nameOfCompetitor(@otherCompetitorOfMatch(@currentMatch, @currentMatch['winner_competitor']), false)}</td>
    </tr>
  </table>
  <table class="table table-striped">
    <thead>
      <tr class="odd">
        <th>Winner</th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
        <th>Loser</th>
        <th>Reason</th>
        <th>[1]</th>
      </tr>
    </thead>
    <tbody>
      #{rows}
    </tbody>
  </table>
</div>
<div class="modal-footer" style="text-align:left;">
  <p>
    <button type="button" class="read_current_auto_winner_matches_button" class="btn btn-primary">OK</button>
  </p>
</div>     
"""    

    $('#bootstrap_modal').html(html)
    $('.bootstrap_tooltip').tooltip()
    @currentAutoWinnerMatches = []
    
  letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser: (winnerId, loserId) ->
    @defeatedCompetitorsByCompetitor[loserId] ||= []
    
    $.each window.matches, (index, match) =>  
      return true if match['winner_competitor'] == winnerId || $.inArray(winnerId, match['competitors']) == -1
      
      matchCompetitorsWhichIncludeLoser = jQuery.map(match['competitors'], (c) =>
        if $.inArray(c, @defeatedCompetitorsByCompetitor[loserId]) > -1
          return c
      )
        
      return true if matchCompetitorsWhichIncludeLoser.length == 0
        
      otherLoserId = @otherCompetitorOfMatch(match, winnerId)
      
      @changeCompetitorsComparisonResult(winnerId, otherLoserId) unless match['winner_competitor'] == undefined
        
      @appointWinnerOfMatch(index, winnerId, otherLoserId, match['winner_competitor'] == undefined)
      window.matches[index]['auto_winner'] = true
      match = window.matches[index]
      
      competitorsWhichAreLoserOfLastMatch = jQuery.map(match['competitors'], (c) =>
        if c == @otherCompetitorOfMatch(@currentMatch, @currentMatch['winner_competitor'])
          return c
      )
      
      match['foot_note_competitor'] = loserId
      
      if competitorsWhichAreLoserOfLastMatch.length == 1
        match['auto_winner_reason'] = 'loser has been defeated because he loses against the loser <sup>[1]</sup> of last match'
      else
        match['auto_winner_reason'] = 'loser has been defeated because he loses against the loser <sup>[1]</sup> of last auto winner match'
        
      @currentAutoWinnerMatches.push match
      
  changeCompetitorsComparisonResult: (winnerId, loserId) ->
    @outmatchedCompetitorsByCompetitor[winnerId] ||= []
    @outmatchedCompetitorsByCompetitor[winnerId] = @removeItemFromArray(@outmatchedCompetitorsByCompetitor[winnerId], loserId)
    @defeatedCompetitorsByCompetitor[loserId] = @removeItemFromArray(@outmatchedCompetitorsByCompetitor[loserId], winnerId)
    
  getDefeatedCompetitorsByCompetitor: (competitorId) ->
    @defeatedCompetitorsByCompetitor[competitorId] ||= []
      
    return @defeatedCompetitorsByCompetitor[competitorId]

  otherCompetitorOfMatch: (match, competitorId) ->
    otherCompetitors = jQuery.map(match['competitors'], (c) ->
      if c != competitorId
        return c
    )
    return otherCompetitors[0]

  nameOfCompetitor: (competitorId, considerProc) ->
    competitorDomElement = $('#competitor_' + competitorId)
    
    if considerProc == false || @competitiveListOptions['competitor_name_proc'] == undefined || $(competitorDomElement).find('.competitor_name').data('proc-argument') == undefined
      return $(competitorDomElement).find('.competitor_name').html()  
    else
      return @competitiveListOptions['competitor_name_proc']($(competitorDomElement).find('.competitor_name').data('proc-argument'))
     
  appointWinnerOfMatchByInput: () ->
    winnerId = parseInt($("input[name='winner']:checked").val())
    loserId = @otherCompetitorOfMatch(@currentMatch, winnerId)
    
    @appointWinnerOfMatch(@currentMatchIndex, winnerId, loserId, true)
    
    unless @nextMatch()
      @sortByMostWins()
      $('#bootstrap_modal').modal('hide')
      
  appointWinnerOfMatch: (matchIndex, winnerId, loserId, decrementMatchesLeft) ->
    window.matches[matchIndex]['winner_competitor'] = winnerId
    @matchesLeft = @matchesLeft - 1 if decrementMatchesLeft
    
    @updateDefeatedAndOutmatchedCompetitorsByCompetitor(winnerId, loserId)
    @letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser(winnerId, loserId)
    @letOutMatchedCompetitorsOfWinnerWinAgainstLoser(winnerId, loserId)
    
  letOutMatchedCompetitorsOfWinnerWinAgainstLoser: (winnerId, loserId) ->
    @outmatchedCompetitorsByCompetitor[winnerId] ||= []
    
    $.each @outmatchedCompetitorsByCompetitor[winnerId], (index, competitorId) =>
      $.each window.matches, (index, match) =>
        if $.inArray(competitorId, match['competitors']) > -1 && $.inArray(loserId, match['competitors']) > -1 && match['winner_competitor'] != competitorId
          window.matches[index]['auto_winner'] = true
          winner_changed = false
          
          unless match['winner_competitor']  == undefined
            @changeCompetitorsComparisonResult(competitorId, loserId)
            winner_changed = true
            
          @appointWinnerOfMatch(index, competitorId, loserId, match['winner_competitor']  == undefined)
          match = window.matches[index]
          match['winner_changed'] = winner_changed
          
          competitorsWhichAreLoserOfLastMatch = jQuery.map(match['competitors'], (c) =>
            if c == @otherCompetitorOfMatch(@currentMatch, @currentMatch['winner_competitor'])
              return c
          )
          
          match['foot_note_competitor'] = winnerId
          
          if competitorsWhichAreLoserOfLastMatch.length == 1
            match['auto_winner_reason'] = "loser of last match has been defeated by outmatched competitor of<br/>winner <sup>[1]</sup>"
          else
            match['auto_winner_reason'] = "loser of last auto winner match has been defeated by outmatched competitor of winner <sup>[1]</sup>"
            
          @currentAutoWinnerMatches.push match
          
          return false

  updateDefeatedAndOutmatchedCompetitorsByCompetitor: (winnerId, loserId) ->
    @defeatedCompetitorsByCompetitor[winnerId] ||= []
    @defeatedCompetitorsByCompetitor[winnerId].push loserId  
     
    @outmatchedCompetitorsByCompetitor[loserId] ||= []
    @outmatchedCompetitorsByCompetitor[loserId].push winnerId
     
  cancelTournament: ->
    @sortByMostWins()
    $('#bootstrap_modal').modal('hide')
      
  sortByMostWins: ->
    winsByCompetitor = {}
    
    $.each @competitors, (index, competitorId) =>
      winsByCompetitor[competitorId] = 0

    $.each window.matches, (index, match) ->
      winsByCompetitor[match['winner_competitor']] += 1
    
    $.each Object.keys(winsByCompetitor), (index, competitorId) ->
      $('#competitor_' + competitorId).data 'wins', winsByCompetitor[competitorId]
      
    $wrapper = $('.competitive_list')
    
    $wrapper.find('li').sort((a, b) ->
      +parseInt($(b).data('wins')) - +parseInt($(a).data('wins'))
    ).appendTo $wrapper
    
    positions = {}
    currentPosition = 1
    
    $.each $('.competitive_list li'), (index, element) ->
      positions[currentPosition] = $(element).data('id')
      $(element).data('position', currentPosition)  
      $(element).find('.competitor_position').html(currentPosition)
      currentPosition += 1  
      
    data = { _method: 'put', positions: positions, matches: JSON.stringify(window.matches) }  
    $.post $('.competitive_list').data('update-all-positions-path'), data   