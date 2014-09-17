module.exports = exports =
  TOKEN_SECRET: process.env.TOKEN_SECRET || '123456'
  MONGO_URL: process.env.MONGO_URL || process.env.MONGOHQ_URL || 'mongodb://localhost/paxchecker_dev'
  SENDGRID_USERNAME: process.env.SENDGRID_USERNAME || 'testuser'
  SENDGRID_PASSWORD: process.env.SENDGRID_PASSWORD || '123456'
