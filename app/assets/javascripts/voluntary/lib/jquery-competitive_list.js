(function() {
  (function($, window) {
    var CompetitiveList;
    CompetitiveList = CompetitiveList = (function() {
      CompetitiveList.prototype.jqueryInstanceMethodName = 'competitiveList';

      CompetitiveList.prototype.defaults = {};

      CompetitiveList.prototype.id = null;

      CompetitiveList.prototype.competitors = [];

      CompetitiveList.prototype.competitorsOfCompetitor = {};

      CompetitiveList.prototype.defeatedCompetitorsByCompetitor = {};

      CompetitiveList.prototype.outmatchedCompetitorsByCompetitor = {};

      CompetitiveList.prototype.matches = [];

      CompetitiveList.prototype.matchesLeft = 0;

      CompetitiveList.prototype.currentMatch = null;

      CompetitiveList.prototype.currentMatchIndex = 0;

      CompetitiveList.prototype.currentAutoWinnerMatches = [];

      CompetitiveList.prototype.movingCompetitorToPosition = false;

      function CompetitiveList(el, options) {
        if (el) {
          this.init(el, options);
        }
      }

      CompetitiveList.prototype.init = function(el, options) {
        this.options = $.extend({}, this.defaults, options);
        this.$el = $(el);
        this.id = this.$el.attr('id');
        $.data(el, this.constructor.prototype.jqueryInstanceMethodName, this);
        this.$el.find('.competitive_list_start_link').on('click', (function(_this) {
          return function(event) {
            event.preventDefault();
            return _this.start();
          };
        })(this));
        this.$el.find('.save_match_results_link').on('click', (function(_this) {
          return function(event) {
            event.preventDefault();
            _this.sortByMostWins();
            return _this.$el.find('.save_match_results_link').hide();
          };
        })(this));
        $(document.body).on('click', '#bootstrap_modal .cancel_tournament_button', (function(_this) {
          return function(event) {
            event.preventDefault();
            return _this.cancelTournament();
          };
        })(this));
        return $(document.body).on('click', '#bootstrap_modal .select_winner_button', (function(_this) {
          return function(event) {
            event.preventDefault();
            return _this.appointWinnerOfMatchByInput();
          };
        })(this));
      };

      CompetitiveList.meaningOfLife = function() {
        return 42;
      };

      CompetitiveList.prototype.start = function() {
        var matchesAlreadyExist, matchesWithoutWinner;
        matchesAlreadyExist = false;
        this.matches || (this.matches = []);
        if (this.matches.length > 0) {
          matchesAlreadyExist = true;
        }
        this.setCompetitors();
        this.competitorsOfCompetitor = {};
        this.defeatedCompetitorsByCompetitor = {};
        this.outmatchedCompetitorsByCompetitor = {};
        if (matchesAlreadyExist) {
          if (confirm('Remove previous results and start over?')) {
            this.matches = [];
          } else {
            this.removeMatchesOfNonExistingCompetitors();
          }
        }
        this.generateMatches();
        matchesWithoutWinner = jQuery.map(this.matches, function(m) {
          if (m['winner'] === void 0) {
            return m;
          }
        });
        this.matchesLeft = matchesWithoutWinner.length;
        if (this.nextMatch(true)) {
          return $('#bootstrap_modal').modal('show');
        }
      };

      CompetitiveList.prototype.setCompetitors = function() {
        return this.competitors = jQuery.map(this.$el.find('.competitive_list li'), function(c) {
          return $(c).data('id');
        });
      };

      CompetitiveList.prototype.removeMatchesOfNonExistingCompetitors = function() {
        return $.each(this.matches, (function(_this) {
          return function(index, match) {
            var base, base1, loserId, name, name1, notExistingCompetitors;
            notExistingCompetitors = jQuery.map(match['competitors'], function(c) {
              if ($.inArray(c, _this.competitors) === -1) {
                return c;
              }
            });
            if (notExistingCompetitors.length > 0) {
              return _this.matches = _this.removeItemFromArray(_this.matches, match);
            } else {
              (base = _this.competitorsOfCompetitor)[name = match['competitors'][0]] || (base[name] = []);
              _this.competitorsOfCompetitor[match['competitors'][0]].push(match['competitors'][1]);
              (base1 = _this.competitorsOfCompetitor)[name1 = match['competitors'][1]] || (base1[name1] = []);
              _this.competitorsOfCompetitor[match['competitors'][1]].push(match['competitors'][0]);
              if (match['winner'] !== void 0) {
                loserId = _this.otherCompetitorOfMatch(match, match['winner']);
                return _this.updateDefeatedAndOutmatchedCompetitorsByCompetitor(match['winner'], loserId);
              }
            }
          };
        })(this));
      };

      CompetitiveList.prototype.removeItemFromArray = function(array, item) {
        var list;
        list = [];
        jQuery.each(array, function(index, workingItem) {
          if (JSON.stringify(workingItem) !== JSON.stringify(item)) {
            return list.push(workingItem);
          }
        });
        return list;
      };

      CompetitiveList.prototype.generateMatches = function() {
        return $.each(this.competitors, (function(_this) {
          return function(index, competitorId) {
            var base;
            (base = _this.competitorsOfCompetitor)[competitorId] || (base[competitorId] = []);
            return $.each(_this.competitors, function(index, otherCompetitorId) {
              var base1;
              (base1 = _this.competitorsOfCompetitor)[otherCompetitorId] || (base1[otherCompetitorId] = []);
              if (competitorId !== otherCompetitorId && $.inArray(otherCompetitorId, _this.competitorsOfCompetitor[competitorId]) === -1) {
                _this.matches.push({
                  competitors: [competitorId, otherCompetitorId]
                });
                _this.competitorsOfCompetitor[competitorId].push(otherCompetitorId);
                return _this.competitorsOfCompetitor[otherCompetitorId].push(competitorId);
              }
            });
          };
        })(this));
      };

      CompetitiveList.prototype.nextMatch = function(from_start) {
        var autoWinnerMatchesHtml, competitorStrings, html, i, modalBodyHtml, modalFooterHtml, modalTitle, radioButtons, rows;
        autoWinnerMatchesHtml = '';
        if (this.currentAutoWinnerMatches.length > 0) {
          this.currentMatch = this.matches[this.currentMatchIndex];
          rows = "";
          $.each(this.currentAutoWinnerMatches, (function(_this) {
            return function(index, match) {
              var even_or_odd, manualWinnerChangedHtml;
              even_or_odd = '';
              if (index % 2 === 0) {
                even_or_odd = 'even';
              } else {
                even_or_odd = 'odd';
              }
              manualWinnerChangedHtml = '';
              if (match['manual_winner_changed'] === true) {
                manualWinnerChangedHtml = "<a class=\"bootstrap_tooltip\" href=\"#\" data-toggle=\"tooltip\" title=\"The winner you once have set has been changed automatically!\">\n  <i class='icon-warning-sign'/>\n</a>";
              }
              return rows += "<tr class=\"" + even_or_odd + "\">\n  <td>\n    " + manualWinnerChangedHtml + "\n  </td>\n  <td style=\"width:200px\">" + (_this.nameOfCompetitor(match['winner'], false)) + "</td>\n  <td><input type=\"radio\" checked=\"checked\" disabled=\"disabled\"/></td>\n  <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>\n  <td><input type=\"radio\" disabled=\"disabled\"/></td>\n  <td>&nbsp;&nbsp;&nbsp;</td>\n  <td style=\"width:200px\">" + (_this.nameOfCompetitor(_this.otherCompetitorOfMatch(match, match['winner']), false)) + "</td>\n  <td style=\"text-align:center\">\n    <a class=\"bootstrap_tooltip\" href=\"#\" data-toggle=\"tooltip\" data-html=\"true\" title=\"" + match['auto_winner_reason'] + "\">\n      <i class=\"icon-question-sign\"/>\n    </a>\n  </td>\n  <td style=\"width:200px\">" + (_this.nameOfCompetitor(match['foot_note_competitor'], false)) + "</td>\n</tr>        ";
            };
          })(this));
          autoWinnerMatchesHtml = "<h4>Auto Winners due to Result of last Match</h4>\n<table>\n  <tr>\n    <td><strong>Last Match was:&nbsp;&nbsp;</strong></td>\n    <td>" + (this.nameOfCompetitor(this.currentMatch['winner'], false)) + "</td>\n    <td>&nbsp;&nbsp;<input type=\"radio\" checked=\"checked\" disabled=\"disabled\"/></td>\n    <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>\n    <td><input type=\"radio\" disabled=\"disabled\"/></td>\n    <td>&nbsp;&nbsp;&nbsp;</td>\n    <td>" + (this.nameOfCompetitor(this.otherCompetitorOfMatch(this.currentMatch, this.currentMatch['winner']), false)) + "</td>\n  </tr>\n</table>\n<table class=\"table table-striped\">\n  <thead>\n    <tr class=\"odd\">\n      <th></th>\n      <th>Winner</th>\n      <th></th>\n      <th></th>\n      <th></th>\n      <th></th>\n      <th>Loser</th>\n      <th>Reason</th>\n      <th>[1]</th>\n    </tr>\n  </thead>\n  <tbody>\n    " + rows + "\n  </tbody>\n</table>   ";
        }
        this.currentMatch = null;
        $.each(this.matches, (function(_this) {
          return function(index, match) {
            if (match['winner'] === void 0) {
              _this.currentMatch = match;
              _this.currentMatchIndex = index;
              return false;
            }
          };
        })(this));
        if (from_start === true && this.currentMatch === null) {
          alert('No matches to rate left.');
          return false;
        } else {
          this.$el.find('.save_match_results_link').show();
        }
        modalBodyHtml = '';
        modalTitle = '';
        modalFooterHtml = '';
        if (this.currentMatch === null) {
          modalTitle = 'No matches to rate left.';
          modalFooterHtml = "<p>\n  <button type=\"button\" class=\"cancel_tournament_button\" class=\"btn\">Save match results and close window</button>\n</p>      ";
        } else {
          modalTitle = "Appoint Winner (" + this.matchesLeft + " matches left)";
          radioButtons = [];
          competitorStrings = [];
          i = 0;
          $.each(this.currentMatch['competitors'], (function(_this) {
            return function(index, competitorId) {
              var checked;
              checked = ' checked="checked"';
              if (i === 1) {
                checked = '';
              }
              radioButtons.push('<input type="radio" ' + checked + ' name="winner" value="' + competitorId + '" style="position:relative; top:-5px "/>');
              competitorStrings.push(_this.nameOfCompetitor(competitorId, true));
              return i += 1;
            };
          })(this));
          modalBodyHtml += "<div class=\"controls\" style=\"margin-left:50px\">\n  <table>\n    <tr>      \n      <td style=\"width:325px; text-align:right;\">\n        " + competitorStrings[0] + "\n      </td>\n      <td>&nbsp;&nbsp;&nbsp;</td>\n      <td>" + radioButtons[0] + "</td>\n      <td>&nbsp;&nbsp;VS.&nbsp;&nbsp;&nbsp;</td>\n      <td>" + radioButtons[1] + "</td>\n      <td>\n        &nbsp;&nbsp;&nbsp;\n      </td>\n      <td style=\"width:325px\">\n        " + competitorStrings[1] + "\n      </td>\n    </tr>\n  </table>\n</div>     ";
          modalFooterHtml = "<p>\n  <button type=\"button\" class=\"cancel_tournament_button\" class=\"btn\">Save match results and close window</button> &nbsp;&nbsp;&nbsp;&nbsp;\n  <button type=\"button\" class=\"select_winner_button\" class=\"btn btn-primary\">Submit</button>\n</p>";
        }
        modalBodyHtml += autoWinnerMatchesHtml;
        html = "<form class=\"form-inline\" style=\"margin:0px;\">\n  <div class=\"modal-header\">\n    <button type=\"button\" id=\"close_bootstrap_modal_button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>\n    <h3>" + modalTitle + "</h3>\n  </div>\n  <div class=\"modal-body\" style=\"overflow-y:auto;\">\n    " + modalBodyHtml + "\n  </div>\n  <div class=\"modal-footer\" style=\"text-align:left;\">\n    " + modalFooterHtml + "\n  </div>\n</form>";
        $('#bootstrap_modal').html(html);
        $('.bootstrap_tooltip').tooltip();
        this.currentAutoWinnerMatches = [];
        return true;
      };

      CompetitiveList.prototype.otherCompetitorOfMatch = function(match, competitorId) {
        var otherCompetitors;
        otherCompetitors = jQuery.map(match['competitors'], function(c) {
          if (c !== competitorId) {
            return c;
          }
        });
        return otherCompetitors[0];
      };

      CompetitiveList.prototype.nameOfCompetitor = function(competitorId, considerProc) {
        var competitorDomElement;
        competitorDomElement = $('#competitor_' + competitorId);
        if (considerProc === false || this.options['competitor_name_proc'] === void 0 || $(competitorDomElement).find('.competitor_name').data('proc-argument') === void 0) {
          return $(competitorDomElement).find('.competitor_name').html();
        } else {
          return this.options['competitor_name_proc']($(competitorDomElement).find('.competitor_name').data('proc-argument'));
        }
      };

      CompetitiveList.prototype.cancelTournament = function() {
        this.sortByMostWins();
        this.$el.find('.save_match_results_link').hide();
        return $('#bootstrap_modal').modal('hide');
      };

      CompetitiveList.prototype.appointWinnerOfMatchByInput = function() {
        var loserId, winnerId;
        winnerId = parseInt($("input[name='winner']:checked").val());
        loserId = this.otherCompetitorOfMatch(this.currentMatch, winnerId);
        this.appointWinnerOfMatch(this.currentMatchIndex, winnerId, loserId, true);
        return this.nextMatch(false);
      };

      CompetitiveList.prototype.appointWinnerOfMatch = function(matchIndex, winnerId, loserId, decrementMatchesLeft) {
        if (this.movingCompetitorToPosition === true) {
          delete this.matches[matchIndex]['manual_winner_changed'];
          delete this.matches[matchIndex]['auto_winner'];
          delete this.matches[matchIndex]['foot_note_competitor'];
          delete this.matches[matchIndex]['auto_winner_type'];
          delete this.matches[matchIndex]['auto_winner_recursion'];
          delete this.matches[matchIndex]['auto_winner_reason'];
        }
        this.matches[matchIndex]['winner'] = winnerId;
        if (decrementMatchesLeft) {
          this.matchesLeft = this.matchesLeft - 1;
        }
        this.updateDefeatedAndOutmatchedCompetitorsByCompetitor(winnerId, loserId);
        this.letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser(winnerId, loserId);
        return this.letOutMatchedCompetitorsOfWinnerWinAgainstLoser(winnerId, loserId);
      };

      CompetitiveList.prototype.updateDefeatedAndOutmatchedCompetitorsByCompetitor = function(winnerId, loserId) {
        var base, base1;
        (base = this.defeatedCompetitorsByCompetitor)[winnerId] || (base[winnerId] = []);
        this.defeatedCompetitorsByCompetitor[winnerId].push(loserId);
        (base1 = this.outmatchedCompetitorsByCompetitor)[loserId] || (base1[loserId] = []);
        return this.outmatchedCompetitorsByCompetitor[loserId].push(winnerId);
      };

      CompetitiveList.prototype.letWinnerWinMatchesAgainstCompetitorsWhichLoseAgainstLoser = function(winnerId, loserId) {
        var base;
        (base = this.defeatedCompetitorsByCompetitor)[loserId] || (base[loserId] = []);
        return $.each(this.matches, (function(_this) {
          return function(index, match) {
            var manual_winner_changed, matchCompetitorsWhichHaveBeenDefeatedByLoser, otherLoserId;
            if (match['winner'] === winnerId || $.inArray(winnerId, match['competitors']) === -1) {
              return true;
            }
            matchCompetitorsWhichHaveBeenDefeatedByLoser = jQuery.map(match['competitors'], function(c) {
              if ($.inArray(c, _this.defeatedCompetitorsByCompetitor[loserId]) > -1) {
                return c;
              }
            });
            if (matchCompetitorsWhichHaveBeenDefeatedByLoser.length === 0) {
              return true;
            }
            otherLoserId = _this.otherCompetitorOfMatch(match, winnerId);
            manual_winner_changed = false;
            if (match['winner'] !== void 0) {
              _this.removeCompetitorsComparisonResult(winnerId, otherLoserId);
              if (!(_this.movingCompetitorToPosition === true || match['auto_winner'] === true)) {
                manual_winner_changed = true;
              }
            }
            _this.appointWinnerOfMatch(index, winnerId, otherLoserId, match['winner'] === void 0);
            if (_this.movingCompetitorToPosition === true) {
              return true;
            }
            _this.matches[index]['manual_winner_changed'] = manual_winner_changed;
            _this.matches[index]['auto_winner'] = true;
            _this.matches[index]['foot_note_competitor'] = loserId;
            _this.matches[index]['auto_winner_type'] = 0;
            if (winnerId === _this.currentMatch['winner'] && loserId === _this.otherCompetitorOfMatch(_this.currentMatch, _this.currentMatch['winner'])) {
              _this.matches[index]['auto_winner_recursion'] = false;
              _this.matches[index]['auto_winner_reason'] = 'loser has been defeated because he loses against the loser <sup>[1]</sup> of last match';
            } else {
              _this.matches[index]['auto_winner_recursion'] = true;
              _this.matches[index]['auto_winner_reason'] = 'loser has been defeated because he loses against the loser <sup>[1]</sup> of last auto winner match';
            }
            return _this.currentAutoWinnerMatches.push(_this.matches[index]);
          };
        })(this));
      };

      CompetitiveList.prototype.removeCompetitorsComparisonResult = function(winnerId, loserId) {
        var base;
        (base = this.outmatchedCompetitorsByCompetitor)[winnerId] || (base[winnerId] = []);
        this.outmatchedCompetitorsByCompetitor[winnerId] = this.removeItemFromArray(this.outmatchedCompetitorsByCompetitor[winnerId], loserId);
        return this.defeatedCompetitorsByCompetitor[loserId] = this.removeItemFromArray(this.defeatedCompetitorsByCompetitor[loserId], winnerId);
      };

      CompetitiveList.prototype.letOutMatchedCompetitorsOfWinnerWinAgainstLoser = function(winnerId, loserId) {
        var base;
        (base = this.outmatchedCompetitorsByCompetitor)[winnerId] || (base[winnerId] = []);
        return $.each(this.outmatchedCompetitorsByCompetitor[winnerId], (function(_this) {
          return function(index, competitorId) {
            return $.each(_this.matches, function(index, match) {
              var manual_winner_changed;
              if ($.inArray(competitorId, match['competitors']) > -1 && $.inArray(loserId, match['competitors']) > -1 && match['winner'] !== competitorId) {
                manual_winner_changed = false;
                if (match['winner'] !== void 0) {
                  _this.removeCompetitorsComparisonResult(competitorId, loserId);
                  if (!(_this.movingCompetitorToPosition === true || match['auto_winner'] === true)) {
                    manual_winner_changed = true;
                  }
                }
                _this.appointWinnerOfMatch(index, competitorId, loserId, match['winner'] === void 0);
                if (_this.movingCompetitorToPosition === true) {
                  return true;
                }
                _this.matches[index]['manual_winner_changed'] = manual_winner_changed;
                _this.matches[index]['auto_winner'] = true;
                _this.matches[index]['auto_winner_type'] = 1;
                _this.matches[index]['foot_note_competitor'] = winnerId;
                if (winnerId === _this.currentMatch['winner'] && loserId === _this.otherCompetitorOfMatch(_this.currentMatch, _this.currentMatch['winner'])) {
                  _this.matches[index]['auto_winner_recursion'] = false;
                  _this.matches[index]['auto_winner_reason'] = "loser of last match has been defeated by outmatched competitor of<br/>winner <sup>[1]</sup>";
                } else {
                  _this.matches[index]['auto_winner_recursion'] = true;
                  _this.matches[index]['auto_winner_reason'] = "loser of last auto winner match has been defeated by outmatched competitor of winner <sup>[1]</sup>";
                }
                _this.currentAutoWinnerMatches.push(match);
                return false;
              }
            });
          };
        })(this));
      };

      CompetitiveList.prototype.moveCompetitorToPosition = function(competitorId, position, after_update_request_proc) {
        var defeatedCompetitor, outmatchedCompetitor, positionOfdefeatedCompetitor, positions;
        if (after_update_request_proc == null) {
          after_update_request_proc = null;
        }
        this.movingCompetitorToPosition = true;
        this.setCompetitors();
        this.competitorsOfCompetitor = {};
        this.removeMatchesOfNonExistingCompetitors();
        this.generateMatches();
        positions = this.getPositions();
        outmatchedCompetitor = null;
        defeatedCompetitor = null;
        positionOfdefeatedCompetitor = positions[position] === competitorId ? position + 1 : position;
        if (position > Object.keys(positions).length) {
          alert('This position is not available!');
          if (after_update_request_proc !== null) {
            after_update_request_proc();
          }
          this.movingCompetitorToPosition = false;
          return;
        }
        if (!(position === 1 || (position - 1) > Object.keys(positions).length)) {
          outmatchedCompetitor = positions[position - 1];
        }
        if (!(positionOfdefeatedCompetitor > Object.keys(positions).length)) {
          defeatedCompetitor = positions[positionOfdefeatedCompetitor];
        }
        $.each(this.matches, (function(_this) {
          return function(index, match) {
            var loserId, otherCompetitorId, winnerId;
            if ($.inArray(competitorId, match['competitors']) === -1) {
              return true;
            }
            winnerId = null;
            loserId = null;
            otherCompetitorId = _this.otherCompetitorOfMatch(match, competitorId);
            if (otherCompetitorId === outmatchedCompetitor && match['winner'] !== otherCompetitorId) {
              winnerId = otherCompetitorId;
              loserId = competitorId;
              outmatchedCompetitor = null;
            } else if (otherCompetitorId === defeatedCompetitor && match['winner'] !== competitorId) {
              winnerId = competitorId;
              loserId = otherCompetitorId;
              defeatedCompetitor = null;
            }
            if (winnerId === null) {
              return true;
            }
            if (match['winner'] !== void 0) {
              _this.removeCompetitorsComparisonResult(winnerId, loserId);
            }
            _this.currentMatch = match;
            _this.currentMatchIndex = index;
            _this.appointWinnerOfMatch(index, winnerId, loserId, false);
            if (outmatchedCompetitor === null && defeatedCompetitor === null) {
              return false;
            }
          };
        })(this));
        this.sortByMostWins(after_update_request_proc);
        return this.movingCompetitorToPosition = false;
      };

      CompetitiveList.prototype.sortByMostWins = function(after_update_request_proc) {
        var $wrapper, data, positions, winsByCompetitor;
        if (after_update_request_proc == null) {
          after_update_request_proc = null;
        }
        winsByCompetitor = {};
        $.each(this.competitors, (function(_this) {
          return function(index, competitorId) {
            return winsByCompetitor[competitorId] = 0;
          };
        })(this));
        $.each(this.matches, (function(_this) {
          return function(index, match) {
            delete _this.matches[index]['auto_winner_reason'];
            return winsByCompetitor[match['winner']] += 1;
          };
        })(this));
        $.each(Object.keys(winsByCompetitor), function(index, competitorId) {
          return $('#competitor_' + competitorId).data('wins', winsByCompetitor[competitorId]);
        });
        $wrapper = this.$el.find('.competitive_list');
        $wrapper.find('li').sort(function(a, b) {
          return +parseInt($(b).data('wins')) - +parseInt($(a).data('wins'));
        }).appendTo($wrapper);
        positions = this.getPositions();
        if ($wrapper.data('update-all-positions-path') !== void 0) {
          data = {
            _method: 'put',
            positions: positions,
            matches: JSON.stringify(this.matches)
          };
          return $.post($wrapper.data('update-all-positions-path'), data).always((function(_this) {
            return function() {
              if (after_update_request_proc !== null) {
                return after_update_request_proc();
              }
            };
          })(this));
        }
      };

      CompetitiveList.prototype.getPositions = function() {
        var currentPosition, positions;
        positions = {};
        currentPosition = 1;
        $.each(this.$el.find('.competitive_list li'), function(index, element) {
          positions[currentPosition] = $(element).data('id');
          $(element).data('position', currentPosition);
          $(element).find('.competitor_position').html(currentPosition);
          return currentPosition += 1;
        });
        return positions;
      };

      return CompetitiveList;

    })();
    $.pluginFactory = function(plugin) {
      return $.fn[plugin.prototype.jqueryInstanceMethodName] = function(options) {
        var after, args;
        args = $.makeArray(arguments);
        after = args.slice(1);
        return this.each(function() {
          var instance;
          instance = $.data(this, plugin.prototype.jqueryInstanceMethodName);
          if (instance) {
            if (typeof options === 'string') {
              return instance[options].apply(instance, after);
            } else if (instance.update) {
              return instance.update.apply(instance, args);
            }
          } else {
            return new plugin(this, options);
          }
        });
      };
    };
    return $.pluginFactory(CompetitiveList);
  })(window.jQuery, window);

}).call(this);