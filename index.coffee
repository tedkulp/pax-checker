jwt        = require 'jwt-simple'
express    = require 'express'
bodyParser = require 'body-parser'
app        = express()
http       = require('http').Server(app)
io         = require('socket.io')(http)
moment     = require 'moment'

config     = require './config'
User       = require './lib/models/user'

app.use express.static('public')
app.use '/css/fonts', express.static('public/fonts/ext')

app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

ensureAuthenticated = (req, res, next) ->
  if !req.headers.authorization
    return res.status(401).send({ message: 'Please make sure your request has an Authorization header' })

  token = req.headers.authorization.split(' ')[1]
  payload = jwt.decode(token, config.TOKEN_SECRET);

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
  console.log req
  res.status(200).end()

io.on 'connection', (socket) ->
  console.log 'a user connected'

http.listen 3000, ->
  console.log 'listening on *:3000'
