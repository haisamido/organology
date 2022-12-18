//Load express module with `require` directive
const express = require('express')
const bodyParser = require('body-parser')
const db = require('./queries')
const app = express()
app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

//Define port
const port = 3000

//Define request response in root URL (/)
app.get('/', function (req, res) {
  res.send('Hello World!')
})

app.get('/a', (request, response) => {
    response.json({ info: 'Node.js, Express, and Postgres API' })
  })

app.get('/users', db.getUsers)
app.get('/users/:id', db.getUserById)
app.post('/users', db.createUser)
app.put('/users/:id', db.updateUser)
app.delete('/users/:id', db.deleteUser)

//Launch listening server on port 3000
app.listen(port, function () {
  console.log('app listening on port ${port}!')
})
