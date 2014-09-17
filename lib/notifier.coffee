Promise  = require 'bluebird'
config   = require '../config'
sendgrid = require('sendgrid')(config.SENDGRID_USERNAME, config.SENDGRID_PASSWORD)
_        = require 'lodash'

User     = require './models/user'
Checker  = require './checker'

class Notifier
  constructor: (event, eventId, log) ->
    @log = log
    @checker = new Checker()

    log.info "Notifying users of event update:", event
    User.where(@eventCheckField(event), true).exec (err, users) =>
      if users
        _.each users, (user) =>
          _.each user.notifications, (notification) =>
            switch notification.type
              when "email" then @sendEmail(notification, user, event, eventId)
              when "sms" then @sendSMS(notification, user, event, eventId)

  sendEmail: (notification, user, event, eventId) ->
    @log.debug 'Sending email to:', notification.toJSON()
    email = new sendgrid.Email
      to: notification.address
      from: 'no-reply@tedkulp.com'
      subject: 'PAX Event Alert'
      text: """
Hi there.

We just wanted to let you know that registration opened up for
PAX #{event}. Head on over there and signup, before all those
tickets are gone. Seriously, stop reading this and get over there!

Go! Go! Go!

#{@checker.generateUrl(eventId)}

Hugs,
Pax Checker
      """

    @log.debug email

    sendgrid.send email, (err, json) =>
      if err
        @log.error 'Error sending email: ', err.toString()
      else
        @log.debug json

  sendSMS: (notification, user, event, eventId) ->
    @log.debug 'Sending SMS to:', notification.toJSON()

  eventCheckField: (event) ->
    event = event.toLowerCase()
    'check' + event[0].toUpperCase() + event.slice(1)

module.exports = exports = Notifier
