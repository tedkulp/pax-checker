express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.use express.static('public')
app.use '/css/fonts', express.static('public/fonts/ext')

app.get '/', (req, res) ->
  res.sendfile('index.html')

io.on 'connection', (socket) ->
  console.log 'a user connected'

http.listen 3000, ->
  console.log 'listening on *:3000'
