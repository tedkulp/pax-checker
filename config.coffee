module.exports = exports =
  TOKEN_SECRET: process.env.TOKEN_SECRET || '123456'
  MONGO_URL: process.env.MONGO_URL || process.env.MONGOHQ_URL || 'mongodb://localhost/paxchecker_dev'
