expect  = require('chai').expect
sinon   = require 'sinon'
Promise = require 'bluebird'
fs      = require 'fs'

Checker = require('../../lib/checker')

describe 'checker', ->
  checker = undefined

  multiDone = (numCalls, done) ->
    currentCalls = 0
    ->
      currentCalls++
      if currentCalls == numCalls
        done()

  before ->
    checker = new Checker()

    # Totally stub out the data so it doesn't
    # do any remote calls
    sinon.stub checker, 'getHttpData', (url) ->
      new Promise (resolve, reject) ->
        if url == Checker::PRIME
          fs.readFile './test/resources/prime.json', 'utf8', (err, data) ->
            resolve(data)
        else if url == Checker::EAST
          fs.readFile './test/resources/east.json', 'utf8', (err, data) ->
            resolve(data)

  describe 'getLatestId', ->
    it 'gets the latest id for the given URL', (reallyDone) ->
      done = multiDone(2, reallyDone)

      checker.getLatestId(Checker::PRIME)
        .then (id) ->
          expect(id).to.equal 3852445
        .finally ->
          done()

      checker.getLatestId(Checker::EAST)
        .then (id) ->
          expect(id).to.equal 3787058
        .finally ->
          done()

  describe 'hasUpdate', ->
    it "tells me if there is an update based on my known id", (reallyDone) ->
      done = multiDone(3, reallyDone)

      checker.hasUpdate(Checker::PRIME, 3852445)
        .then (updated) ->
          expect(updated).to.be.false
        .finally ->
          done()

      checker.hasUpdate(Checker::PRIME, 3750599)
        .then (updated) ->
          expect(updated).to.be.true
        .finally ->
          done()

      checker.hasUpdate(Checker::EAST, 3787058)
        .then (updated) ->
          expect(updated).to.be.false
        .finally ->
          done()

  describe 'generateUrl', ->
    it "gives the full URL to the registration page when given an id", ->
      expect(checker.generateUrl(12345)).to.equal "http://www.showclix.com/event/12345"
