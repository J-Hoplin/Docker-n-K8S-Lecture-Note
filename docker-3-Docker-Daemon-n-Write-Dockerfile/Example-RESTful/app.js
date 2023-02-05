const express = require('express')
const logger = require('morgan')
const dotenv = require('dotenv')

dotenv.config()
const app = express()


app.set('port', process.env.PORT || 3000)
app.use(logger('combined'))

app.get('/ping', (req, res) => {
    return res.status(200).json(
        {
            msg: "OK"
        }
    )
})

app.get('/env-test', (req, res) => {
    return res.status(200).json(
        {
            msg: process.env.EXAMPLEVAR
        }
    )
})

app.use((req, res, next) => {
    const err = new Error(`${req.method} ${req.route} router not found`)
    err.code = 404;
    return next(err)
})

app.use((err, req, res, next) => {
    return res.status(err.code || 500).json(
        {
            msg: err.message
        }
    )
})

app.listen(app.get('port'), () => {
    console.log(`listening on port ${app.get('port')}`)
})