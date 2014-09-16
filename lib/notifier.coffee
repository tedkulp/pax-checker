Promise = require 'bluebird'
_       = require 'lodash'

User    = require './models/user'

class Notifier
  constructor: (event, log) ->
    @log = log

    log.info "Notifying users of event update:", event
    User.where(@eventCheckField(event), true).exec (err, users) =>
      if users
        _.each users, (user) =>
          _.each user.notifications, (notification) =>
            switch notification.type
              when "email" then @sendEmail(notification, user)
              when "sms" then @sendSMS(notification, user)

  sendEmail: (notification, user) ->
    @log.debug 'Sending email to:', notification.toJSON()

  sendSMS: (notification, user) ->
    @log.debug 'Sending SMS to:', notification.toJSON()

  eventCheckField: (event) ->
    event = event.toLowerCase()
    'check' + event[0].toUpperCase() + event.slice(1)

module.exports = exports = Notifier
