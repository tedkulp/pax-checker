mongoose = require 'mongoose'
config   = require '../config'

mongoose.connect config.MONGO_URL

exports = module.exports = mongoose
