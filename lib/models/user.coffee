database   = require '../database'
timestamps = require 'mongoose-times'
bcrypt     = require 'bcryptjs'
hidden     = require('mongoose-hidden')()

notificationSchema = new database.Schema
  type: String
  address: String

userSchema = new database.Schema
  email:
    type: String
    unique: true
    lowercase: true
  password:
    type: String
    select: true
    hide: true
  firstName: String
  lastName: String
  checkPrime: Boolean
  checkEast: Boolean
  checkSouth: Boolean
  checkAus: Boolean
  notifications: [notificationSchema]

userSchema.pre 'save', (next) ->
  user = this

  if !user.isModified 'password'
    return next()

  bcrypt.genSalt 10, (err, salt) ->
    bcrypt.hash user.password, salt, (err, hash) ->
      user.password = hash
      next()

userSchema.methods.comparePassword = (password, done) ->
  bcrypt.compare password, this.password, (err, isMatch) ->
    done err, isMatch

userSchema.plugin timestamps, { created: "createdAt", lastUpdated: "updatedAt" }
userSchema.plugin hidden

exports = module.exports = database.model 'User', userSchema
