winston = require('winston')
winston.emitErrs = true

logger = new winston.Logger
  transports: [
    # new winston.transports.File
    #   level: 'info',
    #   filename: './logs/all-logs.log',
    #   handleExceptions: true,
    #   json: true,
    #   maxsize: 5242880,
    #   maxFiles: 5,
    #   colorize: false
    new winston.transports.Console
      level: if process.env.DEBUG then 'debug' else 'info',
      handleExceptions: true,
      json: false,
      colorize: true
  ]
  exitOnError: false

module.exports = logger
module.exports.stream =
  write: (message, encoding) ->
    logger.info(message.trim().replace(/(\r\n|\n|\r)/gm, ''))
