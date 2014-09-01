mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/paxchecker_dev'

exports = module.exports = mongoose
