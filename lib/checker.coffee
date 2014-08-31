request = require 'request'
Promise = require 'bluebird'
_       = require 'lodash'

class Checker
  PRIME: "http://api.showclix.com/Seller/16885/events"
  DEV:   "http://api.showclix.com/Seller/16885/events"
  EAST:  "http://api.showclix.com/Seller/17792/events"
  SOUTH: "http://api.showclix.com/Seller/19042/events"
  AUS:   "http://api.showclix.com/Seller/15374/events"

  getLatestId: (url) ->
    new Promise (resolve, reject) =>
      @getHttpData(url)
        .then (html) ->
          resolve(
            _(JSON.parse(html))
              .keys()
              .map (val) ->
                parseInt(val)
              .max()
              .value()
          )
        .catch (err) ->
          reject(err)

  hasUpdate: (url, currentId) ->
    new Promise (resolve, reject) =>
      @getLatestId(url)
        .then (id) ->
          resolve(id > currentId)
        .catch (err) ->
          reject(err)

  getHttpData: (url) ->
    console.log 'here?'
    new Promise (resolve, reject) ->
      request url, (err, resp, html) ->
        if err
          reject err
        else
          resolve html

  generateUrl: (eventId) ->
    "http://www.showclix.com/event/#{eventId}"

module.exports = exports = Checker
