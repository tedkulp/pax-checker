Promise    = require 'bluebird'
_          = require 'lodash'

Checker    = require './checker'
Notifier   = require './notifier'

class StateManager
  constructor: (log) ->
    @log = log
    @checker = new Checker()
    @updateDelay = 60 * 1000
    @currentIds =
      PRIME: 0
      DEV: 0
      EAST: 0
      SOUTH: 0
      AUS: 0

    Promise.all(_.map @checker.getUrls(), (value, key) =>
      @checker.getLatestId(value)
        .then (id) =>
          @log.debug key, typeof key
          @currentIds[key] = id
    ).then =>
      @log.info 'CurrentIds', @currentIds
      # @currentIds['EAST'] = 1500
      _.delay(@updateCheck, @updateDelay)

  updateCheck: =>
    Promise.all(_.map @checker.getUrls(), (value, key) =>
      @log.debug value, @currentIds[key], key
      @checker.hasUpdate(value, @currentIds[key])
        .spread (result, newId) =>
          if result
            @log.debug key, 'has an update... let all subs know', result, newId
            new Notifier(key, @log)
            @currentIds[key] = newId
          else
            @log.debug 'No updates'
    ).finally =>
      _.delay(@updateCheck, @updateDelay)

module.exports = exports = StateManager
