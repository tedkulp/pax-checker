jwt        = require 'jwt-simple'
express    = require 'express'
bodyParser = require 'body-parser'
app        = express()
http       = require('http').Server(app)
io         = require('socket.io')(http)
moment     = require 'moment'
_          = require 'lodash'
Promise    = require 'bluebird'
request    = require 'request'

log        = require './lib/logger'
config     = require './config'
User       = require './lib/models/user'
Manager    = require './lib/state_manager'

app.use require('morgan')('combined', { 'stream': log.stream })
app.use express.static('public')
app.use '/css/fonts', express.static('public/fonts/ext')
app.use '/css/img', express.static('public/images/ext')

app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

manager = new Manager(log)

ensureAuthenticated = (req, res, next) ->
  if !req.headers.authorization
    return res.status(401).send({ message: 'Please make sure your request has an Authorization header' })

  token = req.headers.authorization.split(' ')[1]
  payload = jwt.decode(token, config.TOKEN_SECRET)

  if payload.exp <= Date.now()
    return res.status(401).send({ message: 'Token has expired' })

  req.user = payload.sub
  next()

createToken = (req, user) ->
  payload =
    iss: req.hostname
    sub: user._id
    iat: moment().valueOf()
    exp: moment().add(14, 'days').valueOf()

  jwt.encode payload, config.TOKEN_SECRET

# app.get '/', (req, res) ->
#   console.log req
#   res.sendfile('index.html')

app.post '/auth/login', (req, res) ->
  User.findOne { email: req.body.email }, '+password', (err, user) ->
    if !user
      return res.status(401).send({ message: 'Wrong email and/or password' })

    user.comparePassword req.body.password, (err, isMatch) ->
      if !isMatch
        return res.status(401).send({ message: 'Wrong email and/or password' })

      res.send({ token: createToken(req, user) })

app.post '/auth/signup', (req, res) ->
  user = new User()
  user.email = req.body.email
  user.password = req.body.password
  user.save (err) ->
    res.status(200).end()

app.get '/api/v1/profile', ensureAuthenticated, (req, res) ->
  User.findOne { _id: req.user }, (err, user) ->
    res.send(user)

app.put '/api/v1/profile', ensureAuthenticated, (req, res) ->
  User.findOne { _id: req.user }, (err, user) ->
    user.set req.body
    user.save (err) ->
      res.status(200).end()

# Because of pushstate
_.each ['/profile', '/signup', '/login'], (path) ->
  app.get path, (request, response) ->
    response.sendfile './public/index.html'

app.get '/profile', (request, response) ->
  response.sendfile './public/index.html'

app.get '/ping', (request, response) ->
  log.info "PONG"
  response.send 'OK'

io.on 'connection', (socket) ->
  log.debug 'a user connected'

pinger = ->
  port = process.env.PORT || 3000
  service_url = (process.env.SERVICE_URL || "http://localhost:#{port}") + "/ping"
  request service_url, (err, res, html) ->
    if err
      log.error err

setupPinger = ->
  setInterval ->
    pinger()
  , 60 * 15 * 1000 # 15 min

setupPinger()

port = process.env.PORT || 3000
http.listen port, ->
  log.info 'listening on *:' + port
